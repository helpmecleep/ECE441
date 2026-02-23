library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth_multiplier is
    port( a: in std_logic_vector(7 downto 0); -- multiplicand
          b: in std_logic_vector(7 downto 0); -- multiplier
          p: out std_logic_vector(15 downto 0)); -- product
end booth_multiplier;

architecture behavioural of booth_multiplier is
    signal A, B, Bn: signed(7 downto 0);
    signal P: signed(15 downto 0);

begin 
process(a, b)
begin
    for i in 0 to 7 loop
        elsif B(i) < B(i-1) then
            Bn(i) <= A;
        elsif B(i) > B(i-1) then
            Bn(i) <= -A;
        else
            Bn(i) = (others => '0');
    end loop;
