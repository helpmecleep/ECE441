----------------------------------------------------------------------------------
--
-- ECE 244 Lab #3 2022
--
-- Video camera buffering system
--
-- (c)2022 B. Sirna         Dept. of ECE
--                          University of Victoria
--
----------------------------------------------------------------------------------


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
USE ieee.numeric_std.ALL; 

library unisim;
use unisim.vcomponents.all;

entity video is
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

    write_enable : in STD_LOGIC;
    configure_camera : in STD_LOGIC;
    camera_configured : out STD_LOGIC;
        
--
-- State machine status
--
    status_leds : out STD_LOGIC_VECTOR( 12 downto 0 );
    
    
      -- DDR2 interface
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
    --reset : in STD_LOGIC;

    clock_200Mhz         : out STD_LOGIC;
    reset_state_machine : in STD_LOGIC;
    
    QSPI_SDI : out STD_LOGIC;
    QSPI_SDO : in STD_LOGIC;
    QSPI_WP : out STD_LOGIC;
    QSPI_HLD : in STD_LOGIC;
    QSPI_CS : out STD_LOGIC
);
end video;

architecture Behavioral of video is

constant BASYS_3_CLOCK_DIVIDER : INTEGER range 1 to 4 := 2;
constant CYCLONE_II_CLOCK_DIVIDER : INTEGER range 1 to 4 := 1;
constant BOARD_DIVIDER : INTEGER range 1 to 4 := BASYS_3_CLOCK_DIVIDER;

constant SCREEN_X_SIZE : UNSIGNED( 10 downto 0 ) := to_unsigned( 640, 11 );
constant SCREEN_Y_SIZE : UNSIGNED( 9 downto 0 ) := to_unsigned( 480, 10 );

--
-- 640 x 480 @ 25.000Mhz
--

constant VSYNC_25_000MHZ_640_480_60 : INTEGER := 60;
constant HSYNC_FRONT_PORCH_25_000MHZ_640_480_60 : INTEGER := 16;
constant HSYNC_SYNC_PULSE_25_000MHZ_640_480_60 : INTEGER := 96;
constant HSYNC_LINE_WIDTH_25_000MHZ_640_480_60 : INTEGER := 800;
constant HSYNC_POLARITY_25_000MHZ_640_480_60 : STD_LOGIC := '0';

constant VSYNC_FRONT_PORCH_25_000MHZ_640_480_60 : INTEGER := 10;
constant VSYNC_SYNC_PULSE_25_000MHZ_640_480_60 : INTEGER := 2;
constant VSYNC_FRAME_WIDTH_25_000MHZ_640_480_60 : INTEGER := 521;
constant VSYNC_POLARITY_25_000MHZ_640_480_60 : STD_LOGIC := '0';


--
-- Current Settings
--

constant VSYNC : INTEGER := VSYNC_25_000MHZ_640_480_60;
constant HSYNC_FRONT_PORCH : INTEGER := HSYNC_FRONT_PORCH_25_000MHZ_640_480_60;
constant HSYNC_SYNC_PULSE : INTEGER := HSYNC_SYNC_PULSE_25_000MHZ_640_480_60;
constant HSYNC_LINE_WIDTH : INTEGER := HSYNC_LINE_WIDTH_25_000MHZ_640_480_60;
constant HSYNC_POLARITY : STD_LOGIC := HSYNC_POLARITY_25_000MHZ_640_480_60;

constant VSYNC_FRONT_PORCH : INTEGER := VSYNC_FRONT_PORCH_25_000MHZ_640_480_60;
constant VSYNC_SYNC_PULSE : INTEGER := VSYNC_SYNC_PULSE_25_000MHZ_640_480_60;
constant VSYNC_FRAME_WIDTH : INTEGER := VSYNC_FRAME_WIDTH_25_000MHZ_640_480_60;
constant VSYNC_POLARITY : STD_LOGIC := VSYNC_POLARITY_25_000MHZ_640_480_60;



  COMPONENT ov7670_controller
  PORT(
      clk : IN std_logic;
      resend : IN std_logic;
      siod : INOUT std_logic;
      config_finished : OUT std_logic;
      sioc : OUT std_logic;
      reset : OUT std_logic;
      pwdn : OUT std_logic;
      xclk : OUT std_logic;
      drive: in std_logic_vector( 1 downto 0 );
      refresh_rate : in STD_LOGIC
  );
  END COMPONENT;




  COMPONENT ov7670_capture
  PORT(
    pclk : IN std_logic;
    vsync : IN std_logic;
    href : IN std_logic;
    d : IN std_logic_vector(7 downto 0);          
    addr : OUT std_logic_vector(6 downto 0);
    dout : out std_logic_vector(95 downto 0);
    we : OUT std_logic;
    href_out : out STD_LOGIC;
    vsync_out : out STD_LOGIC;
    StoreEvenLine : out std_logic
    );
  END COMPONENT;


component line_buffer IS
  PORT (
    ena : in STD_LOGIC;
    clka : IN STD_LOGIC;
    wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
    addra : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    dina : IN STD_LOGIC_VECTOR(95 DOWNTO 0);
    clkb : IN STD_LOGIC;
    addrb : IN STD_LOGIC_VECTOR(6 DOWNTO 0);
    doutb : OUT STD_LOGIC_VECTOR(95 DOWNTO 0)
  );
END component;


component ddr is
generic (
          SKIP_CALIB : string := "TRUE"
          );
port (
    ddr2_dq       : inout std_logic_vector(15 downto 0);
    ddr2_dqs_p    : inout std_logic_vector(1 downto 0);
    ddr2_dqs_n    : inout std_logic_vector(1 downto 0);
    ddr2_addr     : out   std_logic_vector(12 downto 0);
    ddr2_ba       : out   std_logic_vector(2 downto 0);
    ddr2_ras_n    : out   std_logic;
    ddr2_cas_n    : out   std_logic;
    ddr2_we_n     : out   std_logic;
    ddr2_ck_p     : out   std_logic_vector(0 downto 0);
    ddr2_ck_n     : out   std_logic_vector(0 downto 0);
    ddr2_cke      : out   std_logic_vector(0 downto 0);
    ddr2_cs_n     : out   std_logic_vector(0 downto 0);
    ddr2_dm       : out   std_logic_vector(1 downto 0);
    ddr2_odt      : out   std_logic_vector(0 downto 0);
    app_addr                  : in    std_logic_vector(26 downto 0);
    app_cmd                   : in    std_logic_vector(2 downto 0);
    app_en                    : in    std_logic;
    app_wdf_data              : in    std_logic_vector(127 downto 0);
    app_wdf_end               : in    std_logic;
    app_wdf_mask         : in    std_logic_vector(15 downto 0);
    --app_wdf_mask         : in    std_logic_vector(7 downto 0);
    app_wdf_wren              : in    std_logic;
    app_rd_data               : out   std_logic_vector(127 downto 0);
    app_rd_data_end           : out   std_logic;
    app_rd_data_valid         : out   std_logic;
    app_rdy                   : out   std_logic;
    app_wdf_rdy               : out   std_logic;
    app_sr_req                : in    std_logic;
    app_ref_req               : in    std_logic;
    app_zq_req                : in    std_logic;
    app_sr_active             : out   std_logic;
    app_ref_ack               : out   std_logic;
    app_zq_ack                : out   std_logic;
    ui_clk                    : out   std_logic;
    ui_clk_sync_rst           : out   std_logic;
    init_calib_complete       : out   std_logic;
    -- System Clock Ports
    sys_clk_i                      : in    std_logic;
    -- Reference Clock Ports
    --clk_ref_i                                : in    std_logic;
    device_temp_i                            : in    std_logic_vector(11 downto 0);
    sys_rst                     : in    std_logic);
