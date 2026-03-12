----------------------------------------------------------------------------------
--
-- ECE 244 Lab #3 2022
--
-- Button debouncer
--
-- (c)2022 B. Sirna         Dept. of ECE
--                          University of Victoria
--
----------------------------------------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce_clock is
  Port ( 
    	clock_in: in   STD_LOGIC;
    	clock_out : out STD_LOGIC
    );
end debounce_clock;


architecture Behavioral of debounce_clock is


begin

generate_clock : process( clock_in )

variable delay : INTEGER range 0 to 25000 := 0;
variable clock : STD_LOGIC := '0';

begin
    if ( rising_edge( clock_in )) then
        Delay := Delay + 1;
        if ( delay = 25000 ) then
            clock := not clock;
            clock_out <= clock;
        end if;
    end if;
end process;

end behavioral;


library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity debounce_switch is
Port (
    reset : in STD_LOGIC;
    clock : in STD_LOGIC;
    button_in : in STD_LOGIC;
    button_out : out STD_LOGIC
);
end debounce_switch;


architecture Behavioral of debounce_switch is


begin

detection_button : process( reset, clock, button_in )

variable previous_state : STD_LOGIC := '1';
variable bounce_count : INTEGER range 0 to 7 := 0;

begin
    if ( rising_edge( Clock )) then
        if ( reset = '1' ) then
            previous_state := not button_in;
        else
            if ( previous_state /= button_in ) then
                if ( bounce_count /= 7 ) then
                    bounce_count := bounce_count + 1;
                else
                    previous_state := button_in;
                    button_out <= previous_state;
                end if;
            else
                bounce_count := 0;
            end if;
        end if;
    end if;
end process;

end behavioral;
