-----------------------------------------------------------
--
-- ECE241 Lab 2
--
-- Example 2 test bench
--
-- (c)2018 Dr. D. Capson   Dept. of ECE
--                         University of Victoria
--
-----------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.numeric_STD.all;

--  the entity for your test bench code must be declared
--  as follows:

entity Example2_testbench is
end Example2_testbench;

architecture simulate of Example2_testbench is

--component video_timing is
--    generic (
--        HSYNC_FRONT_PORCH : integer;
--        HSYNC_SYNC_PULSE : integer;
--        HSYNC_LINE_WIDTH : integer;
--        HSYNC_POLARITY : STD_LOGIC;

--        VSYNC_FRONT_PORCH : integer;
--        VSYNC_SYNC_PULSE : integer;
--        VSYNC_FRAME_WIDTH : integer;
--        VSYNC_POLARITY : STD_LOGIC;

--        BOARD_DIVIDER : INTEGER range 1 to 4;
--        SCREEN_X_SIZE : UNSIGNED( 10 downto 0 );
--        SCREEN_Y_SIZE : UNSIGNED( 9 downto 0 )
--    );
--    Port (
--        clock : in STD_LOGIC;
--        h_sync : out STD_LOGIC;
--        v_sync : out STD_LOGIC;
--        h_dot : out UNSIGNED( 10 downto 0 );
--        v_line : out UNSIGNED( 9 downto 0 );
--	    visible_frame : out std_logic;
--	    VideoClock : out std_logic;
--	    clock_state_out : out UNSIGNED ( 2 downto 0 )
--    );
--end component;

constant BASYS_3_CLOCK_DIVIDER : INTEGER range 1 to 4 := 4;
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


	signal clock: std_logic := '0';
    signal   h_sync :  STD_LOGIC;
    signal v_sync :  STD_LOGIC;
    signal h_dot :  UNSIGNED( 10 downto 0 );
    signal v_line :  UNSIGNED( 9 downto 0 );
    signal visible_frame :  std_logic;
    signal VideoClock :  std_logic;
    signal clock_state_out :  UNSIGNED ( 2 downto 0 );
    signal video_red_latch : STD_LOGIC;
    signal video_green_latch : STD_LOGIC;
    signal video_blue_latch : STD_LOGIC;

begin

-- entity instantiation (uut = "unit under test")
-- the name of the entity ("Example2" in this example) must
-- match the name of your upper level entity that you are
-- simulating.  Also the word "work" must be used as shown.
-- You should do explicit connections in the port map as follows
-- (otherwise you get a warning):
--      ( ip1 => ip1_s, ip2 => ip2_s, sum => sum_s, ca => ca_s);

--uut : entity work.Example2 port map(a=>a, b=>b, c=>c, d=>d, Y1=>Y1, Y2=>Y2, Y3=>Y3, Y4=>Y4, Y5=>Y5);
uut : entity work.video_timing generic map
   (

       HSYNC_FRONT_PORCH => 16,
       HSYNC_SYNC_PULSE => 96,
       HSYNC_LINE_WIDTH => 800,
       HSYNC_POLARITY => '0',

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
       clock => clock, -- clk_200Mhz_i,
       h_sync => h_sync,
       v_sync => v_sync,
       h_dot => h_dot,
       v_line => v_line,
       visible_frame => visible_frame,
       VideoClock => VideoClock,
       clock_state_out => clock_state_out,
       video_green_latch => video_green_latch,
       video_blue_latch => video_blue_latch,
       video_red_latch => video_red_latch
   );

-- specify a sequence of inputs for simulating our design

process 
	begin
    clock <= '0';

    for i in 0 to 1000 loop
	clock <= '0';
	wait for 1 ns;
    clock <= '1';
    wait for 1 ns;
    end loop;
    
 
	wait;

end process;

end simulate;