library ieee;
use ieee.std_logic_1164.all;
USE ieee.numeric_std.ALL; 


------------------------------------------------------------------------
-- Module Declaration
------------------------------------------------------------------------
entity camera is
   port (
 
       camera_refresh_rate : in STD_LOGIC;      -- SW 13 - Set the vertical refresh rate of the camera ( 0 = 15Hz, 1 = 30Hz )

                                                 -- SW 15:14 - Adjust current drive setting for OV7670 chip
       ov7670_drive : in std_logic_vector( 1 downto 0 );
       EnableWrite : in std_logic;
       video_source_switch : in std_logic;
       
       previous_picture_button : in STD_LOGIC;
       next_picture_button : in STD_LOGIC;
       replay_video : in STD_LOGIC;
       

       vga_red : out std_logic_vector( 3 downto 0 );
       vga_green : out std_logic_vector( 3 downto 0 );
       vga_blue : out std_logic_vector( 3 downto 0 );

       h_sync_signal : out std_logic;
       v_sync_signal : out std_logic;

       stream_select : in std_logic_vector( 2 downto 0 );
       filter_options : in std_logic_vector( 1 downto 0 );

       clock : in std_logic;
       camera_configured : out std_logic;

	   ov7670_pclk  : in  STD_LOGIC;
	   ov7670_xclk  : out STD_LOGIC;
	   ov7670_vsync : in  STD_LOGIC;
	   ov7670_href  : in  STD_LOGIC;
	   ov7670_data  : in  STD_LOGIC_vector(7 downto 0);
	   ov7670_sioc  : out STD_LOGIC;
	   ov7670_siod  : inout STD_LOGIC;
	   ov7670_pwdn  : out STD_LOGIC;
	   ov7670_reset : out STD_LOGIC;

       state_machine_status : out STD_LOGIC_VECTOR( 12 downto 0 );

-- 
-- DDR2 interface
--
       ddr2_addr            : out   std_logic_vector(12 downto 0);
       ddr2_ba              : out   std_logic_vector(2 downto 0);
       ddr2_ras_n           : out   std_logic;
       ddr2_cas_n           : out   std_logic;
       ddr2_we_n            : out   std_logic;
       ddr2_ck_p            : out   std_logic_vector(0 downto 0);
       ddr2_ck_n            : out   std_logic_vector(0 downto 0);
       ddr2_cke             : out   std_logic_vector(0 downto 0);
       ddr2_cs_n            : out   std_logic_vector(0 downto 0);
       ddr2_dm              : out   std_logic_vector(1 downto 0);
       ddr2_odt             : out   std_logic_vector(0 downto 0);
       ddr2_dq              : inout std_logic_vector(15 downto 0);
       ddr2_dqs_p           : inout std_logic_vector(1 downto 0);
       ddr2_dqs_n           : inout std_logic_vector(1 downto 0);
       reset_state_machine : in STD_LOGIC;
       configure_camera : in STD_LOGIC;
       
       QSPI_SDI : out STD_LOGIC;
       QSPI_SDO : in STD_LOGIC;
       QSPI_WP : out STD_LOGIC;
       QSPI_HLD : in STD_LOGIC;
       QSPI_CS : out STD_LOGIC;
       
--
-- OLED related signals
--
       oled_sck : out std_logic;
       oled_sda : out std_logic;

--
-- Active low signal to reset the display
--        
       oled_reset : out std_logic;

--
-- Data/command signal ( data = '1', command = '0' )
--
       oled_dc : out std_logic;

--
-- Active low chip select signal
--
       oled_cs : out std_logic;


--
--  
--
       text_or_graphics_mode : in std_logic
 
   );
end camera;

architecture Behavioral of camera is

constant SCREEN_X_SIZE : UNSIGNED( 10 downto 0 ) := to_unsigned( 640, 11 );
constant SCREEN_Y_SIZE : UNSIGNED( 9 downto 0 ) := to_unsigned( 480, 10 );


------------------------------------------------------------------------
-- Component Declarations
------------------------------------------------------------------------


