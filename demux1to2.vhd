library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity demux1to2 is
    Port (
        w : in STD_LOGIC_VECTOR(4 DOWNTO 0);    -- Input data
        s     : in STD_LOGIC;    -- Select signal
        f0    : out STD_LOGIC_VECTOR(4 DOWNTO 0);   -- Output 0
        f1    : out STD_LOGIC_VECTOR(4 DOWNTO 0)    -- Output 1
    );
end demux1to2;

architecture Behavioral of demux1to2 is
begin
    -- Output selection based on 'sel'
    with s select
        f0 <= w when '0',
        (others => '0')      when others; -- Defaults to '0'
                
    with s select
        f1 <= (others => '0')      when '0',
        w when others; -- When '1'
end Behavioral;