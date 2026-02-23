library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth_multiplier_tb is
end booth_multiplier_tb;

architecture Simulator of booth_multiplier_tb is
    signal a,b : std_logic_vector(7 downto 0);
    signal p : std_logic_vector(15 downto 0);

begin
    uut: entity work.booth_multiplier
        port map (
            a => a,
            b => b,
            p => p
        );

    process
    begin
        -- Test case 1: 3 * 7 = 21
        a <= "00000011"; -- 3
        b <= "00000111"; -- 7
        wait for 10 ns;

        -- Test case 2: 5 * -2 = -10
        a <= "00000101"; -- 5
        b <= "11111110"; -- -2 (two's complement)
        wait for 10 ns;

        -- Test case 3: -2 * 5 = -10
        a <= "11111101"; -- -2 (two's complement)
        b <= "00000101"; -- 5
        wait for 10 ns;

        -- Test case 4: -1 * -1 = 1
        a <= "11111111"; -- -1 (two's complement)
        b <= "11111111"; -- -1 (two's complement)
        wait for 10 ns;
        
        -- Test case 5: 0 * 0 = 0
        a <= "00000000"; -- 0
        b <= "00000000"; -- 0
        wait for 10 ns;

        wait;
    end process;
end Simulator;
