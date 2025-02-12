library ieee;
use ieee.std_logic_1164.all;

ENTITY cpu_test_sim IS
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
END cpu_test_sim;

ARCHITECTURE behavior OF cpu_test_sim IS
	COMPONENT blk_mem_gen_0
        PORT (
            clka : IN STD_LOGIC;
            wea : IN STD_LOGIC_VECTOR(0 DOWNTO 0);
            addra : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            dina : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
            douta : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
 END COMPONENT;
 
	COMPONENT cpu1
		PORT(
			clk 		: in std_logic;
			mem_clk 	: in std_logic;
			rst 		: in std_logic;
			test_mode   : in std_logic;
			dataIn 	: in std_logic_vector(7 downto 0); 
			dataOut 	: out std_logic_vector(7 downto 0);
			addrOut 	: out std_logic_vector(7 downto 0);
			wEn : OUT STD_LOGIC_VECTOR(0 DOWNTO 0);
			dOutA, dOutB : out std_logic_vector(7 downto 0);
			dOutC, dOutZ : out std_logic;
			dOutIR : out std_logic_vector(7 downto 0);
			dOutPC : out std_logic_vector(7 downto 0);
			outT : out std_logic_vector(2 downto 0);
			wen_mem, en_mem : out std_logic;
			alu_result : inout STD_LOGIC_VECTOR(4 DOWNTO 0);
			signature_cpu : out std_logic_vector(4 downto 0);
			pass, fail : out std_logic);
	END COMPONENT;
	
	signal cpu_to_mem: std_logic_vector(7 downto 0);
	signal mem_to_cpu: std_logic_vector(7 downto 0);
	signal add_from_cpu: std_logic_vector(7 downto 0);
	signal wen_from_cpu: std_logic_VECTOR(0 DOWNTO 0);

BEGIN
 -- Component instantiations.
	main_memory : blk_mem_gen_0
		PORT MAP(
		     clka => memClk,
			 addra => add_from_cpu(7 downto 0),
			 wea => wen_from_cpu, 
			 dina => cpu_to_mem,			 
			 douta => mem_to_cpu
		 );
	main_processor : cpu1
		PORT MAP(
		 clk => cpuClk,
		 mem_clk => memClk,
		 rst => rst,
		 test_mode => test_mode,
		 dataIn => mem_to_cpu,
		 dataOut => cpu_to_mem,
		 addrOut => add_from_cpu,
		 wEn => wen_from_cpu,
		 dOutA => outA,
		 dOutB => outB,
		 dOutC => outC,
		 dOutZ => outZ,
		 dOutIR => outIR,
		 dOutPC => outPC,
		 outT => T_Info,
		 wen_mem => wen_mem,
		 en_mem => en_mem,
		 alu_result => alu_out,
		 signature_cpu => signature_out,
		 pass => pass,
		 fail => fail
		 );
	
	addrOut <= add_from_cpu;
	wEn <= wen_from_cpu;
	memDataOut <= mem_to_cpu;
	memDataIn <= cpu_to_mem;
END behavior;