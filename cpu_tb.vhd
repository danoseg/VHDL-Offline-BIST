
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity cpu_tb is
end cpu_tb;

architecture Behavioral of cpu_tb is
    component cpu_test_sim IS
	PORT(
		cpuClk : in std_logic;
		memClk : in std_logic;
		rst : in std_logic;
		test_mode : in std_logic;
		-- Debug data.
		outA, outB : out std_logic_vector(7 downto 0);
		outC, outZ : out std_logic;
		outIR : out std_logic_vector(7 downto 0);
		outPC : out std_logic_vector(7 downto 0);
		-- Processor-Inst Memory Interface.
		addrOut : out std_logic_vector(7 downto 0);
		wEn : out std_logic_VECTOR(0 DOWNTO 0);
		memDataOut : out std_logic_vector(7 downto 0);
		memDataIn : out std_logic_vector(7 downto 0);
		-- Processor State
		T_Info : out std_logic_vector(2 downto 0);
		--data Memory Interface
		wen_mem, en_mem : out std_logic;
		alu_out : inout std_logic_Vector(4 downto 0);
		signature_out : out std_logic_vector(4 downto 0);
		pass, fail : out std_logic);
END component;
    
-- Clock period definitions
constant clk_period : time := 40 ns;
constant mclk_period : time := 20 ns;

--Input Signals
signal clock : std_logic;
signal mclock : std_logic;
signal reset : std_logic;
signal test_mode : std_logic;

--Ouput Signals
signal outA, outB : std_logic_vector(7 downto 0);
signal outC, outZ : std_logic;
signal outIR : std_logic_vector(7 downto 0);
signal outPC : std_logic_vector(7 downto 0);

signal addrOut : std_logic_vector(7 downto 0);
signal wEn : std_logic_vector(0 downto 0);
signal memDataOut : std_logic_vector(7 downto 0);
signal memDataIn: std_logic_vector(7 downto 0);

signal T_Info : std_logic_vector(2 downto 0);
signal wen_mem, en_mem : std_logic;

signal alu_result : std_logic_vector(4 downto 0);
signal signature : std_logic_vector(4 downto 0);
signal pass, fail : std_logic;


begin

--Instantiate DUT
dut: cpu_test_sim
    port map(
            cpuClk => clock,
            memClk => mclock,
            rst => reset,
            test_mode => test_mode,
            -- Debug data.
            outA => outA,
            outB => outB,
            outC => outC,
            outZ => outZ,
            outIR => outIR,
            outPC => outPC,
            -- Processor-Inst Memory Interface.
            addrOut => addrOut,
            wEn => wEn,
            memDataOut => memDataOut,
            memDataIn => memDataIn,
            -- Processor State
            T_Info => T_Info,
            --data Memory Interface
            wen_mem => wen_mem,
            en_mem => en_mem,
            alu_out => alu_result,
            signature_out => signature,
            pass => pass,
            fail => fail
    );
-- Clock Process
clk_process : process
begin
    clock <= '0';
    wait for clk_period/2;
    clock <= '1';
    wait for clk_period/2;
end process clk_process;

mclk_process : process
begin
    mclock <= '0';
    wait for mclk_period/2;
    mclock <= '1';
    wait for mclk_period/2;

end process mclk_process;

-- Stimulus process
simulation : process
begin
    reset <= '1';
    wait for clk_period;
    reset <= '0';
    test_mode <= '0';
    wait for clk_period;
    wait;
end process simulation;

end Behavioral;
