library ieee;

use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity register8 is
	port(
		d						: IN STD_LOGIC_VECTOR(7 downto 0);
		ld, clr, clk		: IN STD_LOGIC;
		Q						: OUT STD_LOGIC_VECTOR(7 downto 0));
end register8;

architecture behavior of register8 is
	begin
		process (ld,clr,clk)
		begin
			if clr = '1' then
				Q <= (others => '0');
			elsif ((clk'event and clk = '1') and (ld = '1')) then
				Q <= d;
			end if;
		end process;
end behavior;