component video is 
    port (
        board_clock : in STD_LOGIC;
        video_source_switch : in STD_LOGIC;
        previous_picture_button : in STD_LOGIC;
        next_picture_button : in STD_LOGIC;
        replay_video : in STD_LOGIC;

--
-- OV7670 camera inputs
--     
         ov7670_pclk : in STD_LOGIC;
         ov7670_vsync : in STD_LOGIC;
         ov7670_href : in STD_LOGIC;
         ov7670_data : in STD_LOGIC_VECTOR( 7 downto 0 );

         ov7670_sioc : out STD_LOGIC;
         ov7670_siod : inout STD_LOGIC;
         ov7670_reset : out STD_LOGIC;
         ov7670_pwdn : out STD_LOGIC;
         ov7670_xclk : out STD_LOGIC;
         ov7670_drive : in STD_LOGIC_VECTOR( 1 downto 0 );
         ov7670_refresh_rate : in STD_LOGIC;   
    

--
-- Video stream 1 output
--
        stream1_pixel : out STD_LOGIC_VECTOR( 11 downto 0 );
    
--
-- Video stream 2 output
--
        stream2_pixel : out STD_LOGIC_VECTOR( 11 downto 0 );

--
-- Video stream 3 output
--
        stream3_pixel : out STD_LOGIC_VECTOR( 11 downto 0 );


--
-- RGB video signals 
-- 
        video_pixel : in STD_LOGIC_VECTOR( 11 downto 0 );
        video_h_dot : out UNSIGNED( 10 downto 0 );
        video_v_line : out UNSIGNED( 9 downto 0 );
        video_h_sync : out STD_LOGIC;
        video_v_sync : out STD_LOGIC;
        video_visible_frame : out STD_LOGIC;
        
        video_vga_red : out std_logic_vector( 3 downto 0 );
        video_vga_green : out std_logic_vector( 3 downto 0 );
        video_vga_blue : out std_logic_vector( 3 downto 0 );
        video_clock : out STD_LOGIC;

--
-- Configuration signals
--

        configure_camera : in STD_LOGIC;
        write_enable : in STD_LOGIC;
        camera_configured : out STD_LOGIC;
        
--
-- State machine status
--
        status_leds : out STD_LOGIC_VECTOR( 12 downto 0 );

--
-- DDR2 interface
--
        ddr2_addr            : out   std_logic_vector(12 downto 0);
        ddr2_ba              : out   std_logic_vector(2 downto 0);
        ddr2_ras_n           : out   std_logic;
        ddr2_cas_n           : out   std_logic;
        ddr2_we_n            : out   std_logic;
        ddr2_ck_p            : out   std_logic_vector(0 downto 0);
        ddr2_ck_n            : out   std_logic_vector(0 downto 0);
        ddr2_cke             : out   std_logic_vector(0 downto 0);
        ddr2_cs_n            : out   std_logic_vector(0 downto 0);
        ddr2_dm              : out   std_logic_vector(1 downto 0);
        ddr2_odt             : out   std_logic_vector(0 downto 0);
        ddr2_dq              : inout std_logic_vector(15 downto 0);
        ddr2_dqs_p           : inout std_logic_vector(1 downto 0);
        ddr2_dqs_n           : inout std_logic_vector(1 downto 0);
      
        clock_200Mhz         : out STD_LOGIC;
        --reset : in STD_LOGIC;
      
        reset_state_machine : in STD_LOGIC;
        
         QSPI_SDI : out STD_LOGIC;
         QSPI_SDO : in STD_LOGIC;
         QSPI_WP : out STD_LOGIC;
         QSPI_HLD : in STD_LOGIC;
         QSPI_CS : out STD_LOGIC
        
    );
    end component;


component oled_display is
    Port (

--
-- basys 3 clock at 100Mhz
--
        board_clock : in std_logic;

--
-- OLED related signals
--
        oled_sck : out std_logic;
        oled_sda : out std_logic;

--
-- Active low signal to reset the display
--        
        oled_reset : out std_logic;

--
-- Data/command signal ( data = '1', command = '0' )
--
        oled_dc : out std_logic;

--
-- Active low chip select signal
--
        oled_cs : out std_logic;


--
--  
--
        text_or_graphics_mode : in std_logic;
        EnableWrite : in std_logic;
        replay_video : in STD_LOGIC;
        video_source_switch : in std_logic;
        stream_select : in std_logic_vector( 2 downto 0 );
        camera_refresh_rate : in STD_LOGIC;
        ov7670_drive : in std_logic_vector( 1 downto 0 );
        cursor_enabled : in std_logic;
        
        v_sync : in std_logic;
        h_sync : in std_logic;
        v_line : in UNSIGNED( 9 downto 0 );
        h_dot : in UNSIGNED( 10 downto 0 );
        gray_bit : in std_logic;
        video_clock : in std_logic;
        visible_frame : in std_logic
    );
