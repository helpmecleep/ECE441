library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity led_display is
  Port ( 
    Clock : in   STD_LOGIC;
    Values : in   STD_LOGIC_VECTOR( 31 downto 0 );
    Segments : out STD_LOGIC_VECTOR( 7 downto 0 );
    Digits : out STD_LOGIC_VECTOR( 7 downto 0 )
    );
end led_display;


architecture Behavioral of led_display is

signal Clock_1KHz : STD_LOGIC;
signal Value : STD_LOGIC_VECTOR( 3 downto 0 );
signal Digit : unsigned( 2 downto 0 ) := to_unsigned( 0, 3 );

begin

refresh_rate : process( Clock, Clock_1Khz )

variable Delay : integer range 0 to 100000 := 0;

begin
	if ( rising_edge( Clock )) then
		Delay := Delay + 1;
		if ( Delay = 100000 ) then
			Clock_1Khz <= not Clock_1Khz;
			Delay := 0;
		end if;
	end if;
end process;


process( Clock_1Khz, Digit )
begin
	if ( rising_edge( Clock_1Khz )) then
        Digit <= Digit + 1;
    end if;
end process;


multiplex_display : process( Digit, Values )

begin


	case( Digit ) is
		when "000" =>
			Digits <= not "00000001";
			Value <= Values( 3 downto 0 );

		when "001" =>
			Digits <= not "00000010";		
			Value <= Values( 7 downto 4 );

		when "010" =>
			Digits <= not "00000100";		
			Value <= Values( 11 downto 8 );

		when "011" =>
			Digits <= not "00001000";		
			Value <= Values( 15 downto 12 );

		when "100" =>
			Digits <= not "00010000";		
			Value <= Values( 19 downto 16 );

		when "101" =>
			Digits <= not "00100000";		
			Value <= Values( 23 downto 20 );

		when "110" =>
			Digits <= not "01000000";		
			Value <= Values( 27 downto 24 );

		when "111" =>
			Digits <= not "10000000";		
			Value <= Values( 31 downto 28 );
	end case;

end process;


segments_display : process( Value ) 
begin
	case( Value ) is

		when "0000" =>
			Segments <= not "00111111"; -- 0
		when "0001" =>
			Segments <= not "00000110"; -- 1
		when "0010" =>
			Segments <= not "01011011"; -- 2
		when "0011" =>
			Segments <= not "01001111"; -- 3
		when "0100" =>
			Segments <= not "01100110"; -- 4
		when "0101" =>
			Segments <= not "01101101"; -- 5
		when "0110" =>
			Segments <= not "01111101"; -- 6
		when "0111" =>
			Segments <= not "00000111"; -- 7
		when "1000" =>
			Segments <= not "01111111"; -- 8
		when "1001" =>
			Segments <= not "01101111"; -- 9
		when "1010" =>
			Segments <= not "01110111"; -- A
		when "1011" =>
			Segments <= not "01111100"; -- B
		when "1100" =>
			Segments <= not "00111001"; -- C
		when "1101" =>
			Segments <= not "01011110"; -- D
		when "1110" =>
			Segments <= not "01111001"; -- E
		when "1111" =>
			Segments <= not "01110001"; -- F
	end case;

end process;

end behavioral;
