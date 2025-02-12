library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;

entity add is
port(A  :  IN STD_LOGIC_VECTOR(7 downto 0);
	  B  :  OUT STD_LOGIC_VECTOR(7 downto 0));
end add;
	  
architecture behavior of add is
begin
	B <= A + 1;
end behavior;