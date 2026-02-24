library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity booth_multiplier is
    port( a: in std_logic_vector(7 downto 0); -- multiplicand
          b: in std_logic_vector(7 downto 0); -- multiplier
          p: out std_logic_vector(15 downto 0)); -- product
end booth_multiplier;

architecture behavioural of booth_multiplier is
    type partial_product_array is array (0 to 7) of signed(15 downto 0);
begin 
process(a, b)
    variable sum : signed(15 downto 0);
    variable Bn  : partial_product_array;
begin
    if b(0) = '1' then
    Bn(0) := shift_left(resize(-signed(a), 16), 0);
    else
        Bn(0) := (others => '0');
    end if;
    for i in 1 to 7 loop
        if b(i) = '0' and b(i-1) = '1' then
            Bn(i) := shift_left(resize(signed(a), 16), i);
        elsif b(i) = '1' and  b(i-1) = '0' then
            Bn(i) := shift_left(resize(-signed(a), 16), i);
        else
            Bn(i) := (others => '0');
        end if;
    end loop;
    sum := (others => '0');
    for i in 0 to 7 loop
        sum := sum + Bn(i);
    end loop;
    p <= std_logic_vector(sum);

end process;
end behavioural;