end component;

component clk_wiz_0 is
    port (
        clk_in1 : in STD_LOGIC;
        clk_200Mhz : out STD_LOGIC;
        clk_camera : out STD_LOGIC;
        clk_5Mhz : out STD_LOGIC
    );
end component;


component video_timing is
    generic (
        HSYNC_POLARITY : STD_LOGIC;
        VSYNC_POLARITY : STD_LOGIC;
        HSYNC_FRONT_PORCH : integer;
        HSYNC_SYNC_PULSE : integer;
        HSYNC_LINE_WIDTH : integer;

        VSYNC_FRONT_PORCH : integer;
        VSYNC_SYNC_PULSE : integer;
        VSYNC_FRAME_WIDTH : integer;

        BOARD_DIVIDER : INTEGER range 1 to 4;
        SCREEN_X_SIZE : UNSIGNED( 10 downto 0 );
        SCREEN_Y_SIZE : UNSIGNED( 9 downto 0 )
    );
    Port (
        clock : in STD_LOGIC;
        h_sync : out STD_LOGIC;
        v_sync : out STD_LOGIC;
        h_dot : out UNSIGNED( 10 downto 0 );
        v_line : out UNSIGNED( 9 downto 0 );
        VideoClock : out std_logic;
        visible_frame : out STD_LOGIC
    );
end component;



component debounce_clock is
  Port ( 
    	clock_in: in   STD_LOGIC;
    	clock_out : out STD_LOGIC
    );
end component;

component debounce_switch is
Port (
    reset : in STD_LOGIC;
    clock : in STD_LOGIC;
    button_in : in STD_LOGIC;
    button_out : out STD_LOGIC
);
end component;



type state_type is (
    Idle_t,
    Stream1Read_t,
    Stream1ReadWait_t,
    CamWriteStart_t,
    CamWriteData_t,
    CamWriteCmd_t,
    
    Stream2Init_t,
    Stream2Read_t,
    Stream2ReadWait_t,

    Stream3Init_t,
    Stream3Read_t,
    Stream3ReadWait_t,

    Finished_t
    );


------------------------------------------------------------------------
-- Constant Declarations
------------------------------------------------------------------------
-- ddr commands
constant CMD_WRITE         : std_logic_vector(2 downto 0) := "000";
constant CMD_READ          : std_logic_vector(2 downto 0) := "001";



signal clk_200Mhz_i : STD_LOGIC := '0';
signal clk_camera : STD_LOGIC := '0';
signal clk_5Mhz_i : STD_LOGIC := '0';

signal CamWren : std_logic;
signal CamAddressWrite : std_logic_vector( 6 downto 0 );
signal CamWrdata : std_logic_vector( 95 downto 0 );
signal CamHdotAddress : unsigned( 6 downto 0 );
signal CamDataEven : std_logic_vector( 95 downto 0 );
signal CamDataOdd : std_logic_vector( 95 downto 0 );
signal CamData : std_logic_vector( 95 downto 0 );
signal CamWriteEnable : std_logic := '0';
signal configure_camera_db : STD_LOGIC;
--
-- external memory related signals
--
signal mem_ui_clk          : std_logic;
signal mem_ui_rst          : std_logic;
signal rst                 : std_logic;
signal rstn                : std_logic;
signal sreg                : std_logic_vector(1 downto 0);

-- ram internal signals
signal ram_dq_i_int        : std_logic_vector(95 downto 0);
signal ram_cen_int         : std_logic;
signal ram_oen_int         : std_logic;
signal ram_wen_int         : std_logic;

-- ddr user interface signals

signal mem_cmd             : std_logic_vector(2 downto 0); -- command for current request
signal mem_en              : std_logic; -- active-high strobe for 'cmd' and 'addr'
signal mem_rdy             : std_logic;
signal mem_wdf_rdy         : std_logic; -- write data FIFO is ready to receive data (wdf_rdy = 1 & wdf_wren = 1)
signal mem_wdf_data        : std_logic_vector( 95 downto 0);
signal mem_wdf_end         : std_logic; -- active-high last 'wdf_data'
signal mem_wdf_mask        : std_logic_vector(15 downto 0) := "0000000000000000";
signal mem_wdf_wren        : std_logic;
signal mem_rd_data         : std_logic_vector( 95 downto 0);
signal mem_rd_data_end     : std_logic; -- active-high last 'rd_data'
signal mem_rd_data_valid   : std_logic; -- active-high 'rd_data' valid
signal calib_complete      : std_logic; -- active-high calibration complete

signal MemoryWriteAddress : STD_LOGIC_VECTOR( 6 downto 0 );

--
-- Streams
--

signal stream_store_even_line : std_logic := '0';

--
-- Stream 1 
--

signal stream1_data_even_out : std_logic_vector( 95 downto 0 );
signal stream1_data_odd_out : std_logic_vector( 95 downto 0 );
signal stream1_data_out : std_logic_vector( 95 downto 0 );
signal stream1_store_odd_line : std_logic := '0';
signal stream1_store_even_line : std_logic := '0';
signal stream1_store : std_logic := '0';
signal stream1_page : unsigned( 7 downto 0 ) := to_unsigned( 6, 8 );

--
-- Stream 2 
--

signal stream2_data_even_out : std_logic_vector( 95 downto 0 );
signal stream2_data_odd_out : std_logic_vector( 95 downto 0 );
signal stream2_data_out : std_logic_vector( 95 downto 0 );
signal stream2_store_odd_line : std_logic := '0';
signal stream2_store_even_line : std_logic := '0';
signal stream2_store : std_logic := '0';
signal Stream2_page : unsigned( 7 downto 0 ) := to_unsigned( 5, 8 );


--
-- Stream 3 
--

signal stream3_data_even_out : std_logic_vector( 95 downto 0 );
signal stream3_data_odd_out : std_logic_vector( 95 downto 0 );
signal stream3_data_out : std_logic_vector( 95 downto 0 );
signal stream3_store_odd_line : std_logic := '0';
signal stream3_store_even_line : std_logic := '0';
signal stream3_store : std_logic := '0';
signal Stream3_page : unsigned( 7 downto 0 ) := to_unsigned( 4, 8 );

