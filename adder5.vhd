library ieee;
use ieee.std_logic_1164.all;

entity adder5 is
port(
	X,Y		: IN STD_LOGIC_VECTOR(4 downto 0);
    Cin		: IN STD_LOGIC;
	S			: OUT STD_LOGIC_VECTOR(4 downto 0);
	Cout		: OUT STD_LOGIC);
end adder5;
	
architecture Behavior of adder5 is
	component full_add
	port(
		A : in std_logic;
        B : in std_logic;
        Cin : in std_logic;
        Sum : out std_logic;
        Cout : out std_logic);
	end component;
	
	signal C : STD_LOGIC_VECTOR(1 to 4);
begin
	stage0: full_add port map (X(0), Y(0), Cin, S(0), C(1));
	stage1: full_add port map (X(1), Y(1), C(1), S(1), C(2));
	stage2: full_add port map (X(2), Y(2), C(2), S(2), C(3));
	stage3: full_add port map (X(3), Y(3), C(3), S(3), C(4));
	stage4: full_add port map (X(4), Y(4), C(4), S(4), Cout);
end Behavior;