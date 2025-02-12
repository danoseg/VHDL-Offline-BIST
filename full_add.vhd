library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Define Full Adder component
entity full_add is
    port (
        A : in std_logic;
        B : in std_logic;
        Cin : in std_logic;
        Sum : out std_logic;
        Cout : out std_logic
    );
end full_add;

architecture Behavioral of full_add is
begin
    Sum <= A xor B xor Cin;
    Cout <= (A and B) or (A and Cin) or (B and Cin);
end Behavioral;