signal cam_vsync : STD_LOGIC;
signal cam_href_out  : STD_LOGIC;
--signal cam_datain  : STD_LOGIC_vector(7 downto 0);
signal CamStoreEvenLine : std_logic;
signal CamStoreOddLine : std_logic;

signal href_out : std_logic;
signal vsync_out : std_logic;
signal cam_vsync_debounce : std_logic;
signal h_sync : STD_LOGIC;
signal v_sync : STD_LOGIC;
signal cState, nState      : state_type;
signal Hdot : UNSIGNED ( 10 downto 0 ) := "00000000000";
signal stream_read_address : UNSIGNED( 10 downto 0 ) := "00000000000";

signal Vline : UNSIGNED ( 9 downto 0 ) := "0000000000";
signal HDotLatched : UNSIGNED( 2 downto 0 );
signal visible_frame : std_logic;
signal VideoClock : std_logic;
signal ReadStartAddress : unsigned( 18 downto 0 ) := to_unsigned( 0, 19 );
signal DoRead : std_logic := '0';
signal DoDummyRead : std_logic := '0';

signal NextAddress : unsigned( 26 downto 0 ) := to_unsigned( 0, 27);
signal DeviceTemp : std_logic_vector( 11 downto 0 ) := "000000000000";
signal DoRefresh : std_logic := '0';
signal RefreshAck : std_logic := '0';
signal CamPage : unsigned( 7 downto 0 ) := to_unsigned( 7, 8 );
signal TriggerWrite : std_logic := '0';
signal ReadDone : std_logic := '0';
signal tmp_var : std_logic_vector( 31 downto 0 );
signal previous_picture : STD_LOGIC := '0';
signal next_picture : STD_LOGIC := '0';

signal reset : std_logic := '1';
signal reset_not : std_logic;
signal video_source : STD_LOGIC; 

attribute FSM_ENCODING              : string;
attribute FSM_ENCODING of cState    : signal is "GRAY";


--
-- Video input signals
--

signal video_source_store_even_line : STD_LOGIC;
signal video_source_store_odd_line : STD_LOGIC;
signal video_source_clock : STD_LOGIC;
signal video_source_write_enable : STD_LOGIC;
signal video_source_address_write : STD_LOGIC_VECTOR( 6 downto 0 );
signal video_source_write_data : STD_LOGIC_VECTOR( 95 downto 0 );

signal picture_store_even_line : STD_LOGIC;
signal picture_store_odd_line : STD_LOGIC;
signal picture_clock : STD_LOGIC;
signal picture_write_enable : STD_LOGIC;
signal picture_address_write : UNSIGNED( 6 downto 0 );
signal picture_write_data : STD_LOGIC_VECTOR( 95 downto 0 );

signal picture_href : STD_LOGIC := '0';
signal picture_vsync : STD_LOGIC := '0';

signal QSPI_CCLK : STD_LOGIC := '0';
signal debouncer_clock : STD_LOGIC := '0';

signal state : integer range 0 to 100 := 0;
attribute FSM_ENCODING of state    : signal is "GRAY";


begin

  xtime : clk_wiz_0
   port map (
       clk_in1 => board_clock,
       clk_200Mhz => clk_200Mhz_i,
       clk_camera => clk_camera,
       clk_5Mhz => clk_5Mhz_i
   );


QSPI_WP <= '1';

picture_store_odd_line <= not picture_store_even_line;

picture_process : process (
    previous_picture,
    next_picture,
    video_source_clock,
    QSPI_SDO,
    picture_store_even_line,
    picture_write_data,
    state
)
    

variable spi_cmd : STD_LOGIC_VECTOR( 31 downto 0 );
variable count : integer range 0 to (128+4096)  := 0; -- 96 := 0;
variable spi_address : UNSIGNED( 23 downto 0 ) := ( others => '0' );
variable line_count : integer range 0 to 480 := 0;
variable data_in : STD_LOGIC_VECTOR( 95 downto 0 );
variable crc16 : UNSIGNED ( 15 downto 0 ) := to_unsigned( 0, 16 );
variable xor_flag : STD_LOGIC := '0';
variable load_header : STD_LOGIC := '0';
variable next_picture_address : STD_LOGIC_VECTOR( 23 downto 0 ) := x"000000";
variable prev_picture_address : STD_LOGIC_VECTOR( 23 downto 0 ) := x"000000";
variable cur_picture_address  : STD_LOGIC_VECTOR( 23 downto 0 ) := x"000000";
variable pic_count  : UNSIGNED( 5 downto 0 ) := "000000";

variable do_next_picture : STD_LOGIC := '0';
variable do_previous_picture : STD_LOGIC := '0';
variable previous_state : STD_LOGIC := '0';
variable next_state : STD_LOGIC := '0';