end component;



    
component histogram is
    generic (
        origin_x : UNSIGNED( 10 downto 0 );
        origin_y : UNSIGNED( 9 downto 0 );
        color : STD_LOGIC_VECTOR( 11 downto 0 )
    );
    Port (
        video_clock : in STD_LOGIC;
        v_sync : in STD_LOGIC;
        h_dot : in UNSIGNED( 10 downto 0 );
        v_line : in UNSIGNED( 9 downto 0 );
        bin : in UNSIGNED( 3 downto 0 );
        visible_frame : in STD_LOGIC;
    
        active : out STD_LOGIC;
        pixel_color : out STD_LOGIC_VECTOR( 11 downto 0 ) 
    );
end component;

component RGBtoGray is
    Port (
        RGBin : in STD_LOGIC_VECTOR (11 downto 0);
        GrayOut : out STD_LOGIC_VECTOR (11 downto 0)
    );
end component;

component negative_image is
    port (
        pixel_in : in STD_LOGIC_VECTOR (11 downto 0);
        pixel_out : out STD_LOGIC_VECTOR (11 downto 0)
    );
end component;

component sad_filter is
    Port (
        pixel_1_in : in STD_LOGIC_VECTOR( 11 downto 0 );
        pixel_2_in : in STD_LOGIC_VECTOR( 11 downto 0 );
        pixel_out : out STD_LOGIC_VECTOR( 11 downto 0 )
    );
end component;
    
component xor_filter is
    Port (
        pixel_1_in : in STD_LOGIC_VECTOR( 11 downto 0 );
        pixel_2_in : in STD_LOGIC_VECTOR( 11 downto 0 );
        pixel_out : out STD_LOGIC_VECTOR( 11 downto 0 )
    );
end component;    

component sobel_filter is
    generic (
        SCREEN_X_SIZE : UNSIGNED( 10 downto 0 );
        SCREEN_Y_SIZE : UNSIGNED( 9 downto 0 )
    );
    port (
        video_clock : in STD_LOGIC;
        v_sync : in STD_LOGIC;
        visible_frame : in STD_LOGIC;
        filter_options : in STD_LOGIC_VECTOR( 1 downto 0 );
        gray_pixel_in : in STD_LOGIC_VECTOR( 3 downto 0 );

        pixel_out : out STD_LOGIC_VECTOR( 11 downto 0 )
    );
end component;



constant PIXEL_RED : STD_LOGIC_VECTOR( 11 downto 0 ) := "111100000000";
constant PIXEL_GREEN : STD_LOGIC_VECTOR( 11 downto 0 ) := "000011110000";
constant PIXEL_BLUE : STD_LOGIC_VECTOR( 11 downto 0 ) := "000000001111";
constant PIXEL_GRAY : STD_LOGIC_VECTOR( 11 downto 0 ) := "100010001000";

signal clock_200Mhz : STD_LOGIC;

--
-- Video related signals
--
signal visible_frame : STD_LOGIC;
signal v_line : UNSIGNED( 9 downto 0 );
signal h_sync : STD_LOGIC;
signal v_sync : STD_LOGIC;
signal h_dot : UNSIGNED( 10 downto 0 );
signal video_clock : STD_LOGIC;

signal video_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal stream1_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal stream2_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal stream3_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal bit_video : STD_LOGIC;

--
-- Histograms
--

--
-- Histogram red
--

signal histogram_red_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal histogram_red_active : STD_LOGIC;

--
-- Histogram green
--

signal histogram_green_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal histogram_green_active : STD_LOGIC;


--
-- Histogram blue
--

signal histogram_blue_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal histogram_blue_active : STD_LOGIC;


--
-- Histogram gray
--

signal histogram_gray_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal histogram_gray_active : STD_LOGIC;

--
-- Effects
--

signal negative_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal gray_negative_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal sad_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal xor_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal gray_pixel : STD_LOGIC_VECTOR( 11 downto 0 );
signal sobel_pixel : STD_LOGIC_VECTOR( 11 downto 0 );

