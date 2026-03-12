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


entity histogram is
    generic (
        origin_x : UNSIGNED( 10 downto 0 );
        origin_y : UNSIGNED( 9 downto 0 );
        color : STD_LOGIC_VECTOR( 11 downto 0 )
    );
    Port (
        video_clock : in STD_LOGIC;
        v_sync : in STD_LOGIC;
        h_dot : in UNSIGNED( 10 downto 0 );
        v_line : in UNSIGNED( 9 downto 0 );
        bin : in UNSIGNED( 3 downto 0 );
        visible_frame : in STD_LOGIC;
    
        active : out STD_LOGIC;
        pixel_color : out STD_LOGIC_VECTOR( 11 downto 0 )
    );
end histogram;


architecture Behavioral of histogram is

type data_t is array( 0 to 15 ) of UNSIGNED( 6 downto 0 );
type count_t is array( 0 to 15 ) of integer range 0 to 3840;

constant PIXEL_BLACK : STD_LOGIC_VECTOR( 11 downto 0 ) := "000000000000";
constant PIXEL_WHITE : STD_LOGIC_VECTOR( 11 downto 0 ) := "111111111111";


signal offset_y : unsigned ( 9 downto 0 );
signal offset_x : unsigned ( 10 downto 0 );
signal result : data_t := ( others=> to_unsigned( 0, 7 ));

begin


update_bin : process( video_clock, v_sync, bin )

variable v_sync_previous : STD_LOGIC := '1';
variable count : count_t := ( others => 0 );
variable data : data_t := ( others => TO_UNSIGNED( 0, 7 ));

begin 
    if ( falling_edge( video_clock )) then
        if ( v_sync_previous /= v_sync ) then
            v_sync_previous := v_sync;
--
-- Test for falling edge of v sync
--            
            if ( v_sync_previous = '0' ) then
                
 --
 -- Round up the results
 --
                
                for loop_count in 0 to 15 loop
                    result( loop_count ) <= data( loop_count )( 6 downto 0 ) + 1;
                end loop;
            end if;

--
-- Test for rising edge of v sync
--
            if ( v_sync_previous = '1' ) then

                data := ( others => TO_UNSIGNED( 0, 7 ));
                count := ( others => 0 );
            end if;
        end if;

        if ( visible_frame = '1' ) then
            count( TO_INTEGER( bin )) := count( TO_INTEGER( bin )) + 1;
            
            if ( count( TO_INTEGER( bin )) = 3840 ) then
            
                count( TO_INTEGER( bin )) := 0;
                data( TO_INTEGER( bin )) := data( TO_INTEGER( bin )) + 1;
            end if;        
        end if;
    end if;
end process;


offset_y <= v_line - origin_y;
offset_x <= h_dot - origin_x;

                
process( h_dot, v_line, offset_y, offset_x, video_clock, result )

variable a : unsigned( 9 downto 0 ); --  := to_unsigned( 0, 10 )

begin
    

    --if ( rising_edge( video_clock )) then
    
        if (( v_line >= origin_y ) and ( v_line < ( origin_y + 27 )) and ( h_dot >= origin_x ) and ( h_dot < ( origin_x + 70 ))) then
    
--
-- Default to black background 
--    
            active <= '1';
            pixel_color <= PIXEL_BLACK;
        
--
-- Draw white bar with markers for each bin
--        
            if (( offset_y >= 24 ) and ( offset_y < 26 ) and ( offset_x >= 2 ) and ( offset_x < ( 64 + 4 ))) then
                if (( offset_y = 24 ) and ( offset_x(1) = '0' )) then
                    pixel_color <= color;
                else
                    pixel_color <= PIXEL_WHITE;
                end if;
            end if;
            
--
-- Display the totals for each bin as a bar graph with a range of 0 to 20
--           
            if (( offset_y >= 4 ) and ( offset_y < 24 ) and ( offset_x >= 4 ) and ( offset_x < ( 64 + 4 ))) then
                if ( offset_x( 1 ) = '0' ) then
                   
                    a := "0000" & result( to_integer( offset_x( 9 downto 2 )) - 1  )( 6 downto 1 );
                    if ( a > 24 ) then
                        if (( offset_y = 4 ) or ( offset_y = 5 )) then
                            pixel_color <= PIXEL_WHITE;
                        else
                            pixel_color <= color;
                        end if;
                    elsif (  offset_y >=  ( 24 -  a  )) then 
                        pixel_color <= color;
                    end if;
                end if;
            end if;

        else
            pixel_color <= PIXEL_BLACK;
            active <= '0';
        end if;
    
    --end if;
end process;

end behavioral;