begin   
    if ( rising_edge( video_source_clock )) then

        if ( previous_state /= previous_picture ) then
            previous_state := previous_picture;
            if ( previous_picture = '1' ) then
                do_previous_picture := '1';
            end if;
        end if;

        if ( next_state /= next_picture ) then
            next_state := next_picture;
            if ( next_picture = '1' ) then
                do_next_picture := '1';
            end if;
        end if;

        


        case( state ) is
        
            when 0 =>
                picture_href <= '1';     
                QSPI_CS <= '0';
                spi_cmd := "00000011" & cur_picture_address;    
                QSPI_CCLK <= '0';
                count := 0;
                line_count := 0;
                state <= 1;
                picture_address_write <= ( others => '0' );
                picture_store_even_line <= '1';
                picture_write_enable <= '0';
                spi_address := to_unsigned( 0, spi_address'length );
                load_header := '1';

            when 1 =>
                QSPI_CCLK <= '0';
                QSPI_CS <= '0';
                QSPI_SDI <= spi_cmd(31);
                spi_cmd := spi_cmd( 30 downto 0 ) & "0";
                state <= 2;

            when 2 =>
                QSPI_CCLK <= '1';
                count := count + 1;
                if ( count = 32 ) then
                    count := 0;
                    state <= 4;
                else

                    state <= 1;
                end if;

            when 3 =>
                QSPI_CCLK <= '1';
                state <= 4;
                
            when 4 => 
                QSPI_CCLK <= '0';
                state <= 5;
                
            when 5 =>
                xor_flag := crc16(15);
                
                crc16 := crc16( 14 downto 0 ) & "0";
                if ( QSPI_SDO = '1' ) then
                    xor_flag := xor_flag xor '1';
                end if;
                    
                if ( xor_flag = '1' ) then
                    crc16 := crc16 xor x"1021";
                end if;
            
                count := count + 1;
                if ( count = 96 ) then
                    if ( load_header = '1' ) then
                        load_header := '0';
                        if ( crc16 = x"0000" ) then
                            next_picture_address := data_in( 95-1 downto 72-1 );
                            prev_picture_address := data_in( 71-1 downto 48-1 );
                            count := 0;
                            state <= 4;
                        else
                            state <= 11; --0;
                            QSPI_CS <= '1';
                            crc16 := to_unsigned( 0, 16 );
                         end if;
                    else

                        picture_write_data( 95 downto 84 ) <= data_in( 11-1 downto  0 ) & QSPI_SDO;
                        picture_write_data( 83 downto 72 ) <= data_in( 23-1 downto 12-1 );
                        picture_write_data( 71 downto 60 ) <= data_in( 35-1 downto 24-1 );
                        picture_write_data( 59 downto 48 ) <= data_in( 47-1 downto 36-1 );
                        picture_write_data( 47 downto 36 ) <= data_in( 59-1 downto 48-1 );
                        picture_write_data( 35 downto 24 ) <= data_in( 71-1 downto 60-1 );
                        picture_write_data( 23 downto 12 ) <= data_in( 83-1 downto 72-1 );
                        picture_write_data( 11 downto  0 ) <= data_in( 95-1 downto 84-1 );
                      
                        state <= 6;
                        count := 0;
                    end if;
                else
                     data_in := data_in( 94 downto 0 ) & QSPI_SDO;                
                    state <= 4;
                end if;
                QSPI_CCLK <= '1';

--
-- Enable write signal for camera line buffer
--                
            when 6 =>
                picture_write_enable <= '1';
                state <= 7;

--
-- Disable write
--            
            when 7 =>
                picture_write_enable <= '0';
                state <= 8;


            when 8 =>
--
-- Advance to next 8 pixels
--            
                picture_address_write <= picture_address_write + to_unsigned ( 1, 7 );

--
-- Test for end of line
--
                if ( picture_address_write = (80-1) ) then

--
-- Switch camera line buffer and signal a horizontal retrace
--                    
                    picture_store_even_line <= not picture_store_even_line;
                    picture_href <= '0';
                    count := 0;
                    state <= 80;
                else

--
-- Do the next 8 pixels in the current line
-- 
                    state <= 3;
                    count := 0;  
                end if;

--
-- Delay for horizontal retrace signal
--
            when 80 =>
                count := count + 1;
                if ( count = ((64+512)*6) ) then
                    count := 0;
                    state <= 81;
                end if;

--
-- End the horizontal retrace signal delay
--
            when 81 =>
                picture_href <= '1';
                count := count + 1;
                if ( count = (32*6) ) then
                    state <= 9;
                end if;

            when 9 =>
--
-- Update the line count and check for end of screen
--
                line_count := line_count + 1;
                if ( line_count = 480 ) then
                    picture_vsync <= '1';
                    QSPI_CS <= '1';
                    count := 0;
                    state <= 10;

                    picture_store_even_line <= '1';
                else
                    picture_address_write <= to_unsigned( 0, picture_address_write'length );
                    count := 0;
                    state <= 3;
                end if;
    
            when 10 =>
                crc16 := to_unsigned( 0, 16 );

                count := count + 1;
                if ( count = (128*6) ) then
                    picture_vsync <= '0';
                    state <= 11;
                    count := 0;
                end if;
    
            when 11 =>
                if ( do_previous_picture = '1' ) then
                    do_previous_picture := '0';
                    cur_picture_address := prev_picture_address;
                end if;
                
                if ( do_next_picture = '1' ) then
                    do_next_picture := '0';
                    cur_picture_address := next_picture_address;
                end if;               
                
                state <= 0;
            

--
-- Should never get here
-- 
            when others =>
                state <= 0;
    
        end case;
        
    end if;
end process;


STARTUPE2_inst : STARTUPE2
   generic map (
      PROG_USR => "FALSE",  -- Activate program event security feature. Requires encrypted bitstreams.
      SIM_CCLK_FREQ => 0.0  -- Set the Configuration Clock Frequency(ns) for simulation.
   )
   port map (

      CLK => '0', -- CLK,             -- 1-bit input: User start-up clock input
      GSR => '0', -- GSR,             -- 1-bit input: Global Set/Reset input (GSR cannot be used for the port name)
      GTS => '0', -- GTS,             -- 1-bit input: Global 3-state input (GTS cannot be used for the port name)
      KEYCLEARB => '0', -- KEYCLEARB, -- 1-bit input: Clear AES Decrypter Key input from Battery-Backed RAM (BBRAM)
      PACK => '0', -- PACK,           -- 1-bit input: PROGRAM acknowledge input
      USRCCLKO => QSPI_CCLK, -- USRCCLKO,   -- 1-bit input: User CCLK input
                              -- For Zynq-7000 devices, this input must be tied to GND
      USRCCLKTS => '0', -- USRCCLKTS, -- 1-bit input: User CCLK 3-state enable input
                              -- For Zynq-7000 devices, this input must be tied to VCC
      USRDONEO => '0', -- USRDONEO,   -- 1-bit input: User DONE pin output control
      USRDONETS => '0' -- USRDONETS  -- 1-bit input: User DONE 3-state enable output
   );


select_video_source : process(
    video_source,
    
    CamStoreEvenLine,
    CamStoreOddLine,
    ov7670_pclk,
    CamWren,
    CamAddressWrite,
    CamWrdata,
    
    VideoClock,
    picture_store_even_line,
    picture_store_odd_line,
    picture_write_enable,
    picture_address_write,
    picture_write_data,
    ov7670_vsync,
    href_out,
    picture_href,
    picture_vsync    
)
    
begin
    if ( video_source = '0' ) then
        video_source_store_even_line <= picture_store_even_line;
        video_source_store_odd_line <= picture_store_odd_line;
        video_source_clock <= VideoClock;
        video_source_write_enable <= picture_write_enable;
        video_source_address_write <= STD_LOGIC_VECTOR( picture_address_write ); -- xor "0000001";
        video_source_write_data <= picture_write_data;
        
        cam_href_out <= picture_href;
        cam_vsync <= picture_vsync;         

    else
        video_source_store_even_line <= CamStoreEvenLine;
        video_source_store_odd_line <= CamStoreOddLine;
        video_source_clock <= ov7670_pclk;
        video_source_write_enable <= CamWren;
        video_source_address_write <= CamAddressWrite;
        video_source_write_data <= CamWrdata;
        cam_vsync <= ov7670_vsync;
        cam_href_out <= href_out;       
    end if;
end process;


camera_data_even_line : line_buffer
  port map (
    ena => video_source_store_even_line,
    clka => video_source_clock, 
    wea(0) => video_source_write_enable,
    addra  => video_source_address_write,
    dina => video_source_write_data,
    
    clkb => mem_ui_clk,
    addrb => std_logic_vector(CamHdotAddress),
    doutb => CamDataEven
  );

camera_data_odd_line : line_buffer
  port map (
    ena => video_source_store_odd_line,
    clka => video_source_clock,
    wea(0) => video_source_write_enable,
    addra  => video_source_address_write, 
    dina => video_source_write_data,
    
    clkb => mem_ui_clk, 
    addrb => std_logic_vector(CamHdotAddress),
    doutb => CamDataOdd
  );


stream_read_address <= ( Hdot + to_unsigned( 8, Hdot'length )) when ( Hdot < 640 ) else "00000000000";

--
-- Video Stream 1
--

stream1_even_line_out : line_buffer
  port map (
    ena => stream1_store_odd_line,
    clka => mem_ui_clk,
    wea(0) => mem_rd_data_valid,
    addra  => MemoryWriteAddress, 
    dina => mem_rd_data,
    
    clkb =>  VideoClock,
    addrb => STD_LOGIC_VECTOR( stream_read_address( 9 downto 3 )), -- (std_logic_vector(Hdot( 9 downto 3 )),
    doutb => stream1_data_even_out
  );

stream1_odd_line_out : line_buffer
  port map (
    ena => stream1_store_even_line,
    clka =>  mem_ui_clk,
    wea(0) => mem_rd_data_valid,
    addra  => MemoryWriteAddress, 
    dina => mem_rd_data,
    
    clkb =>  VideoClock,
    addrb => STD_LOGIC_VECTOR( stream_read_address( 9 downto 3 )), -- (std_logic_vector(Hdot( 9 downto 3 )),
    doutb => stream1_data_odd_out
  );

stream1_store_even_line <= stream1_store and stream_store_even_line and mem_rd_data_valid;
stream1_store_odd_line <= stream1_store and ( not stream_store_even_line ) and mem_rd_data_valid;



--
-- Video Stream 2
--


stream2_out_odd : line_buffer
  port map (
    ena => stream2_store_odd_line,
    clka => mem_ui_clk,
    wea(0) => mem_rd_data_valid,
    addra  => MemoryWriteAddress, 
    dina => mem_rd_data,
    
    clkb =>  VideoClock,
    addrb => STD_LOGIC_VECTOR( stream_read_address( 9 downto 3 )),
    doutb => stream2_data_even_out
  );

stream2_out_even : line_buffer
  port map (
    ena => stream2_store_even_line,
    clka =>  mem_ui_clk,
    wea(0) => mem_rd_data_valid,
    addra  => MemoryWriteAddress, 
    dina => mem_rd_data,
    
    clkb =>  VideoClock,
    addrb => STD_LOGIC_VECTOR( stream_read_address( 9 downto 3 )),
    doutb => stream2_data_odd_out
  );

stream2_store_even_line <= stream2_store and stream_store_even_line and mem_rd_data_valid;
stream2_store_odd_line <= stream2_store and ( not stream_store_even_line ) and mem_rd_data_valid;


stream3_out_odd : line_buffer
  port map (
    ena => stream3_store_odd_line,
    clka => mem_ui_clk,
    wea(0) => mem_rd_data_valid,
    addra  => MemoryWriteAddress, 
    dina => mem_rd_data,
    
    clkb =>  VideoClock,
    addrb => STD_LOGIC_VECTOR( stream_read_address( 9 downto 3 )),
    doutb => stream3_data_even_out
  );

stream3_out_even : line_buffer
  port map (
    ena => stream3_store_even_line,
    clka =>  mem_ui_clk,
    wea(0) => mem_rd_data_valid,
    addra  => MemoryWriteAddress, 
    dina => mem_rd_data,
    
    clkb =>  VideoClock,
    addrb => STD_LOGIC_VECTOR( stream_read_address( 9 downto 3 )),
    doutb => stream3_data_odd_out
  );

stream3_store_even_line <= stream3_store and stream_store_even_line and mem_rd_data_valid;
stream3_store_odd_line <= stream3_store and ( not stream_store_even_line ) and mem_rd_data_valid;


  Inst_ov7670_capture: ov7670_capture PORT MAP(
    pclk  => ov7670_pclk,
    vsync => cam_vsync_debounce,
    href  => ov7670_href,
    d     => ov7670_data,
    addr  => CamAddressWrite,
    dout  => CamWrdata,
    we    => CamWren,
    href_out => href_out,
    vsync_out => vsync_out,
    StoreEvenLine => CamStoreEvenLine
  );

  Inst_ov7670_controller: ov7670_controller PORT MAP(
      clk             => clk_camera,
      resend          => configure_camera_db,
      config_finished => camera_configured,
      sioc            => ov7670_sioc,
      siod            => ov7670_siod,
      reset           => ov7670_reset,
      pwdn            => ov7670_pwdn,
      xclk            => ov7670_xclk,
      drive             => ov7670_drive,
      refresh_rate      => ov7670_refresh_rate
  );
 
CamStoreOddLine <= not CamStoreEvenLine;

   timing : video_timing
   generic map
   (

       HSYNC_FRONT_PORCH => HSYNC_FRONT_PORCH,
       HSYNC_SYNC_PULSE => HSYNC_SYNC_PULSE,
       HSYNC_LINE_WIDTH => HSYNC_LINE_WIDTH,
       HSYNC_POLARITY => HSYNC_POLARITY,

       VSYNC_FRONT_PORCH => VSYNC_FRONT_PORCH,
       VSYNC_SYNC_PULSE => VSYNC_SYNC_PULSE,
       VSYNC_FRAME_WIDTH => VSYNC_FRAME_WIDTH,
       VSYNC_POLARITY => VSYNC_POLARITY,

       BOARD_DIVIDER => BOARD_DIVIDER,
       SCREEN_X_SIZE => SCREEN_X_SIZE,
       SCREEN_Y_SIZE => SCREEN_Y_SIZE
   )
   port map
   (
       clock => board_clock, -- clk_200Mhz_i,
       h_sync => h_sync,
       v_sync => v_sync,
       h_dot => Hdot,
       v_line => Vline,
       visible_frame => visible_frame,
       VideoClock => VideoClock
   );



ReadScreen: process( v_sync, h_sync, Vline, stream_store_even_line )
 
begin
    if ( falling_edge( h_sync )) then

        if ( Vline < 480 ) then
            ReadStartAddress <= ReadStartAddress + to_unsigned( 1024, 19 );
            stream_store_even_line <= not stream_store_even_line;

--
-- Setup for read ahead of the next frame's first line of the video image
--
        elsif ( Vline = 492 ) then
            stream_store_even_line <= '0';
            ReadStartAddress <= to_unsigned( 0, 19 );

--
-- Update the buffer selection and the read address for the second line
--
        elsif( Vline = 493 ) then
            stream_store_even_line <= '1';
            ReadStartAddress <= to_unsigned( 1024, 19 );
        end if;
    end if;
    
end process;

process( VideoClock, Vline, Hdot )
begin
    if ( rising_edge( VideoClock )) then
        if ( Hdot = 0 ) then
            if (( Vline = 493 ) or ( Vline < 480 )) then
        	    DoRead <= '1';
                DoDummyRead <= '0';
    	    else
        	    DoRead <= '0';
                DoDummyRead <= '1';
            end if;
        else
            DoRead <= '0';
            DoDummyRead <= '0';
    	end if;
    end if;
end process;

select_line: process( VideoClock, stream_store_even_line, stream1_data_even_out, stream1_data_odd_out, Hdot )

variable stream1_data_out_tmp : STD_LOGIC_VECTOR( 95 downto 0 );

begin
    if ( rising_edge(  VideoClock )) then
        HDotLatched <= HDot( 2 downto 0 );
    
        if ( Hdot( 2 downto 0 ) = "111" ) then    
            if ( stream_store_even_line = '1' ) then
                stream1_data_out_tmp := stream1_data_even_out;
            else
                stream1_data_out_tmp := stream1_data_odd_out;
            end if;
        end if;

        if ( Hdot( 2 downto 0 ) = "000" ) then
            stream1_data_out <= stream1_data_out_tmp;
        end if;

    end if;
end process;

stream2_select_line : process( VideoClock, stream_store_even_line, stream2_data_even_out, stream2_data_odd_out, Hdot )

variable stream2_data_out_tmp : STD_LOGIC_VECTOR( 95 downto 0 );

begin
    if ( rising_edge(  VideoClock )) then
        if ( Hdot( 2 downto 0 ) = "111" ) then    
            if ( stream_store_even_line = '1' ) then
                stream2_data_out_tmp := stream2_data_even_out;
            else
                stream2_data_out_tmp := stream2_data_odd_out;
            end if;
        end if;

        if ( Hdot( 2 downto 0 ) = "000" ) then
            stream2_data_out <= stream2_data_out_tmp;
        end if;

    end if;
end process;

stream3_select_line : process( VideoClock, stream_store_even_line, stream3_data_even_out, stream3_data_odd_out, HDot )

variable stream3_data_out_tmp : STD_LOGIC_VECTOR( 95 downto 0 );

begin
    if ( rising_edge(  VideoClock )) then
        if ( Hdot( 2 downto 0 ) = "111" ) then    
            if ( stream_store_even_line = '1' ) then
                stream3_data_out_tmp := stream3_data_even_out;
            else
                stream3_data_out_tmp := stream3_data_odd_out;
            end if;
        end if;

        if ( Hdot( 2 downto 0 ) = "000" ) then
            stream3_data_out <= stream3_data_out_tmp;
        end if;

    end if;
end process;

cam_data : process( CamDataOdd, CamDataEven, video_source_store_even_line )
begin
    if ( video_source_store_even_line = '1' ) then
        CamData <= CamDataOdd;
    else
        CamData <= CamDataEven;
      end if;
 end process;

process( cam_vsync, write_enable )
begin
    if ( rising_edge( cam_vsync )) then
        CamWriteEnable <= write_enable;
    end if;
end process;

------------------------------------------------------------------------
-- DDR controller instance
------------------------------------------------------------------------
   Inst_DDR: ddr
    port map (
      ddr2_dq              => ddr2_dq,
      ddr2_dqs_p           => ddr2_dqs_p,
      ddr2_dqs_n           => ddr2_dqs_n,
      ddr2_addr            => ddr2_addr,
      ddr2_ba              => ddr2_ba,
      ddr2_ras_n           => ddr2_ras_n,
      ddr2_cas_n           => ddr2_cas_n,
      ddr2_we_n            => ddr2_we_n,
      ddr2_ck_p            => ddr2_ck_p,
      ddr2_ck_n            => ddr2_ck_n,
      ddr2_cke             => ddr2_cke,
      ddr2_dm              => ddr2_dm,
      ddr2_odt             => ddr2_odt,
      ddr2_cs_n            => ddr2_cs_n, -- cs_out,
      
      --ddr2_reset_n         => ddr3_reset_n,
      -- Inputs
      sys_clk_i            => clk_200Mhz_i,
      --clk_ref_i            => clk_200Mhz_i,
      sys_rst              => reset_not,
      -- user interface signals
      app_addr             => std_logic_vector(NextAddress), -- mem_addr,
      app_cmd              => mem_cmd,
      app_en               => mem_en,
      app_wdf_data( 127 downto 96 ) => (others=>'0'),
      app_wdf_data( 95 downto 0 ) => CamData( 95 downto 0 ), -- mem_wdf_data( 127 downto 0 ),
      app_wdf_end          => mem_wdf_end,
      app_wdf_mask         => mem_wdf_mask,
      app_wdf_wren         => mem_wdf_wren,
      
      app_rd_data( 127 downto 96 ) => tmp_var,
      app_rd_data( 95 downto 0 ) => mem_rd_data( 95 downto 0),
      app_rd_data_end      => mem_rd_data_end,
      app_rd_data_valid    => mem_rd_data_valid,
      app_rdy              => mem_rdy,
      app_wdf_rdy          => mem_wdf_rdy,
      app_sr_req           => '0',
      app_sr_active        => open,
      app_ref_req          => DoRefresh,
      app_ref_ack          => RefreshAck,
      app_zq_req           => '0',
      app_zq_ack           => open,
      ui_clk               => mem_ui_clk,
      ui_clk_sync_rst      => mem_ui_rst,
      init_calib_complete  => calib_complete,
      device_temp_i        => DeviceTemp
      
      );


do_debouncer_clock : debounce_clock
    port map (
        clock_in => clk_5Mhz_i,
        clock_out => debouncer_clock
    );
    
debounce_configure_camera : debounce_switch
    port map (
        reset => reset,
        clock => debouncer_clock,
        button_in => configure_camera,
        button_out => configure_camera_db
    );

debounce_previous_picture : debounce_switch
    port map (
        reset => reset,
        clock => debouncer_clock,
        button_in => previous_picture_button,
        button_out => previous_picture
    );

debounce_next_picture : debounce_switch
    port map (
        reset => reset,
        clock => debouncer_clock,
        button_in => next_picture_button,
        button_out => next_picture
    );    
    
    
debounce_video_source : debounce_switch
    port map (
        reset => reset,
        clock => debouncer_clock,
        button_in => video_source_switch,
        button_out => video_source
    );        

process(
    mem_ui_clk,
    cam_href_out, 
    cState
)
    
variable cam_href_out_previous : STD_LOGIC := '1';   
    
begin
    if rising_edge(mem_ui_clk) then
    
        if (( cState = CamWriteData_t ) or ( cState = CamWriteCmd_t )) then 
            TriggerWrite <= '0';
        else
            if ( cam_href_out /= cam_href_out_previous ) then
                cam_href_out_previous := cam_href_out;
                if ( cam_href_out = '0' ) then
                   TriggerWrite <= '1';
                end if;
            end if;
        end if;
    end if;     
end process;


process( cam_vsync, CamPage, video_source, write_enable )

variable video_source_previous : std_logic := '1';

begin
    if ( rising_edge( cam_vsync )) then
        if ( video_source_previous /= video_source ) then
            video_source_previous := video_source;
        else
            if (( write_enable = '1' ) or ( replay_video = '1' )) then
                CamPage <= CamPage + 1;
            end if;
        end if;
    end if;
end process;


process( v_sync, stream1_page, stream2_page, stream3_page, CamPage )
begin
    if ( falling_edge( v_sync )) then
        if ( ( stream1_page + 1 ) /= CamPage ) then
            stream1_page <= stream1_page + 1;
            stream2_page <= stream2_page + 1;
            stream3_page <= stream3_page + 1;
        end if;
    end if;
end process;

NEXT_STATE_DECODE: process(
    CamPage,
    TriggerWrite,
    cam_vsync_debounce,
    DoRead,
    DoDummyRead,
    mem_ui_clk,
    cState,
    calib_complete,
    ram_cen_int,
    mem_rdy,
    mem_wdf_rdy,
    ram_wen_int,
    ram_oen_int,
    mem_ui_rst,
    mem_rd_data_valid,
    CamWriteEnable
)

variable wcount: unsigned ( 6 downto 0 ) := to_unsigned( 0, 7 );
variable PrevCamVsync : std_logic := '0';
variable PrevVsync : std_logic := '1';
variable rcount: integer range 0 to 90 := 0;
variable CamAddress : unsigned( 8 downto 0 ) := to_unsigned( 0, 9 );
variable DoDummyRead_i : std_logic;

begin

    if rising_edge(mem_ui_clk) then

        if (( mem_ui_rst = '1' ) or ( reset_state_machine = '1' )) then
            cState <= Idle_t;
            stream2_store <= '0';
            stream1_store <= '0';
            stream3_store <= '0';
        else

            case(cState) is

                when Idle_t =>
            


                    if ( PrevCamVsync /= cam_vsync_debounce ) then
                      PrevCamVsync := cam_vsync_debounce; 
                      if ( cam_vsync_debounce = '1' ) then
                        CamAddress := to_unsigned( 0, 9 );
                      end if;
                    end if;

                    if ((( DoRead = '1' ) or ( DoDummyRead = '1' )) and ( calib_complete = '1' )) then                    
                        wcount := to_unsigned( 0, 7 );
                        CamHdotAddress <= unsigned( wcount );

                        rcount := 0;
                        stream1_store <= '1';
                        DoDummyRead_i := DoDummyRead;
                         
                        if ( DoRead = '1' ) then
                            --NextAddress <= "00000" & stream1_page & ReadStartAddress;
                            NextAddress <= stream1_page & ReadStartAddress;                            
                            cState <= Stream1Read_t;

                        elsif (( DoDummyRead = '1' ) and ( TriggerWrite = '1' )) then
                            NextAddress <= to_unsigned( 0, 27 );
                            cState <= Stream1Read_t;
                        end if;
                    end if;

                when Stream1Read_t =>
                    if ( mem_rdy = '1' ) then
                        if ( rcount = (79 + 0) ) then
                            cState <= Stream1ReadWait_t;
                        else
                            rcount := rcount + 1;
                        end if;

                        NextAddress <= NextAddress + "1000";
                    end if;

                when Stream1ReadWait_t =>
                    if (( mem_rdy = '1' ) and ( ReadDone = '1' )) then
                       
                        
                        if ( TriggerWrite = '1' )  then
                            
                            cState <= CamWriteStart_t;

                            --NextAddress <= "00000" & CamPage & CamAddress & "0000000000";
                            NextAddress <= CamPage & CamAddress & "0000000000";                            
                            wcount := to_unsigned( 0, 7 );
                            CamHdotAddress <= unsigned( wcount );
                        else
                            cState <= Stream2Init_t;
                        end if;
                    end if;

--
-- Camera buffer has a two clock latency before presenting data to the bus
--
                when CamWriteStart_t =>
                    
                    if ( CamWriteEnable = '1' ) then
                         if ( mem_rdy = '1' ) then
                            wcount := wcount + 1;
                            CamHdotAddress <= wcount;
                            
                            cState <= CamWriteData_t;
                        end if;
                    else
                        cState <= Stream2Init_t;
                    end if;
                    
                    
                when CamWriteData_t =>
                    
                    if ( mem_wdf_rdy = '1' ) then
                        cState <= CamWriteCmd_t;
                   end if;

--
-- Issue the write command and latch the address
--
                when CamWriteCmd_t =>
                    if ( mem_rdy = '1' ) then

                        wcount := wcount + 1;
--
-- Test for end of line
--
                        if ( wcount( 6 downto 0 ) = to_unsigned ( 80 + 1, 7 )) then
--
-- Update CamAddress to next line and start reading stream 2
--
                            CamAddress := CamAddress + to_unsigned( 1, 9 );
                            cState <= Stream2Init_t;
                            
                        else
                            CamHdotAddress <= wcount;
                            NextAddress <= NextAddress + "1000";
                            cState <= CamWriteData_t;
                        end if;

                    end if;


                when Stream2Init_t =>
                    if ( DoDummyRead_i = '0' ) then
                        --NextAddress <= "00000" & stream2_page & ReadStartAddress;
                        NextAddress <= stream2_page & ReadStartAddress;                        
                    else 
                        NextAddress <= to_unsigned( 0, 27 );
                    end if;
                    
                    rcount := 0;
                    cState <= Stream2Read_t;
                    stream1_store <= '0';
                    stream2_store <= '1';
                    
                when Stream2Read_t =>
                    if ( mem_rdy = '1' ) then
                        if ( rcount = (79 + 0) ) then
                            cState <= Stream2ReadWait_t;
                        else
                            rcount := rcount + 1;
                        end if;

                        NextAddress <= NextAddress + "1000";
                    end if;
    
                when Stream2ReadWait_t =>
                    if (( mem_rdy = '1' ) and ( ReadDone = '1' )) then
                        stream2_store <= '0';
                        cState <= Stream3Init_t;
                    end if;
    
  
               when Stream3Init_t =>
                         if ( DoDummyRead_i = '0' ) then
                             --NextAddress <= "00000" & stream3_page & ReadStartAddress;
                             NextAddress <= stream3_page & ReadStartAddress;                             
                         else 
                             NextAddress <= to_unsigned( 0, 27 );
                         end if;
                         
                         rcount := 0;
                         cState <= Stream3Read_t;
                         stream2_store <= '0';
                         stream3_store <= '1';
                         
                     when Stream3Read_t =>
                         if ( mem_rdy = '1' ) then
                             if ( rcount = (79 + 0) ) then
                                 cState <= Stream3ReadWait_t;
                             else
                                 rcount := rcount + 1;
                             end if;
     
                             NextAddress <= NextAddress + "1000";
                         end if;
         
                     when Stream3ReadWait_t =>
                         if (( mem_rdy = '1' ) and ( ReadDone = '1' )) then
                             stream3_store <= '0';
                             cState <= Finished_t;
                         end if;
                           
  
  
                    
                  
                when Finished_t =>
                    cState <= Idle_t;

                when others => 
                    cState <= Finished_t;
            end case;
            
        end if;
    end if;
end process;

process( cState, mem_rd_data_valid, mem_ui_clk )

variable count : unsigned( 6 downto 0 ) := "0000000";

begin
    if rising_edge(mem_ui_clk) then
        if (( cState = Idle_t ) or ( cState = Stream2Init_t ) or ( cState = Stream3Init_t )) then
            count := to_unsigned( 0, 7 );
            ReadDone <= '0';
            MemoryWriteAddress <= std_logic_vector( count );
        end if;
    
        if ( mem_rd_data_valid = '1' ) then
          if ( count < (79 + 0) )  then
             count := count + 1;
             MemoryWriteAddress <= std_logic_vector( count );
          else
             ReadDone <= '1';
          end if;
       end if;
   end if;
end process;


MEM_WR_CTL: process(cState)
begin
  if ( cState = CamWriteData_t ) then
     mem_wdf_wren <= '1';
     mem_wdf_end <= '1';
  else
     mem_wdf_wren <= '0';
     mem_wdf_end <= '0';
  end if;
end process MEM_WR_CTL;

MEM_CTL: process(cState)
begin
  if (( cState = Stream1Read_t ) or ( cState = Stream2Read_t ) or ( cState = Stream3Read_t )) then
     mem_en <= '1';
     mem_cmd <= CMD_READ;
  elsif ( cState = CamWriteCmd_t ) then
     mem_en <= '1';
     mem_cmd <= CMD_WRITE;
  else
     mem_en <= '0';
     mem_cmd <= (others => '0');
  end if;
end process MEM_CTL;


process ( stream1_data_out, hdotLatched )

begin

 case(HdotLatched(2 downto 0)) is
 
    when "000" =>
     stream1_pixel <= stream1_data_out(11 downto 0);
     
    when "001" =>
     stream1_pixel <= stream1_data_out(23 downto 12);

    when "010" =>
     stream1_pixel <= stream1_data_out(35 downto 24);
     
    when "011" =>     
     stream1_pixel <= stream1_data_out(47 downto 36);
     
    when "100" =>
     stream1_pixel <= stream1_data_out(59 downto 48);
     
    when "101" =>
     stream1_pixel <= stream1_data_out(71 downto 60);
     
    when "110" =>
     stream1_pixel <= stream1_data_out(83 downto 72);
     
    when "111" =>
     stream1_pixel <= stream1_data_out(95 downto 84);
     
  end case;
     
end process;

process ( stream2_data_out, hdotLatched ) -- , VideoClock )

begin

 case(HdotLatched(2 downto 0)) is
 
    when "000" =>
     stream2_pixel <= stream2_data_out(11 downto 0);
     
    when "001" =>
     stream2_pixel <= stream2_data_out(23 downto 12);

    when "010" =>
     stream2_pixel <= stream2_data_out(35 downto 24);
     
    when "011" =>     
     stream2_pixel <= stream2_data_out(47 downto 36);
     
    when "100" =>
     stream2_pixel <= stream2_data_out(59 downto 48);
     
    when "101" =>
     stream2_pixel <= stream2_data_out(71 downto 60);
     
    when "110" =>
     stream2_pixel <= stream2_data_out(83 downto 72);
     
    when "111" =>
     stream2_pixel <= stream2_data_out(95 downto 84);
     
  end case;
     
end process;


process ( stream3_data_out, hdotLatched )

begin

 case(HdotLatched(2 downto 0)) is
 
    when "000" =>
     stream3_pixel <= stream3_data_out(11 downto 0);
     
    when "001" =>
     stream3_pixel <= stream3_data_out(23 downto 12);

    when "010" =>
     stream3_pixel <= stream3_data_out(35 downto 24);
     
    when "011" =>     
     stream3_pixel <= stream3_data_out(47 downto 36);
     
    when "100" =>
     stream3_pixel <= stream3_data_out(59 downto 48);
     
    when "101" =>
     stream3_pixel <= stream3_data_out(71 downto 60);
     
    when "110" =>
     stream3_pixel <= stream3_data_out(83 downto 72);
     
    when "111" =>
     stream3_pixel <= stream3_data_out(95 downto 84);
     
  end case;
     
end process;


vsync_debounce : process( clk_5Mhz_i, cam_vsync )

variable Count: integer range 0 to 20 := 0;
variable vsync_previous: std_logic := '0';

begin
    if ( rising_edge( clk_5Mhz_i )) then

        if ( vsync_previous /= cam_vsync ) then
            if ( Count /= 5 ) then
                Count := Count + 1;
            else
                vsync_previous := cam_vsync;
            end if;
        else
            Count := 0;
        end if;
    end if;
    
    cam_vsync_debounce <= vsync_previous and cam_vsync;
    
end process;



process (  video_pixel, visible_frame, Vline, H_sync, v_sync )

begin
    if ( visible_frame = '1' ) then
        video_vga_red <= video_pixel( 11 downto 8 );
        video_vga_green <= video_pixel( 7 downto 4 );
        video_vga_blue <= video_pixel( 3 downto 0 );
    else
        video_vga_red <= "0000";
        video_vga_green <= "0000";
        video_vga_blue <= "0000";
   end if;
   
   video_h_sync <= h_sync;
   video_v_sync <= v_sync;
end process;




do_reset:   process( clk_200Mhz_i )

variable Delay : integer range 0 to 20000000 := 0;
begin
	if ( rising_edge( clk_200Mhz_i )) then
		if ( Delay = 20000000 ) then
			reset <= '0';
		else
			reset <= '1';
			Delay := Delay + 1;
		end if;
	end if;
end process;

reset_not <= not reset;



status_leds(0) <= '1' when cState = Idle_t else '0';
status_leds(1) <= '1' when cState = Stream1Read_t else '0';
status_leds(2) <= '1' when cState = Stream1ReadWait_t else '0';   
status_leds(3) <= '1' when cState = CamWriteStart_t else '0'; 
status_leds(4) <= '1' when cState = CamWriteData_t else '0'; 
status_leds(5) <= '1' when cState = CamWriteCmd_t else '0'; 
status_leds(6) <= '1' when cState = Stream2Init_t else '0'; 
status_leds(7) <= '1' when cState = Stream2Read_t else '0'; 
status_leds(8) <= '1' when cState = Stream2ReadWait_t else '0'; 

status_leds(9) <= '1' when cState = Stream3Init_t else '0'; 
status_leds(10) <= '1' when cState = Stream3Read_t else '0'; 
status_leds(11) <= '1' when cState = Stream3ReadWait_t else '0'; 
status_leds(12) <= '1' when cState = Finished_t else '0'; 

video_clock <= VideoClock;
clock_200Mhz <= clk_200Mhz_i;

video_h_dot  <= hdot;
video_v_line <= vline;
video_h_sync <= h_sync;
video_v_sync <= v_sync;
video_visible_frame  <= visible_frame;
end Behavioral;