begin

camera_video : video
    Port map (
        video_source_switch => video_source_switch,
        previous_picture_button => previous_picture_button,
        next_picture_button => next_picture_button,

        status_leds => state_machine_status,
        board_clock => clock,
        
        ov7670_pclk => ov7670_pclk,
        ov7670_vsync => ov7670_vsync,
        ov7670_href => ov7670_href,
        ov7670_data => ov7670_data,
        ov7670_drive => ov7670_drive,
        
        video_pixel => video_pixel,
        write_enable => EnableWrite,
        configure_camera => configure_camera,
        clock_200Mhz => clock_200Mhz,
        video_visible_frame => visible_frame,
        video_v_line => v_line,
     
        ov7670_sioc => ov7670_sioc,
        ov7670_siod => ov7670_siod,
        ov7670_reset => ov7670_reset,
        ov7670_pwdn => ov7670_pwdn,
        ov7670_xclk => ov7670_xclk,
        ov7670_refresh_rate => camera_refresh_rate,
        
        stream1_pixel => stream1_pixel,
        stream2_pixel => stream2_pixel,
        stream3_pixel => stream3_pixel,
        video_h_dot => h_dot,
        camera_configured => camera_configured,
        
        ddr2_addr => ddr2_addr,
        ddr2_ba => ddr2_ba,
        ddr2_ras_n => ddr2_ras_n,
        ddr2_cas_n => ddr2_cas_n,
        ddr2_we_n => ddr2_we_n,
        ddr2_ck_p => ddr2_ck_p,
        ddr2_ck_n => ddr2_ck_n,
        ddr2_cke => ddr2_cke,
        ddr2_cs_n => ddr2_cs_n,
        ddr2_dm => ddr2_dm,
        ddr2_odt => ddr2_odt,
        ddr2_dq => ddr2_dq,
        ddr2_dqs_p => ddr2_dqs_p,
        ddr2_dqs_n => ddr2_dqs_n,
        reset_state_machine => reset_state_machine,
        
        video_vga_red => vga_red,
        video_vga_green => vga_green,
        video_vga_blue => vga_blue,
 
        video_h_sync => h_sync,
        video_v_sync => v_sync,
        video_clock => video_clock,
        QSPI_SDI => QSPI_SDI,
        QSPI_SDO =>  QSPI_SDO,
        QSPI_WP => QSPI_WP,
        QSPI_HLD => QSPI_HLD,
        QSPI_CS => QSPI_CS,
        replay_video => replay_video
     );

 h_sync_signal <= h_sync;
 v_sync_signal <= v_sync;
 
 
 

                                 
histogram_red : histogram
    generic map (
        origin_x => to_unsigned( 10, 11 ),
        origin_y => to_unsigned( 450, 10 ),
        color => PIXEL_RED
        
    )
    port map (    
        video_clock => video_clock,
        v_line => v_line,
        h_dot => h_dot,
        v_sync => v_sync,
        bin => UNSIGNED( stream1_pixel( 11 downto 8 )),
        visible_frame => visible_frame,
         
        
        pixel_color => histogram_red_pixel,
        active => histogram_red_active 
        
    );

histogram_green : histogram
    generic map (
        origin_x => to_unsigned( 90, 11 ),
        origin_y => to_unsigned( 450, 10 ),
        color => PIXEL_GREEN
        
    )
    port map (    
        video_clock => video_clock,
        v_line => v_line,
        h_dot => h_dot,
        v_sync => v_sync,
        bin => UNSIGNED( stream1_pixel( 7 downto 4 )),
        visible_frame => visible_frame, 
        
        pixel_color => histogram_green_pixel,
        active => histogram_green_active 
        
    );

histogram_blue : histogram
    generic map (
        origin_x => to_unsigned( 170, 11 ),
        origin_y => to_unsigned( 450, 10 ),
        color => PIXEL_BLUE
        
    )
    port map (    
        video_clock => video_clock,
        v_line => v_line,
        h_dot => h_dot,
        v_sync => v_sync,
        bin => UNSIGNED( stream1_pixel( 3 downto 0 )),         
        visible_frame => visible_frame,
                
        pixel_color => histogram_blue_pixel,
        active => histogram_blue_active 
        
    );

