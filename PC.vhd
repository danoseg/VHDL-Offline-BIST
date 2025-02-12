library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_unsigned.all;
use ieee.std_logic_arith.all;


entity PC is
port(clr, clk, ld, inc   :  IN STD_LOGIC;
		d						 :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		q						 :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
end PC;

architecture behavior of PC is
	component add
		port(A  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			  B  : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	
	component mux2to1
		port(s	    : IN STD_LOGIC;
			  w0, w1  : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			  f		 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	
	component register8
		port(d				 : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			  ld, clr, clk  : IN STD_LOGIC;
			  q				 : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;

	signal add_out	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal mux_out : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal q_out   : STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	begin
		add0: add port map(q_out, add_out);
		mux0: mux2to1 port map(inc, d, add_out, mux_out);
		reg0: register8 port map(mux_out, ld, clr, clk, q_out);
		q <= q_out;
end behavior;