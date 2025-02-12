library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

-- Define the signature_analyzer entity
entity signature_analyzer is
    port (
        clk       : in std_logic;                       -- Clock signal
        reset     : in std_logic;                       -- Synchronous reset signal
        enable    : in std_logic;                       -- Enable signal
        data_in   : in std_logic_vector(4 downto 0);   -- 16-bit data input
        signature : out std_logic_vector(4 downto 0)   -- 16-bit signature output
    );
end signature_analyzer;

architecture Structural of signature_analyzer is
    -- Internal signals (Registers)
    signal sr : std_logic_vector(4 downto 0) := (others => '0'); -- Internal SR signal
    signal carry : std_logic; -- Carry signal
 
    -- Signals for interconnections
    signal sum_signals : std_logic_vector(4 downto 0);
    signal carry_signals : std_logic_vector(4 downto 0);
    
    component full_add is
        port (
            A : in std_logic;
            B : in std_logic;
            Cin : in std_logic;
            Sum : out std_logic;
            Cout : out std_logic
        );
    end component;
    
begin
    -- Instantiate the first Full Adder for sr(0)
    FA0: full_add
        port map (
            A => sr(4),
            B => data_in(0),
            Cin => carry,
            Sum => sum_signals(0),
            Cout => carry_signals(0)
        );

    -- Instantiate Full Adders for sr(1) to sr(15)
   gen_full_adders: for i in 1 to 4 generate
        FA1: full_add
            port map (
                A => sr(i-1),
                B => data_in(i),
                Cin => carry_signals(i-1),
                Sum => sum_signals(i),
                Cout => carry_signals(i)
            );
    end generate;

-- Process to update the shift register on the rising edge of the clock
    process(clk)
    begin
        if rising_edge(clk) then
            if reset = '1' then
                sr <= (others => '0');  -- Reset shift register
            elsif enable = '1' then
                sr <= sum_signals;      -- Update the shift register with the sums
            end if;
        end if;
    end process;

    -- Process to update the carry signal on the falling edge of the clock
    process(clk)
    begin
        if falling_edge(clk) then
            if reset = '1' then
                carry <= '0';           -- Reset carry signal
            elsif enable = '1' then
                carry <= carry_signals(4);  -- Capture carry-out from adder 2
            end if;
        end if;
    end process;

    signature <= sr;  -- Output the current signature
end Structural;