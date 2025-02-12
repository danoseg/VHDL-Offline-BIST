library ieee;
use ieee.std_logic_1164.all;

entity comparator is 
	port(
	    clk : in std_logic;
		test_signal  :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		pass :  OUT STD_LOGIC;
	    fail :  OUT STD_LOGIC);
	end comparator;
	
architecture comp of comparator is 
signal reference_signal  :  STD_LOGIC_VECTOR(4 DOWNTO 0):= "00110";
	begin
		process(clk, reference_signal, test_signal)
		begin	
			pass <= '0';
			fail <= '0';
			
		if(reference_signal = test_signal) then 
			pass <= '1';
		else
			fail <= '1';
		end if;
	end process;
end comp;