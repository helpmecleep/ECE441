----------------------------------------------------------------------------------
--
-- ECE 441  2022
--
-- 16x8 text buffer display for SSD1306 OLED display
--
-- (c)2023 B. Sirna         Dept. of ECE
--                          University of Victoria
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use ieee.numeric_std.all;




entity oled_display is
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
        replay_video : in STD_LOGIC;
        EnableWrite : in std_logic;
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
end oled_display;



architecture Behavioral of oled_display is

type oled_graphics_buffer_type is array( 0 to 7) of std_logic_vector( 0 to 1023 );
--type oled_graphics_buffer_type is array( 7 downto 0) of std_logic_vector( 0 to 1023 );

signal oled_graphics_buffer : oled_graphics_buffer_type;

--
-- OLED 16 x 8 character display storage 
--

type oled_buffer_type is array( 0 to 127 ) of integer;

signal oled_buffer : oled_buffer_type := (
    0000 => character'pos(' ') - 32,  -- Row 0
    0001 => character'pos('E') - 32,
    0002 => character'pos('C') - 32,
    0003 => character'pos('E') - 32,
    0004 => character'pos(' ') - 32,
    0005 => character'pos('4') - 32,
    0006 => character'pos('4') - 32,
    0007 => character'pos('1') - 32,
    0008 => character'pos(' ') - 32,
    0009 => character'pos('C') - 32,
    0010 => character'pos('A') - 32,
    0011 => character'pos('M') - 32,
    0012 => character'pos('E') - 32,
    0013 => character'pos('R') - 32,
    0014 => character'pos('A') - 32,
    0015 => character'pos(' ') - 32,

    0016 => character'pos(' ') - 32, -- Row 1
    0017 => character'pos(' ') - 32,
    0018 => character'pos(' ') - 32,
    0019 => character'pos(' ') - 32,
    0020 => character'pos(' ') - 32,
    0021 => character'pos(' ') - 32,
    0022 => character'pos(' ') - 32,
    0023 => character'pos(' ') - 32,
    0024 => character'pos(' ') - 32,
    0025 => character'pos(' ') - 32,
    0026 => character'pos(' ') - 32,
    0027 => character'pos(' ') - 32,
    0028 => character'pos(' ') - 32,
    0029 => character'pos(' ') - 32,
    0030 => character'pos(' ') - 32,
    0031 => character'pos(' ') - 32,

    0032 => character'pos('S') - 32, -- Row 2
    0033 => character'pos('T') - 32,
    0034 => character'pos('A') - 32,
    0035 => character'pos('T') - 32,
    0036 => character'pos('U') - 32,
    0037 => character'pos('S') - 32,
    0038 => character'pos(':') - 32,
    0039 => character'pos(' ') - 32,
    0040 => character'pos(' ') - 32,
    0041 => character'pos(' ') - 32,
    0042 => character'pos(' ') - 32,
    0043 => character'pos(' ') - 32,
    0044 => character'pos(' ') - 32,
    0045 => character'pos(' ') - 32,
    0046 => character'pos(' ') - 32,
    0047 => character'pos(' ') - 32,

    0048 => character'pos('S') - 32, -- Row 3
    0049 => character'pos('O') - 32,
    0050 => character'pos('U') - 32,
    0051 => character'pos('R') - 32,
    0052 => character'pos('C') - 32,
    0053 => character'pos('E') - 32,
    0054 => character'pos(':') - 32,
    0055 => character'pos(' ') - 32,
    0056 => character'pos(' ') - 32,
    0057 => character'pos(' ') - 32,
    0058 => character'pos(' ') - 32,
    0059 => character'pos(' ') - 32,
    0060 => character'pos(' ') - 32,
    0061 => character'pos(' ') - 32,
    0062 => character'pos(' ') - 32,
    0063 => character'pos(' ') - 32,

    0064 => character'pos('O') - 32, -- Row 4
    0065 => character'pos('U') - 32,
    0066 => character'pos('T') - 32,
    0067 => character'pos('P') - 32,
    0068 => character'pos('U') - 32,
    0069 => character'pos('T') - 32,
    0070 => character'pos(':') - 32,
    0071 => character'pos(' ') - 32,
    0072 => character'pos(' ') - 32,
    0073 => character'pos(' ') - 32,
    0074 => character'pos(' ') - 32,
    0075 => character'pos(' ') - 32,
    0076 => character'pos(' ') - 32,
    0077 => character'pos(' ') - 32,
    0078 => character'pos(' ') - 32,
    0079 => character'pos(' ') - 32,

    0080 => character'pos(' ') - 32, -- Row 5
    0081 => character'pos(' ') - 32,
    0082 => character'pos(' ') - 32,
    0083 => character'pos(' ') - 32,
    0084 => character'pos(' ') - 32,
    0085 => character'pos(' ') - 32,
    0086 => character'pos(' ') - 32,
    0087 => character'pos(' ') - 32,
    0088 => character'pos(' ') - 32,
    0089 => character'pos(' ') - 32,
    0090 => character'pos(' ') - 32,
    0091 => character'pos(' ') - 32,
    0092 => character'pos(' ') - 32,
    0093 => character'pos(' ') - 32,
    0094 => character'pos(' ') - 32,
    0095 => character'pos(' ') - 32,

    0096 => character'pos('F') - 32, -- Row 6
    0097 => character'pos('R') - 32,
    0098 => character'pos('A') - 32,
    0099 => character'pos('M') - 32,
    0100 => character'pos('E') - 32,
    0101 => character'pos(' ') - 32,
    0102 => character'pos('R') - 32,
    0103 => character'pos('A') - 32,
    0104 => character'pos('T') - 32,
    0105 => character'pos('E') - 32,
    0106 => character'pos(':') - 32,
    0107 => character'pos(' ') - 32,
    0108 => character'pos('1') - 32,
    0109 => character'pos('5') - 32,
    0110 => character'pos('H') - 32,
    0111 => character'pos('z') - 32,

    0112 => character'pos('D') - 32, -- Row 7
    0113 => character'pos('R') - 32,
    0114 => character'pos('I') - 32,
    0115 => character'pos('V') - 32,
    0116 => character'pos('E') - 32,
    0117 => character'pos(':') - 32,
    0118 => character'pos(' ') - 32,
    0119 => character'pos('0') - 32,
    0120 => character'pos(' ') - 32,
    0121 => character'pos(' ') - 32,
    0122 => character'pos(' ') - 32,
    0123 => character'pos('V') - 32,
    0124 => character'pos('1') - 32,
    0125 => character'pos('.') - 32,
    0126 => character'pos('1') - 32,
    0127 => character'pos('2') - 32
);

