LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.std_logic_unsigned.all;
use ieee.Std_Logic_Arith.all;
------------------------------------------------------------
entity seven_seg is
	port(
		nibel : in std_logic_vector(3 downto 0);
		----------------------------------------
		LED_out : out std_logic_vector(6 downto 0)
	);
end seven_seg;
--------------------------------------------------------------------
ARCHITECTURE struct OF seven_seg IS
begin
process(nibel)
begin
    case nibel is
    when "0000" => LED_out <= "1000000"; -- "0"     
    when "0001" => LED_out <= "1111001"; -- "1" 
    when "0010" => LED_out <= "0100100"; -- "2" 
    when "0011" => LED_out <= "0110000"; -- "3" 
    when "0100" => LED_out <= "0011001"; -- "4" 
    when "0101" => LED_out <= "0010010"; -- "5" 
    when "0110" => LED_out <= "0000010"; -- "6" 
    when "0111" => LED_out <= "1111000"; -- "7" 
    when "1000" => LED_out <= "0000000"; -- "8"     
    when "1001" => LED_out <= "0011000"; -- "9" 
    when "1010" => LED_out <= "0001000"; -- a
    when "1011" => LED_out <= "0000011"; -- b
    when "1100" => LED_out <= "1000110"; -- C
    when "1101" => LED_out <= "0100001"; -- d
    when "1110" => LED_out <= "0000110"; -- E
    when "1111" => LED_out <= "0001110"; -- F
	when others => LED_out <= "0000000";
    end case;
end process;
end struct;