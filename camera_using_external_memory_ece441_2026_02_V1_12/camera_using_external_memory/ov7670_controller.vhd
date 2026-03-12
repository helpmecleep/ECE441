-- Controller for the OV760 camera - transferes registers to the 
-- camera over an I2C like bus

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;


entity ov7670_controller is
  Port ( clk    : in    STD_LOGIC;
    resend : in    STD_LOGIC;
    config_finished : out std_logic;
    sioc  : out   STD_LOGIC;
    siod  : inout STD_LOGIC;
    reset : out   STD_LOGIC;
    pwdn  : out   STD_LOGIC;
    xclk  : out   STD_LOGIC;
    drive : in std_logic_vector( 1 downto 0 );
    refresh_rate : in STD_LOGIC
);
end ov7670_controller;


architecture Behavioral of ov7670_controller is


  COMPONENT ov7670_registers
  PORT(
    clk      : IN std_logic;
    advance  : IN std_logic;          
    resend   : in STD_LOGIC;
    command  : OUT std_logic_vector(15 downto 0);
    finished : OUT std_logic;
    drive : in std_logic_vector( 1 downto 0 )
    );
  END COMPONENT;

  COMPONENT i2c_sender
  PORT(
    clk   : IN std_logic;
    send  : IN std_logic;
    taken : out std_logic;
    id    : IN std_logic_vector(7 downto 0);
    reg   : IN std_logic_vector(7 downto 0);
    value : IN std_logic_vector(7 downto 0);    
    siod  : INOUT std_logic;      
    sioc  : OUT std_logic
    );
  END COMPONENT;
  
  signal clock_6Mhz : std_logic := '0'; 
  signal clock_12Mhz : std_logic := '0';


  signal command  : std_logic_vector(15 downto 0);
  signal finished : std_logic := '0';
  signal taken    : std_logic := '0';
  signal send     : std_logic;
  -- device write ID; see datasheet of camera module;
  constant camera_address : std_logic_vector(7 downto 0) := x"42"; 
  signal i2c_clock : STD_LOGIC := '0'; 
  
begin

  config_finished <= finished;  
  send <= not finished;
 
slow_clock : process( clk, i2c_clock )

variable delay : integer range 0 to 50 := 0;

begin
    if ( rising_edge( clk )) then
        delay := delay + 1;
        if ( delay = 50 ) then
            delay := 0;
            i2c_clock <= not i2c_clock;
        end if;
    end if;
end process;

 
  Inst_i2c_sender: i2c_sender PORT MAP(
    clk   => i2c_clock,
    taken => taken,
    siod  => siod,
    sioc  => sioc,
    send  => send,
    id    => camera_address,
    reg   => command(15 downto 8),
    value => command(7 downto 0)
  );

  reset <= '1'; -- Normal mode
  pwdn  <= '0'; -- Power device up
  clock_12Mhz <= clk;
  xclk  <= clock_6Mhz when ( refresh_rate = '0' ) else clock_12Mhz;
  
  Inst_ov7670_registers: ov7670_registers PORT MAP(
    clk      => i2c_clock,
    advance  => taken,
    command  => command,
    finished => finished,
    resend   => resend,
    drive => drive
  );

process( clock_12mhz, clock_6mhz )
begin
    if rising_edge( clock_12mhz ) then
        clock_6mhz <= not clock_6mhz;
    end if;
end process;

  
end Behavioral;