type information_text_type is array( 0 to 83 ) of integer;

signal information_text : information_text_type := (
    0000 => character'pos('L') - 32,    -- Live
    0001 => character'pos('I') - 32,
    0002 => character'pos('V') - 32,
    0003 => character'pos('E') - 32,
    0004 => character'pos(' ') - 32,
    0005 => character'pos(' ') - 32,
    
    0006 => character'pos('R') - 32,    -- Replay
    0007 => character'pos('E') - 32,
    0008 => character'pos('P') - 32,
    0009 => character'pos('L') - 32,
    0010 => character'pos('A') - 32,
    0011 => character'pos('Y') - 32,
    
    0012 => character'pos('N') - 32,    -- Normal
    0013 => character'pos('O') - 32,
    0014 => character'pos('R') - 32,
    0015 => character'pos('M') - 32,
    0016 => character'pos('A') - 32,
    0017 => character'pos('L') - 32,
    0018 => character'pos(' ') - 32,
    
    0019 => character'pos('I') - 32,    -- Inverse
    0020 => character'pos('N') - 32,
    0021 => character'pos('V') - 32,
    0022 => character'pos('E') - 32,
    0023 => character'pos('R') - 32,
    0024 => character'pos('S') - 32,
    0025 => character'pos('E') - 32,
    
    0026 => character'pos('S') - 32,    -- Sad
    0027 => character'pos('A') - 32,
    0028 => character'pos('D') - 32,
    0029 => character'pos(' ') - 32,
    0030 => character'pos(' ') - 32,
    0031 => character'pos(' ') - 32,
    0032 => character'pos(' ') - 32,
    
    0033 => character'pos('S') - 32,    -- Sobel
    0034 => character'pos('O') - 32,
    0035 => character'pos('B') - 32,
    0036 => character'pos('E') - 32,
    0037 => character'pos('L') - 32,
    0038 => character'pos(' ') - 32,
    0039 => character'pos(' ') - 32,
    
    0040 => character'pos('G') - 32,    -- Gray
    0041 => character'pos('R') - 32,
    0042 => character'pos('A') - 32,
    0043 => character'pos('Y') - 32,
    0044 => character'pos(' ') - 32,
    0045 => character'pos(' ') - 32,
    0046 => character'pos(' ') - 32,
    
    0047 => character'pos('C') - 32,    -- Camera
    0048 => character'pos('A') - 32,
    0049 => character'pos('M') - 32,
    0050 => character'pos('E') - 32,
    0051 => character'pos('R') - 32,
    0052 => character'pos('A') - 32,
    0053 => character'pos(' ') - 32,
    0054 => character'pos(' ') - 32,
    
    0055 => character'pos('P') - 32,    -- Pictures
    0056 => character'pos('I') - 32,
    0057 => character'pos('C') - 32,
    0058 => character'pos('T') - 32,
    0059 => character'pos('U') - 32,
    0060 => character'pos('R') - 32,
    0061 => character'pos('E') - 32,   
    0062 => character'pos('S') - 32,

    
    0063 => character'pos('3') - 32,    -- 30hz
    0064 => character'pos('0') - 32,
    0065 => character'pos('H') - 32,
    0066 => character'pos('z') - 32,
    
    0067 => character'pos('1') - 32,    -- 15Hz
    0068 => character'pos('5') - 32,
    0069 => character'pos('H') - 32,
    0070 => character'pos('z') - 32,

    0071 => character'pos('X') - 32,    -- Xor
    0072 => character'pos('O') - 32,
    0073 => character'pos('R') - 32,
    0074 => character'pos(' ') - 32,
    0075 => character'pos(' ') - 32,
    0076 => character'pos(' ') - 32,
    0077 => character'pos(' ') - 32,
    
    0078 => character'pos('F') - 32,    -- Live
    0079 => character'pos('R') - 32,
    0080 => character'pos('E') - 32,
    0081 => character'pos('E') - 32,
    0082 => character'pos('Z') - 32,
    0083 => character'pos('E') - 32    
);




