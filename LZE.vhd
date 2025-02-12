library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity LZE is
	port(LZE_in	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  LZE_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END LZE;

ARCHITECTURE Behavior of LZE is
	signal zeros: STD_LOGIC_VECTOR(3 DOWNTO 0) := (others => '0');
	
	begin
		LZE_out <= zeros & LZE_in(3 DOWNTO 0);
end Behavior;