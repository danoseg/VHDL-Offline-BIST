library ieee;
use ieee.std_logic_1164.all;
use ieee.std_logic_arith.all;
use ieee.std_logic_unsigned.all;

entity data_path is
	port(
		Clk, mClk : IN STD_LOGIC; -- clock Signal
		
		--Memory Signals
		WEN, EN : IN STD_LOGIC;
		
		-- Register Control Signals (CLR and LD).
		Clr_A , Ld_A : IN STD_LOGIC;
		Clr_B , Ld_B : IN STD_LOGIC;
		Clr_C , Ld_C : IN STD_LOGIC;
		Clr_Z , Ld_Z : IN STD_LOGIC;
		Clr_PC , Ld_PC : IN STD_LOGIC;
		Clr_IR , Ld_IR : IN STD_LOGIC;
		Clr_SA, Ld_SA : IN STD_LOGIC;
		
		-- Register outputs (Some needed to feed back to control unit. Others pulled out for testing.
		Out_A : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Out_B : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Out_C : OUT STD_LOGIC;
		Out_Z : OUT STD_LOGIC;
		Out_PC : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		Out_IR : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		
		-- Special inputs to PC.
		Inc_PC : IN STD_LOGIC;
		
		-- Address and Data Bus signals for debugging.
		ADDR_OUT : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		DATA_IN : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		DATA_BUS, MEM_OUT, MEM_IN : OUT STD_LOGIC_VECTOR(7 DOWNTO 0);
		MEM_ADDR : OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		-- Various MUX controls.
		DATA_Mux: IN STD_LOGIC_VECTOR(1 DOWNTO 0);
		REG_Mux : IN STD_LOGIC;
		A_MUX, B_MUX : IN STD_LOGIC;
		test_mux : IN STD_LOGIC;
		
		-- ALU Operations.
		ALU_Op : IN STD_LOGIC;
		ALU_out	: inout STD_LOGIC_VECTOR(4 DOWNTO 0);
		
		--Testing Signals
		signature: OUT STD_LOGIC_VECTOR(4 DOWNTO 0);
		pass_signal: OUT STD_LOGIC;
		fail_signal: OUT STD_LOGIC);
end data_path;

architecture Behavior of data_path is
	--Data Memory module
	component data_mem is
		port(
			clk	: IN STD_LOGIC;
			addr	: IN STD_LOGIC_VECTOR(4 DOWNTO 0);
			data_in : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			wen	: IN STD_LOGIC;
			en		: IN STD_LOGIC;
			data_out : OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	--Register32
	component register8 is
		port(
			d						: IN STD_LOGIC_VECTOR(7 downto 0);
			ld, clr, clk		: IN STD_LOGIC;
			Q						: OUT STD_LOGIC_VECTOR(7 downto 0));
		end component;
	--Program Counter
	component PC is
		port(
			clr, clk, ld, inc   :  IN STD_LOGIC;
			d						 :  IN STD_LOGIC_VECTOR(7 DOWNTO 0);
			q						 :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	--LZE
	component LZE is
		port(
			LZE_in	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		   LZE_out: OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	--RED
	component RED is
		port(
		  RED_in	: IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		  RED_out: OUT STD_LOGIC_VECTOR(4 DOWNTO 0));
	end component;
	--Mux2to1
	component mux2to1 is
	port( w0,w1		    :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			s				 :  IN  STD_LOGIC;
			f				 :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	--Mux4to1
	component mux4to1 is
	port( X1,X2,X3,X4	    :  IN  STD_LOGIC_VECTOR(7 DOWNTO 0);
			s				 :  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
			f				 :  OUT STD_LOGIC_VECTOR(7 DOWNTO 0));
	end component;
	--ALU
	component ALU is
		port(
			a,b		: IN STD_LOGIC_VECTOR(4 downto 0);
			op			: IN STD_LOGIC;
			result	: OUT STD_LOGIC_VECTOR(4 downto 0);
			zero		: OUT STD_LOGIC;
			Cout		: OUT STD_LOGIC);
	end component;
	
	component demux1to2 is
	   port(w				 :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
            s				 :  IN  STD_LOGIC;
	        f0, f1		    :  OUT  STD_LOGIC_VECTOR(4 DOWNTO 0));	   
	   end component;
	
	component signature_analyzer is
    port (
      clk       : in std_logic;                       -- Clock signal
      reset     : in std_logic;                       -- Synchronous reset signal
      enable    : in std_logic;                      -- Enable signal
      data_in   : in std_logic_vector(4 downto 0);   -- 16-bit data input
      signature : out std_logic_vector(4 downto 0)   -- 16-bit signature output
    );
    end component;
    
    component comparator is
    port(
        clk : in std_logic;
		test_signal  :  IN STD_LOGIC_VECTOR(4 DOWNTO 0);
		pass :  OUT STD_LOGIC;
	    fail :  OUT STD_LOGIC
    );
    end component;
   
	--Signal Instantiations
	signal IR_OUT			: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal data_bus_s		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal LZE_out_PC		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal LZE_out_A_Mux : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal LZE_out_B_Mux : STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal RED_out_Data_Mem : STD_LOGIC_VECTOR(4 DOWNTO 0);
	signal A_Mux_out 		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal B_Mux_out		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal reg_A_out 		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal reg_B_out		: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal reg_Mux_out	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	signal data_mem_out	: STD_LOGIC_VECTOR(7 DOWNTO 0);
	
	signal zero_flag		: STD_LOGIC;
	signal carry_flag		: STD_LOGIC;
	
	signal demux_out_data :  std_logic_Vector(4 downto 0);
	signal demux_out_SA : std_logic_Vector(4 downto 0);
	signal out_pc_sig		: STD_LOGIC_VECTOR(7 DOWNTO 0);
    signal signature_out    : STD_LOGIC_VECTOR(4 DOWNTO 0);
	
	begin
	IR: register8 port map(
			data_bus_s,
			Ld_IR,
			Clr_IR,
			Clk,
			IR_OUT);
		
	LZE_PC: LZE port map(
			IR_OUT,
			LZE_out_PC);
			
	PC0: PC port map(
			Clr_PC,
			Clk,
			Ld_PC,
			Inc_PC,
			LZE_out_PC,
			out_pc_sig);
			
	LZE_A_Mux: LZE port map(
			IR_OUT,
			LZE_out_A_Mux);
			
	A_Mux0: mux2to1 port map(
			data_bus_s,
			LZE_out_A_Mux,
			A_MUX,
			A_Mux_out);
			
	Reg_A: register8 port map(
			A_Mux_out,
			Ld_A,
			Clr_A,
			Clk,
			reg_A_out);
			
	LZE_B_Mux: LZE port map(
			IR_OUT,
			LZE_out_B_Mux);
			
	B_Mux0: mux2to1 port map(
			data_bus_s,
			LZE_out_B_Mux,
			B_MUX,
			B_Mux_out);
			
	Reg_B: register8 port map(
			B_Mux_out,
			Ld_B,
			Clr_B,
			Clk,
			reg_B_out);
			
	Reg_Mux0: mux2to1 port map(
			reg_A_out,
			reg_B_out,
			Reg_Mux,
			reg_Mux_out);
			
	RED_Data_Mem: RED port map(
			IR_OUT,
			RED_out_Data_Mem);
			
	Data_Mem0: data_mem port map(
			mClk,
			RED_out_Data_Mem,
			reg_Mux_out,
			WEN,
			EN,
			data_mem_out);			

	ALU0: ALU port map(
			'0' & reg_A_out(3 downto 0),
			'0' & reg_B_out(3 downto 0),
			ALU_Op,
			ALU_out,
			zero_flag,
			carry_flag);
			
    test_mux0: demux1to2 port map(
            ALU_out,
            test_mux,
            demux_out_data,            
            demux_out_SA);
	
	signature_analyzer0: signature_analyzer port map(
            Clk,
            Clr_SA,
            Ld_SA,
            demux_out_SA,
            signature_out);
	
	comparator0: comparator port map(
	       Clk,
           signature_out,
	       pass_signal,
	       fail_signal);
	
	DATA_MUX0: mux4to1 port map(
			DATA_IN,
			data_mem_out,
			"000" & demux_out_data,
			(OTHERS => '0'),
			DATA_Mux,
			data_bus_s);
			
	DATA_BUS <= data_bus_s;
	Out_A <= reg_A_out;
	Out_B <= reg_B_out;
	Out_IR <= IR_OUT;
	Out_PC <= out_pc_sig;
	ADDR_OUT <= out_pc_sig;
	
	MEM_ADDR <= RED_out_Data_Mem;
	MEM_IN <= reg_Mux_out;
	MEM_OUT <= data_mem_out;
	
	signature <= signature_out;
	
end Behavior;
	
			