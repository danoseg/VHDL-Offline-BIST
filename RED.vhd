library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity RED is
	port(RED_in	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  RED_out: OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
END RED;

ARCHITECTURE Behavior of RED is
	begin
		RED_out <= RED_in(4 DOWNTO 0);
END Behavior;