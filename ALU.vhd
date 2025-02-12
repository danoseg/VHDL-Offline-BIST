library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;
use ieee.numeric_std.all;

entity ALU is
port(
	a		: IN STD_LOGIC_VECTOR(4 downto 0);
	b		: IN STD_LOGIC_VECTOR(4 downto 0);
	op			: IN STD_LOGIC;
	result	: OUT STD_LOGIC_VECTOR(4 downto 0);
	zero		: OUT STD_LOGIC;
	Cout		: OUT STD_LOGIC);
end ALU;

Architecture Behavior of ALU is
	component adder5
		port(
			Cin	: IN STD_LOGIC;
			X,Y	: IN STD_LOGIC_VECTOR(4 downto 0);
			S		: OUT STD_LOGIC_VECTOR(4 downto 0);
			Cout	: OUT STD_LOGIC);
	end component;
	
	signal result_s: STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal result_add: STD_LOGIC_VECTOR(4 DOWNTO 0) :=(others => '0');
	signal result_sub: STD_LOGIC_VECTOR(4 DOWNTO 0) :=(others => '0');
	signal cout_s:	STD_LOGIC := '0';
	signal cout_add: STD_LOGIC := '0';
	signal cout_sub: STD_LOGIC := '0';
	signal zero_s:	STD_LOGIC;
	
	begin
		add0: adder5 
		  port map (op,
		            a,
		            b,
		            result_add,
		            cout_add);
		sub0: adder5
		 port map (
		            op,
		            a,
		            not b,
		            result_sub,
		            cout_sub);
		
	process (a, b, op)
	begin
		case(op) is
			when '0' =>
				result_s <= result_add;
				cout_s <= cout_add;
			when '1' =>
				result_s <= result_sub;
				cout_s <= cout_sub;
			when others =>
			    result_s <= b;
			    cout_s <= '0';				
		end case;
		
		case (result_s) is
			when (others => '0') =>
				zero_s <= '1';
			when others =>
				zero_s <= '0';
		end case;
	end process;
	
	result <= result_s;
	cout <= cout_s;
	zero <= zero_s;
end Behavior;