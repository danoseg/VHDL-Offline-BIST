library ieee;
use ieee.std_logic_1164.all;

ENTITY mux4to1 IS
	PORT (X1,X2,X3,X4  :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			s				 :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			f				 :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
END mux4to1;

ARCHITECTURE Behavior OF mux4to1 IS
BEGIN
	WITH s SELECT
		f <= X1 WHEN "00",
			  X2 WHEN "01",
			  X3 WHEN "10",
			  X4 WHEN others;
END Behavior;