camera_status : oled_display
    port map (

--
-- basys 3 clock at 100Mhz
--
        board_clock => clock,

--
-- OLED related signals
--
        oled_sck => oled_sck,
        oled_sda => oled_sda,

--
-- Active low signal to reset the display
--        
        oled_reset => oled_reset,

--
-- Data/command signal ( data = '1', command = '0' )
--
        oled_dc => oled_dc,

--
-- Active low chip select signal
--
        oled_cs => oled_cs,


--
--  
--
        text_or_graphics_mode => text_or_graphics_mode,
        EnableWrite => EnableWrite,
        replay_video => replay_video,
        video_source_switch => video_source_switch,
        stream_select => stream_select,
        camera_refresh_rate => camera_refresh_rate,
        ov7670_drive => ov7670_drive,
        cursor_enabled => '0',

        v_sync => v_sync,
        h_sync => h_sync,
        v_line => v_line,
        h_dot => h_dot,
        gray_bit => bit_video, -- sobel_pixel(11),
        video_clock => video_clock, -- bit_video,
        visible_frame => visible_frame

    );


bit_video <= sobel_pixel(11) or sobel_pixel(10); --  or sobel_pixel(9);

histogram_gray : histogram
    generic map (
        origin_x => to_unsigned( 250, 11 ),
        origin_y => to_unsigned( 450, 10 ),
        color => PIXEL_GRAY
        
    )
    port map (    
        video_clock => video_clock,
        v_line => v_line,
        h_dot => h_dot,
        v_sync => v_sync,
        bin => UNSIGNED( gray_pixel( 3 downto 0 )),         
        visible_frame => visible_frame,
                
        pixel_color => histogram_gray_pixel,
        active => histogram_gray_active 
        
    );

convert_to_gray: RGBtoGray
    port map (
        RGBin => stream1_pixel,
        GrayOut => gray_pixel
    );
 
video_negative_image : negative_image
    port map (
        pixel_in => stream1_pixel,
        pixel_out => negative_pixel
    );

video_sad_image : sad_filter
    port map (
        pixel_1_in => stream1_pixel,
        pixel_2_in => stream2_pixel,
        pixel_out => sad_pixel
    );

video_xor_image : xor_filter
    port map (
        pixel_1_in => stream1_pixel,
        pixel_2_in => stream2_pixel,
        pixel_out => xor_pixel
    );
    
video_sobel_image : sobel_filter
    generic map (
        SCREEN_X_SIZE => SCREEN_X_SIZE,
        SCREEN_Y_SIZE => SCREEN_Y_SIZE
    )
    port map (
        video_clock => video_clock,
        visible_frame => visible_frame,
        filter_options => filter_options,
        v_sync => v_sync,
        gray_pixel_in => gray_pixel( 3 downto 0 ),
        pixel_out => sobel_pixel            
    );

video_gray_negative_image : negative_image
    port map (
        pixel_in => gray_pixel,
        pixel_out => gray_negative_pixel
    );

process( 
    stream_select,
    stream1_pixel,
    
    histogram_red_active,
    histogram_red_pixel,

    histogram_green_active,
    histogram_green_pixel,   
    
    histogram_blue_active,
    histogram_blue_pixel,
    
    histogram_gray_active,
    histogram_gray_pixel,
    
    negative_pixel,
    sad_pixel,
    xor_pixel,
    sobel_pixel
)

begin
    if ( histogram_red_active = '1' ) then
        video_pixel <= histogram_red_pixel;
        
    elsif ( histogram_green_active = '1' ) then
        video_pixel <= histogram_green_pixel;
    
    elsif ( histogram_blue_active = '1' ) then
        video_pixel <= histogram_blue_pixel; 

    elsif ( histogram_gray_active = '1' ) then
        video_pixel <= histogram_gray_pixel;    
        
    else
        case( stream_select ) is
            when "000" => video_pixel <= stream1_pixel;
            when "001" => video_pixel <= negative_pixel;
            when "010" => video_pixel <= sad_pixel;
            when "011" => video_pixel <= sobel_pixel;
            when "100" => video_pixel <= gray_pixel;
            when "101" => video_pixel <= xor_pixel;
            when "110" => video_pixel <= gray_negative_pixel;
            when "111" => video_pixel <= stream1_pixel;
        end case;
    end if;
end process;


end Behavioral;