--
-- 5x7 dot matrix printable ASCII character generator ROM. The first 32 control
-- characters have been removed to conserve memory space 
--

type character_generator_type is array( 0 to 95 ) of std_logic_vector( 39 downto 0 );

constant characters : character_generator_type := (

0000 => "0000000000000000000000000000000000000000", -- SPACE
0001 => "0000000000000000010111110000000000000000", -- !
0002 => "0000000000000111000000000000011100000000", -- "
0003 => "0001010001111111000101000111111100010100", -- #
0004 => "0010010000101010011111110010101000010010", -- $
0005 => "0010001100010011000010000110010001100010", -- %
0006 => "0011011001001001010101010010001001010000", -- &
0007 => "0000000000000101000000110000000000000000", -- '
0008 => "0000000000011100001000100100000100000000", -- (
0009 => "0000000001000001001000100001110000000000", -- )
0010 => "0001010000001000001111100000100000010100", -- *
0011 => "0000100000001000001111100000100000001000", -- +
0012 => "0000000001010000001100000000000000000000", -- ,
0013 => "0000100000001000000010000000100000001000", -- -
0014 => "0000000001100000011000000000000000000000", -- .
0015 => "0010000000010000000010000000010000000010", -- /
0016 => "0011111001010001010010010100010100111110", -- 0
0017 => "0000000001000010011111110100000000000000", -- 1
0018 => "0100001001100001010100010100100101000110", -- 2
0019 => "0010000101000001010001010100101100110001", -- 3
0020 => "0001100000010100000100100111111100010000", -- 4
0021 => "0010011101000101010001010100010100111001", -- 5
0022 => "0011110001001010010010010100100100110000", -- 6
0023 => "0000001100000001011100010000100100000111", -- 7
0024 => "0011011001001001010010010100100100110110", -- 8
0025 => "0000011001001001010010010010100100011110", -- 9
0026 => "0000000000110110001101100000000000000000", -- :
0027 => "0000000001010110001101100000000000000000", -- ;
0028 => "0000100000010100001000100100000100000000", -- <
0029 => "0001010000010100000101000001010000010100", -- =
0030 => "0000000001000001001000100001010000001000", -- >
0031 => "0000001000000001010100010000100100000110", -- ?
0032 => "0011001001001001011110010100000100111110", -- @
0033 => "0111111000010001000100010001000101111110", -- A
0034 => "0111111101001001010010010100100100110110", -- B
0035 => "0011111001000001010000010100000100100010", -- C
0036 => "0111111101000001010000010010001000011100", -- D
0037 => "0111111101001001010010010100100101000001", -- E
0038 => "0111111100001001000010010000100100000001", -- F
0039 => "0011111001000001010010010100100101111010", -- G
0040 => "0111111100001000000010000000100001111111", -- H
0041 => "0100000001000001011111110100000101000000", -- I
0042 => "0010000001000000010000010011111100000001", -- J
0043 => "0111111100001000000101000010001001000001", -- K
0044 => "0111111101000000010000000100000001000000", -- L
0045 => "0111111100000010000011000000001001111111", -- M
0046 => "0111111100000100000010000001000001111111", -- N
0047 => "0011111001000001010000010100000100111110", -- O
0048 => "0111111100001001000010010000100100000110", -- P
0049 => "0011111001000001010100010010000101011110", -- Q
0050 => "0111111100001001000110010010100101000110", -- R
0051 => "0100011001001001010010010100100100110001", -- S
0052 => "0000000100000001011111110000000100000001", -- T
0053 => "0011111101000000010000000100000000111111", -- U
0054 => "0001111100100000010000000010000000011111", -- V
0055 => "0011111101000000001110000100000000111111", -- W
0056 => "0110001100010100000010000001010001100011", -- X
0057 => "0000011100001000011100000000100000000111", -- Y
0058 => "0110000101010001010010010100010101000011", -- Z
0059 => "0111111101000001000000000000000000000000", -- [
0060 => "0001010100010110011111000001011000010101", -- \
0061 => "0000000000000000000000000100000101111111", -- ]
0062 => "0000010000000010000000010000001000000100", -- ^
0063 => "0100000001000000010000000100000001000000", -- _
0064 => "0000000000000001000000100000010000000000", -- `
0065 => "0010000001010100010101000101010001111000", -- a
0066 => "0111111101001000010001000100010000111000", -- b
0067 => "0011100001000100010001000100010000100000", -- c
0068 => "0011100001000100010001000100100001111111", -- d
0069 => "0011100001010100010101000101010000011000", -- e
0070 => "0000100001111110000010010000000100000010", -- f
0071 => "0000110001010010010100100101001000111110", -- g
0072 => "0111111100001000000001000000010001111000", -- h
0073 => "0000000001000100011111010100000000000000", -- i
0074 => "0010000001000000010001000011110100000000", -- j
0075 => "0111111100010000001010000100010000000000", -- k
0076 => "0000000001000001011111110100000000000000", -- l
0077 => "0111110000000100000110000000010001111000", -- m
0078 => "0111110000001000000001000000010001111000", -- n
0079 => "0011100001000100010001000100010000111000", -- o
0080 => "0111110000010100000101000001010000001000", -- p
0081 => "0000100000010100000101000001100001111100", -- q
0082 => "0111110000001000000001000000010000001000", -- r
0083 => "0100100001010100010101000101010000100000", -- s
0084 => "0000010000111111010001000100000000100000", -- t
0085 => "0011110001000000010000000010000001111100", -- u
0086 => "0001110000100000010000000010000000011100", -- v
0087 => "0011110001000000001110000100000000111100", -- w
0088 => "0100010000101000000100000010100001000100", -- x
0089 => "0000110001010000010100000101000000111100", -- y
0090 => "0100010001100100010101000100110001000100", -- z
0091 => "0000000000001000001101100100000100000000", -- {
0092 => "0000000000000000011111110000000000000000", -- |
0093 => "0000000001000001001101100000100000000000", -- }
0094 => "0000100000001000001010100001110000001000", -- ~
0095 => "0000100000011100001010100000100000001000"  -- <-
);



--
-- OLED command set
--

constant SET_CONTRAST : std_logic_vector( 7 downto 0 ) := x"81";
constant SET_ENTIRE_ON : std_logic_vector( 7 downto 0 ) := x"A4";
constant SET_NORM_INV : std_logic_vector( 7 downto 0 ) := x"A6";
constant SET_DISP : std_logic_vector( 7 downto 0 ) := x"AE";
constant SET_MEM_ADDR : std_logic_vector( 7 downto 0 ) := x"20";
constant SET_COL_ADDR : std_logic_vector( 7 downto 0 ) := x"21";
constant SET_PAGE_ADDR : std_logic_vector( 7 downto 0 ) := x"22";
constant SET_DISP_START_LINE : std_logic_vector( 7 downto 0 ) := x"40";
constant SET_SEG_REMAP : std_logic_vector( 7 downto 0 ) := x"A0";
constant SET_MUX_RATIO : std_logic_vector( 7 downto 0 ) := x"A8";
constant SET_IREF_SELECT : std_logic_vector( 7 downto 0 ) := x"AD";
constant SET_COM_OUT_DIR : std_logic_vector( 7 downto 0 ) := x"C0";
constant SET_DISP_OFFSET : std_logic_vector( 7 downto 0 ) := x"D3";
constant SET_COM_PIN_CFG : std_logic_vector( 7 downto 0 ) := x"DA";
constant SET_DISP_CLK_DIV : std_logic_vector( 7 downto 0 ) := x"D5";
constant SET_PRECHARGE : std_logic_vector( 7 downto 0 ) := x"D9";
constant SET_VCOM_DESEL : std_logic_vector( 7 downto 0 ) := x"DB";
constant SET_CHARGE_PUMP : std_logic_vector( 7 downto 0 ) := x"8D";
constant SET_PAGE_START_ADDRESS : std_logic_vector( 7 downto 0 ) := x"B0";
constant SET_LOWER_COLUMN_START_ADDRESS : std_logic_vector( 7 downto 0 ) := x"00";
constant SET_HIGHER_COLUMN_START_ADDRESS : std_logic_vector( 7 downto 0 ) := x"10";


--
-- Initialization commands for the OLED display
--

constant OLED_COMMAND_INIT_SIZE : integer := 27;

type oled_init_commands_type is array ( 0 to OLED_COMMAND_INIT_SIZE - 1 ) of std_logic_vector( 7 downto 0 );

constant oled_init_commands : oled_init_commands_type := (

0000 => SET_DISP,
0001 => SET_MEM_ADDR,
0002 => x"00",
0003 => SET_DISP_START_LINE,
0004 => SET_SEG_REMAP or x"01",
0005 => SET_MUX_RATIO,
0006 => std_logic_vector( to_unsigned( 64 - 1, 8 )),
0007 => SET_COM_OUT_DIR or x"08",
0008 => SET_DISP_OFFSET,
0009 => x"00",
0010 => SET_COM_PIN_CFG,
0011 => x"12", -- 0x02 if self.width > 2 * self.height else 0x12,
0012 => SET_DISP_CLK_DIV,
0013 => x"80",
0014 => SET_PRECHARGE,
0015 => x"22", -- 0x22 if self.external_vcc else 0xF1,
0016 => SET_VCOM_DESEL,
0017 => x"30", -- 0.83*Vcc
0018 => SET_CONTRAST,
0019 => x"FF",
0020 => SET_ENTIRE_ON, -- output follows RAM contents
0021 => SET_NORM_INV, -- not inverted
0022 => SET_IREF_SELECT,
0023 => x"30",
0024 => SET_CHARGE_PUMP,
0025 => x"10", -- if self.external_vcc else 0x14,
0026 => SET_DISP or x"01"
);

--
-- OLED command to set the starting page address ( row number ) when writing to the screen. Lower 4 bits
-- of the command SET_PAGE_START_ADDRESS is the start page address 
--

constant OLED_WRITE_SCREEN_SIZE : integer := 3;
type oled_write_screen_commands_type is array ( 0 to OLED_WRITE_SCREEN_SIZE - 1 ) of std_logic_vector( 7 downto 0 );

signal oled_write_screen_commands : oled_write_screen_commands_type := (

    0000 => SET_PAGE_START_ADDRESS,
    0001 => SET_LOWER_COLUMN_START_ADDRESS or x"02",
    0002 => SET_HIGHER_COLUMN_START_ADDRESS
);

--
-- signals related to spi transmission
--
    signal spi_tx_data : std_logic_vector( 7 downto 0 ) := x"00";
    signal spi_tx_start : std_logic := '0';
    signal spi_tx_done : std_logic := '0';
    signal dc : std_logic := '0';

--
-- Cursor related signals
--
    signal cursor_clock : std_logic := '0';
    signal cursor_position : unsigned ( 6 downto 0 ) := "1111111";

--
-- System related signals
--
    signal system_clock : std_logic := '0';
    signal system_reset : std_logic := '1';


begin

update_graphics : process (
    v_sync,
    h_sync,
    v_line,
    h_dot,
    gray_bit,
    video_clock,
    visible_frame
)

variable v_line_next :  UNSIGNED( 9 downto 0 ) := to_unsigned( 0, 10 );
variable h_dot_next : UNSIGNED( 10 downto 0 ) := to_unsigned( 0, 11 );
variable v_line_store : UNSIGNED( 5 downto 0 ) := to_unsigned( 0, 6 );
variable h_dot_store : UNSIGNED( 10 downto 0 ) := to_unsigned( 0, 11 );

begin
    if ( rising_edge( video_clock )) then
    
        if ( v_sync = '0' ) then 
            v_line_next := to_unsigned( 0, 10 );
            h_dot_next := to_unsigned( 0, 11 );
            v_line_store := to_unsigned( 0, 6 );
        end if;
        
        
        if ( h_sync = '0' ) then
            h_dot_next := to_unsigned( 0, 11 );
            if ( v_line_next = v_line ) then
                v_line_next := v_line_next + 7;
                v_line_store := v_line_store + 1;
            end if;
        end if;

        if (( v_line < 448 ) and ( visible_frame = '1' )) then
        if ( v_line_next = v_line ) then

            if ( h_dot_next = h_dot ) then

--                oled_graphics_buffer( to_integer( not v_line_store( 5 downto 3 )))( to_integer( h_dot_store( 6 downto 0 ) & v_line_store( 2 downto 0 ))) <= gray_bit;
                oled_graphics_buffer( to_integer( v_line_store( 5 downto 3 )))( to_integer( h_dot_store( 6 downto 0 ) & ( not v_line_store( 2 downto 0 )))) <= gray_bit;

                h_dot_next := h_dot_next + 5;
                h_dot_store := h_dot_store + 1; 
            end if; 
        end if;
        end if;

    end if;
end process;


update_status : process (
    system_clock,
    EnableWrite,
    video_source_switch,
    stream_select,
    camera_refresh_rate
)
--
-- Current state the process is in
--

variable state : integer range 0 to 11 := 0;
variable next_state : integer range 0 to 11 := 0;
variable text_pointer : integer range 0 to 127 := 0;
variable text_length : integer range 0 to 9 := 0;
variable text_location : integer range 0 to 127 := 0;

begin
    if ( rising_edge( system_clock )) then

        if ( state = 0 ) then
            
            text_length := 6;
            text_location := 40;
            
            if (( replay_video = '1' ) and ( EnableWrite = '0' )) then
                text_pointer := 6;
            else
                if ( EnableWrite = '1' ) then
                    text_pointer := 0;
                else
                    text_pointer := 78;
                end if;
            end if;
            state := 10;
            next_state := 1;

        elsif ( state = 1 ) then
        
            text_length := 8;
            text_location := 56;
            
            if ( video_source_switch = '1' ) then
                text_pointer := 47;
            else
                text_pointer := 55;
            end if;
        
            state := 10;
            next_state := 2;        

        elsif ( state = 2 ) then
        
        
            text_length := 7;
            text_location := 72;
            

            case( stream_select ) is
                      
                when "000" => text_pointer := 12;
                when "001" => text_pointer := 19;
                when "010" => text_pointer := 26;
                when "011" => text_pointer := 33;
                when "100" => text_pointer := 40;
                when "101" => text_pointer := 71;
                when "110" => text_pointer := 12;
                when "111" => text_pointer := 12;
            end case;

            state := 10;
            next_state := 3;

        elsif ( state = 3 ) then
        
            text_length := 4;
            text_location := 108;
            
            if ( camera_refresh_rate = '1' ) then
                text_pointer := 63;
            else
                text_pointer := 67;
            end if;
        
            state := 10;
            next_state := 4;     

        elsif ( state = 4 ) then
            case ( ov7670_drive ) is
                when "00" => oled_buffer(119) <= character'pos('0') - 32;
                when "01" => oled_buffer(119) <= character'pos('1') - 32;
                when "10" => oled_buffer(119) <= character'pos('2') - 32;
                when "11" => oled_buffer(119) <= character'pos('3') - 32;
            end case;
            
            state := 0;        
            
        elsif ( state = 10 ) then
            oled_buffer( text_location ) <= information_text( text_pointer );
            text_location := text_location + 1;
            text_pointer := text_pointer + 1;
             
            text_length := text_length - 1;
            
            if ( text_length = 0 ) then
                state := next_state;
            end if;
            
        end if;


    end if;
end process;



--
-- generate_clock process
--
-- process to create a clock signal to be used for spi data to be transmitted and also to create a 
-- power on reset signal for the system
--

generate_clock : process (
    board_clock,
    system_clock
)

--
-- Delay of 75 for a clock frequency of 667Khz
--
variable delay : integer range 0 to 75 := 0;

--
-- Delay of 10000 for a reset pulse of 100us
--
variable reset_delay : integer range 0 to 10000 := 10000;

begin
    if ( rising_edge( board_clock)) then

--
-- Every 75 clock cycles toggle the system clock
--
        delay := delay + 1;
        if ( delay = 75 ) then
            delay := 0;
            system_clock <= not system_clock;

--
-- While reset_delay is not 0 keep the system under reset condition
--
            if ( reset_delay /= 0 ) then
                reset_delay := reset_delay - 1;
                system_reset <= '1';
            else
                system_reset <= '0';
            end if;

        end if;
    end if;
end process;


--
-- generate_cursor_clock process
--
-- process divides down the system_clock to create a 2Hz clock for the cursor
--
--
generate_cursor_clock : process (
    system_clock,
    cursor_clock
)

variable delay : integer range 0 to 250000 := 0;


begin
    if ( rising_edge( system_clock )) then

--
-- Toggle the cursor_clock every 250000 clock cycles
--
        delay := delay + 1;
        if ( delay = 250000 ) then
            delay := 0;
            cursor_clock <= not cursor_clock;
        end if;
    end if;
end process;


----
--
-- initialize_oled_display process
--
-- On power up transmit the initialization commands. Once complete continuously update the display with the contents
-- of the oled_buffer.
--

initialize_oled_display : process(

    system_clock,       -- clock for state machine
    system_reset,       -- reset the state machine

    spi_tx_done,        -- signal indication spi transmission is complete
    cursor_clock,       -- clock for flashing cursor
    cursor_position,    -- location of cursor on the screen column = (3 downto 0) and row = ( 6 downto 4 )
                        -- location column = 0 and row = 0 is the upper left hand corner of the display
    cursor_enabled
)

--
-- Current state the process is in
--

variable state : integer range 0 to 11 := 0;

--
-- Pointer to the current command to be transmitted
--

variable index : integer range 0 to OLED_COMMAND_INIT_SIZE;

--
-- The page and column number of the character being transmitted
--

variable column_number : unsigned( 9 downto 0 );

--
-- The character to transmit
--

variable char : std_logic_vector( 39 downto 0 );

--
-- The position of the character in character_generator table
--

variable char_pos : integer range 0 to 127;


--type graphics_row_type is std_logic_vector( 0 to 1023 );
variable graphics_row : std_logic_vector( 0 to 1023 );

begin
    if ( rising_edge( system_clock )) then

--
-- Reset state. Hold spi_tx_start to '0' while in reset
--
        if ( system_reset = '1' ) then
            spi_tx_start <= '0';
            state := 0;
        end if;

--
-- States 0, 1 and 2 transmit OLED initialization commands
--

--
-- State 0 clear the index pointer and advance to state 1 if not in reset
--
        if ( state = 0 ) then
            index := 0;
            if ( system_reset = '0' ) then
                state := 1;
            end if;

--
-- State 1 get the current OLED command from memory and start a transmission
--

        elsif ( state = 1 ) then
                spi_tx_data <= oled_init_commands( index );
                spi_tx_start <= '1';
                state := 2;

--
-- State 2. Wait for the transmission to complete. When complete increment the index pointer and test for end of list. 
--
        elsif ( state = 2 ) then
            if ( spi_tx_done = '1' ) then
                spi_tx_start <= '0';
                index := index + 1;
                if ( index = OLED_COMMAND_INIT_SIZE ) then
                
--
-- When initialization finished set the column_number to the first column
--                
                
                    state := 3;
                    column_number := to_unsigned( 0, 10 );
                else
                    state := 1;

                end if;
            end if;

--
-- States 3 to 9 transmit the screen buffer to the display
--

--
-- State 3 select command mode for the display and write the current page ( row ) into the lower nibble
-- of the SET_PAGE_START_ADDRESS command
--

        elsif ( state = 3 ) then
            dc <= '0';
            oled_write_screen_commands(0)( 2 downto 0 ) <= std_logic_vector( column_number( 9 downto 7 ));
            index := 0;
            state := 4;
            graphics_row := oled_graphics_buffer( to_integer( unsigned( std_logic_vector( column_number( 9 downto 7 )))));

--
-- State 4 Get the current command form memory and transmit it
--

        elsif ( state = 4 ) then
            spi_tx_data <= oled_write_screen_commands( index );
            spi_tx_start <= '1';
            state := 5;

--
-- State 5 Wait for transmission complete and advance
--

        elsif ( state = 5  ) then
            if ( spi_tx_done = '1' ) then
                spi_tx_start <= '0';
                index := index + 1;

--
-- Test for end of list
--
                if ( index = OLED_WRITE_SCREEN_SIZE ) then
                    state := 6;

                else
                    state := 4;
                end if;
            end if;

--
-- State 6 Get the current character to be displayed
--
        elsif ( state = 6 ) then
            dc <= '1';
            if ( text_or_graphics_mode = '1' ) then
                state := 10;
            else
            
                state := 7;
    
--
-- Test to see if the cursor is over the current character and that the cursor is illuminated
--
    
                if (( cursor_position = column_number( 9 downto 3 )) and ( cursor_clock = '1' ) and ( cursor_enabled = '1' )) then
                    char := ( others => '1' );
                else
    
--
-- Get the current character from the oled_buffer
--
    
                    char_pos := oled_buffer( to_integer( column_number( 9 downto 3 )));
                    char := characters( char_pos );
                end if;
            end if;
--
-- State 7 Extract the top git bit for the current column and transmit then shift the data for the next column. 
-- The last three column will be all '0'
--

        elsif ( state = 7 ) then

            spi_tx_data <= char( 39 downto 32 );
            char := char( 31 downto 0 ) & "00000000";

            spi_tx_start <= '1';
            state := 8;

--
-- State 8 Wait for transmission complete then advance to the next column.
--

        elsif ( state = 8 ) then
            if ( spi_tx_done = '1' ) then
                spi_tx_start <= '0';
                column_number := column_number + 1;
--
-- Test for last column in character
--

                if ( column_number( 2 downto 0 ) = 0 ) then

--
-- Test for end of screen and switch to state 9
--

                    if ( column_number = 0 ) then
                        state := 9;

--
-- Test for end of page ( row ) and switch to state 3 to set a new start page address
--

                    elsif ( column_number( 6 downto 0 ) = 0 ) then
                        state := 3;
                    else

--
-- Switch to state 6 to get the next character in the page ( row )
--

                        state := 6;
                    end if;
                else

--
-- Continue with the current character
--

                    state := 7;

                end if;
            end if;


--
-- End of current screen so reset the column_number start the next screen update
--

        elsif ( state = 9  ) then
            column_number := to_unsigned( 0, 10 );
            state := 3;

        elsif ( state = 10 ) then

            spi_tx_data <= graphics_row( 0 to 7 );
            graphics_row := graphics_row( 8 to 1023 ) & "00000000";

            spi_tx_start <= '1';
            state := 11;

--
-- State 8 Wait for transmission complete then advance to the next column.
--

        elsif ( state = 11 ) then
            if ( spi_tx_done = '1' ) then
                spi_tx_start <= '0';
                column_number := column_number + 1;
--
-- Test for last column in character
--

                if ( column_number = 0 ) then
                    state := 9;
                elsif ( column_number( 6 downto 0 ) = 0 ) then
                    state := 3;
                else
                    state := 10;
                end if;
            end if;
        end if;
    end if;
end process;


----
--
-- oled_tx process
--
-- process to transmit serial data to an OLED display in the order of most significant bit first. Transmission starts when
-- the spi_tx_start signal is at a logic '1'. ON completion spi_tx_done is set to a logic '1'.It is cleared when spi_tx_start
-- returns to a logic '0'.
--
--

oled_tx : process (
    system_clock,      -- clock for state machine
    system_reset,      -- reset the state machine
    spi_tx_data,       -- data to transmit
    spi_tx_start,      -- start signal
    dc                 -- data/command signal ( data = '1', command = '0' )

)

--
-- Current state the process is in
--

variable state : integer range 0 to 3 := 0;

--
-- Number of bits left to transmit
--

variable bit_count : integer range 0 to 8;

--
-- Data to transmit ( most significant bit first )
--

variable tx_data : std_logic_vector( 7 downto 0 );

--
-- Start up delay after a system reset
--

variable startup_delay : integer range 0 to 10;

begin
    if ( rising_edge( system_clock )) then

--
-- Reset state. Hold the display in reset with the chip select high and spi_tx_done low. Set a 10 clock cycle startup delay
--

        if ( system_reset = '1' ) then
            startup_delay := 10;
            state := 0;
            oled_cs <= '1';
            oled_reset <= '0';
            spi_tx_done <= '0';
         end if;

--
-- State 0
--
-- Wait for start of transmission signal
--
        if ( state = 0 ) then
            if ( startup_delay = 0 ) then
                if ( spi_tx_start = '1' ) then

--
-- specify if this is a data or command transmission, enable the chip select,
-- transfer the data to a local shift register and set the bit count
--
                    state := 1;
                    oled_dc <= dc;
                    oled_cs <= '0';
                    bit_count := 8;
                    tx_data := spi_tx_data;
                else

--
-- Idle state. Display disabled and reset spi_tx_done and set reset.
--
                    oled_cs <= '1';
                    spi_tx_done <= '0';
                    oled_reset <= '1';
                end if;
            else

--
-- Wait 10 clock cycles for display to come out of reset
--
                oled_reset <= '1';
                startup_delay := startup_delay - 1;
            end if;

--
-- State 1
--
-- Transmit data in MSB order
--
        elsif ( state = 1 ) then
            oled_sda <= tx_data(7);
            tx_data := tx_data( 6 downto 0 ) & "0";

--
-- Set OLED clock input
--
            oled_sck <= '0';
            state := 2;

--
-- State 2
--
-- Latch the data bit into the OLED display on the rising edge
--

        elsif ( state = 2 ) then
            oled_sck <= '1';

--
-- Test for end of byte transmission and repeat state 1 if not true
--
            bit_count := bit_count - 1;
            if ( bit_count /= 0 ) then
                state := 1;
            else
                state := 3;
            end if;

--
-- State 3
--
-- Disable chips select. Set clock signal to '0' and set spi_tx_done to '1', indicating transmission is complete
--

        elsif ( state = 3 ) then

            oled_cs <= '1';
            oled_sck <= '0';
            spi_tx_done <= '1';

--
-- Wait for the invoking process to acknowledge completion by setting spi_tx_start to a '0'.
--
            if ( spi_tx_start = '0' ) then

--
-- Return to state 0 on acknowledgement
--
                state := 0;
                spi_tx_done <= '0';
            end if;
        else

--
-- Test for invalid states
--
            state := 0;
        end if;
    end if;

end process;

end Behavioral;
