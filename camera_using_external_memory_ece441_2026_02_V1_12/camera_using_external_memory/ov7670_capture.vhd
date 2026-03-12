-- Captures the pixels data of each frame coming from the OV7670 camera and 
-- Stores them in block RAM
-- The length of href controls how often pixels are captive - (2 downto 0) stores
-- one pixel every 4 cycles.
-- "line" is used to control how often data is captured. In this case every forth 
-- line

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ov7670_capture is
  Port ( 
    pclk  : in   STD_LOGIC;
    vsync : in   STD_LOGIC;
    href  : in   STD_LOGIC;
    d     : in   STD_LOGIC_VECTOR (7 downto 0);
    addr  : out  STD_LOGIC_VECTOR (6 downto 0);
    dout  : out  STD_LOGIC_VECTOR (95 downto 0);
    we    : out  STD_LOGIC;
    StoreEvenLine : out STD_LOGIC;
    href_out : out STD_LOGIC;
    vsync_out : out STD_LOGIC
    --StoreAddress : out STD_LOGIC_VECTOR(26 downto 0 )
    );
end ov7670_capture;



 architecture Behavioral of ov7670_capture is


  signal d_latch      : std_logic_vector(95 downto 0) := (others => '0');
  signal address      : STD_LOGIC_VECTOR(9 downto 0) := (others => '0');

  signal href_last    : std_logic_vector(6 downto 0)  := (others => '0');
  signal we_reg       : std_logic := '0';
--  signal href_hold    : std_logic := '0';
  signal latched_vsync : STD_LOGIC := '0';
  signal latched_href  : STD_LOGIC := '0';
  signal latched_d     : STD_LOGIC_VECTOR (11 downto 0) := (others => '0');
  signal camera_data : STD_LOGIC_VECTOR ( 95 downto 0 );
  signal StoreEven : STD_LOGIC := '1';  
  signal Triggerevent : STD_LOGIC;
  
  
begin

  addr <= address(9 downto 3 );
  we <= we_reg;
  href_out <= latched_href;
  vsync_out <= latched_vsync;


 -- dout <= d_latch(15 downto 12) & d_latch(10 downto 7) & d_latch(4 downto 1); 
  dout <= d_latch; -- camera_data; 
  StoreEvenLine <= StoreEven;
  
  
  
  capture_process: process(pclk, href, address, StoreEven, d  )
  

    variable OriginalData : std_logic_vector( 7 downto 0 );
    variable tState : integer range 0 to 5 := 0;
    variable href_old : std_logic := '0';
    variable latched_vsync_prev : std_logic := '0';

    
    begin
      if rising_edge(pclk) then
      
        if we_reg = '1' then
            address <= std_logic_vector(unsigned(address)+1);
        end if;

--        href_hold <= latched_href;
         
        -- capturing the data from the camera, 12-bit RGB
        if latched_href = '1' then
            d_latch <= camera_data;
        end if;
        
      we_reg  <= '0';

        -- Is a new screen about to start (i.e. we have to restart capturing
        if ( latched_vsync_prev /= latched_vsync ) then
            latched_vsync_prev := latched_vsync;
            if ( latched_vsync = '1' ) then 
                StoreEven <= '1';
                address      <= (others => '0');
                href_last    <= (others => '0');
            end if;         
        end if;

        if ( latched_vsync = '0' ) then        
            if ( href_old /= href ) then
                href_old := href;
                if ( href = '0' ) then
                    address <= (others => '0');
                    StoreEven <= not StoreEven;
                end if;
            end if;                     
        
        
          -- If not, set the write enable whenever we need to capture a pixel
          if href_last(0) = '1' then
                we_reg <= '1';
                href_last <= (others => '0');
          else
            href_last <= href_last(href_last'high-1 downto 0) & latched_href;
          end if;
        end if;
      end if; -- if rising_edge(pclk) then


    if ( falling_edge( pclk )) then

        if ( latched_vsync = '1' ) then
            tState := 0;
--            StoreEven <= '1';
--            address      <= (others => '0');
--            href_last    <= (others => '0');
--        else            
--            if ( href_old /= href ) then
--            href_old := href;
--                if ( href = '0' ) then
--                    address <= (others => '0');
--                    StoreEven <= not StoreEven;
--                end if;
--            end if;
        end if;       


        if ( tState = 0 ) then

            OriginalData( 7 downto 0 ) := d;
            tState := 1;


        elsif( tState = 1 ) then

--
-- Display single pixel
--          
            case( Address( 2 downto 0 )) is
            
            when "000" =>
                camera_data( 11 downto 0 ) <= OriginalData( 7 downto 4 ) & OriginalData( 2 downto 0 ) & d(7) & d( 4 downto 1 );
                
            when "001" =>      
                camera_data( 23 downto 12 ) <= OriginalData( 7 downto 4 ) & OriginalData( 2 downto 0 ) & d(7) & d( 4 downto 1 );
                
            when "010" =>      
                camera_data( 35 downto 24 ) <= OriginalData( 7 downto 4 ) & OriginalData( 2 downto 0 ) & d(7) & d( 4 downto 1 );
                
            when "011" =>      
                camera_data( 47 downto 36 ) <= OriginalData( 7 downto 4 ) & OriginalData( 2 downto 0 ) & d(7) & d( 4 downto 1 );
                
            when "100" =>      
                camera_data( 59 downto 48 ) <= OriginalData( 7 downto 4 ) & OriginalData( 2 downto 0 ) & d(7) & d( 4 downto 1 );
                
            when "101" =>      
                camera_data( 71 downto 60 ) <= OriginalData( 7 downto 4 ) & OriginalData( 2 downto 0 ) & d(7) & d( 4 downto 1 );
                
            when "110" =>      
                camera_data( 83 downto 72 ) <= OriginalData( 7 downto 4 ) & OriginalData( 2 downto 0 ) & d(7) & d( 4 downto 1 );
                
            when "111" =>
                camera_data( 95 downto 84 ) <= OriginalData( 7 downto 4 ) & OriginalData( 2 downto 0 ) & d(7) & d( 4 downto 1 );
            end case;
            

            tState := 0;
        end if;

        latched_href  <= href;
        latched_vsync <= vsync;
      end if; -- if falling_edge(pclk) then
      
    end process;
  
end Behavioral;
