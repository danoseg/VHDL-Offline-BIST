library ieee;
use ieee.std_logic_1164.all;

entity control_new is
	port(
		clk, mclk : IN STD_LOGIC;
		enable : IN STD_LOGIC;
		test_enable: in std_logic;
		statusC, statusZ : IN STD_LOGIC;
		INST : IN STD_LOGIC_VECTOR(7 DOWNTO 0);
		A_MUX, B_MUX : OUT STD_LOGIC;
		REG_Mux : OUT STD_LOGIC;
		DATA_Mux : OUT STD_LOGIC_VECTOR(1 DOWNTO 0);
		ALU_Op : OUT STD_LOGIC;
		inc_PC, ld_PC : OUT STD_LOGIC;
		clr_IR : OUT STD_LOGIC;
		ld_IR : OUT STD_LOGIC;
		clr_A, clr_B, clr_C, clr_Z : OUT STD_LOGIC;
	    ld_A, ld_B, ld_C, ld_Z: OUT STD_logic;
		clr_SA, ld_SA : OUT STD_LOGIC;
		test_mux : OUT STD_LOGIC;
		T : OUT STD_LOGIC_VECTOR(2 DOWNTO 0);
		wen, en : OUT STD_LOGIC);		
end control_new;

architecture description of control_new is
	type STATETYPE is (state_0, state_1, state_2);
	signal present_state : STATETYPE;
	signal Instruction_sig: STD_LOGIC_VECTOR(2 DOWNTO 0);
	signal Instruction_sig2: STD_LOGIC_VECTOR(3 DOWNTO 0);
	
	begin
		Instruction_sig <= INST(7 DOWNTO 5);
		Instruction_sig2 <= INST(7 DOWNTO 4);
		
	--Operation Decoder
	process (present_state, INST, statusC, statusZ, enable, Instruction_sig, Instruction_sig2)
	begin
	if enable ='1' then
		if present_state = state_0 then 
			DATA_Mux <= "00"; -- Fetch instruction address
			clr_IR <= '0';
			ld_IR <= '1';
			ld_PC <= '0';
			inc_PC <= '0';
			clr_A <= '0';
			ld_A <= '0';
			clr_B <= '0';
			ld_B <= '0';
			clr_C <= '0';
			ld_C <= '0';
			clr_Z <= '0';
			ld_Z <= '0';
			clr_SA <= '0';
			ld_SA <= '0';
			en <= '0';
			wen <= '0';
			
		elsif present_state = state_1 then
			clr_IR <= '0';
			ld_IR <= '0';
			ld_PC <= '1';
			inc_PC <= '1';
			clr_A <= '0';
			ld_A <= '0';
			clr_B <= '0';
			ld_B <= '0';
			clr_C <= '0';
			ld_C <= '0';
			clr_Z <= '0';
			ld_Z <= '0';
			clr_SA <= '0';
			ld_SA <= '0';
			en <= '0';
			wen <= '0';
			
				if Instruction_sig = "010" then -- STA
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '1';
					REG_Mux <= '0';
					DATA_Mux <= "00";
					
				elsif Instruction_sig = "011" then --STB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '1';
					REG_Mux <= '1';
					DATA_Mux <= "00";
					
				elsif Instruction_sig = "100" then --LDA
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '1';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '0';
					A_MUX <= '0';
					DATA_Mux <= "01";
					
				elsif Instruction_sig = "101" then --LDB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '1';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '0';
					B_MUX <= '0';
					DATA_Mux <= "01";
				end if;
				
			elsif present_state = state_2 then 
				if Instruction_sig = "100" then --LDA
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '1';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '0';
					A_MUX <= '0';
					DATA_Mux <= "01";
					
				elsif Instruction_sig = "101" then --LDB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '1';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
		            ld_SA <= '0';
					en <= '1';
					wen <= '0';
					B_MUX <= '0';
					DATA_Mux <= "01";
					
				elsif Instruction_sig = "010" then --STA
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '1';
					REG_Mux <= '0';
				 	DATA_Mux <= "00";
					
				elsif Instruction_sig = "011" then --STB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '1';
					REG_Mux <= '1';
					DATA_Mux <= "00";
					
				elsif Instruction_sig = "000" then --LDAI
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '1';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					A_MUX <= '1';
					
				elsif Instruction_sig = "001" then --LDBI
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '1';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					B_MUX <= '1';
					
					
				elsif Instruction_sig2 = "1100" then --ADD
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '1';
					clr_Z <= '0';
					ld_Z <= '1';
					ALU_Op <= '0';
					A_MUX <= '0';
					test_mux <= '0';
					DATA_Mux <= "10";
					
				elsif Instruction_sig2 = "1101" then --SUB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '1';
					clr_Z <= '0';
					ld_Z <= '1';
					ALU_Op <= '1';
					A_MUX <= '0';
					test_mux <= '0';
					DATA_Mux <= "10";
					
				elsif Instruction_sig2 = "1110" then --CLR_SA
						clr_IR <= '0';
                        ld_IR <= '0';
                        ld_PC <= '0';
                        inc_PC <= '0';
                        clr_A <= '0';
                        ld_A <= '0';
                        clr_B <= '0';
                        ld_B <= '0';
                        clr_C <= '0';
                        ld_C <= '0';
                        clr_Z <= '0';
                        ld_Z <= '0';
                        clr_SA <= '0';
                        ld_SA <= '0';
                        clr_SA <= '1';
			            ld_SA <= '0';
				elsif Instruction_sig2 = "1111" then -- CLR_A_B
						clr_IR <= '0';
                        ld_IR <= '0';
                        ld_PC <= '0';
                        inc_PC <= '0';
                        clr_A <= '1';
                        ld_A <= '0';
                        clr_B <= '1';
                        ld_B <= '0';
                        clr_C <= '0';
                        ld_C <= '0';
                        clr_Z <= '0';
                        ld_Z <= '0';
                        clr_SA <= '0';
                        ld_SA <= '0';
                        clr_SA <= '0';
			            ld_SA <= '0';
				end if; -- For state 2 Ops
			end if;
		end if;  -- For Enable
		
		if test_enable ='1' then
		if present_state = state_0 then 
			DATA_Mux <= "00"; -- Fetch instruction address
			clr_IR <= '0';
			ld_IR <= '1';
			ld_PC <= '0';
			inc_PC <= '0';
			clr_A <= '0';
			ld_A <= '0';
			clr_B <= '0';
			ld_B <= '0';
			clr_C <= '0';
			ld_C <= '0';
			clr_Z <= '0';
			ld_Z <= '0';
			clr_SA <= '0';
			ld_SA <= '0';
			en <= '0';
			wen <= '0';
			
		elsif present_state = state_1 then
			clr_IR <= '0';
			ld_IR <= '0';
			ld_PC <= '1';
			inc_PC <= '1';
			clr_A <= '0';
			ld_A <= '0';
			clr_B <= '0';
			ld_B <= '0';
			clr_C <= '0';
			ld_C <= '0';
			clr_Z <= '0';
			ld_Z <= '0';
			clr_SA <= '0';
			ld_SA <= '0';
			en <= '0';
			wen <= '0';
			
				if Instruction_sig = "010" then -- STA
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '1';
					REG_Mux <= '0';
					DATA_Mux <= "00";
					
				elsif Instruction_sig = "011" then --STB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '1';
					REG_Mux <= '1';
					DATA_Mux <= "00";
					
				elsif Instruction_sig = "100" then --LDA
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '1';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '0';
					A_MUX <= '0';
					DATA_Mux <= "01";
					
				elsif Instruction_sig = "101" then --LDB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '1';
					inc_PC <= '1';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '1';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '0';
					B_MUX <= '0';
					DATA_Mux <= "01";
				end if;
				
			elsif present_state = state_2 then 
				if Instruction_sig = "100" then --LDA
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '1';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '0';
					A_MUX <= '0';
					DATA_Mux <= "01";
					
				elsif Instruction_sig = "101" then --LDB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '1';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
		            ld_SA <= '0';
					en <= '1';
					wen <= '0';
					B_MUX <= '0';
					DATA_Mux <= "01";
					
				elsif Instruction_sig = "010" then --STA
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '1';
					REG_Mux <= '0';
				 	DATA_Mux <= "00";
					
				elsif Instruction_sig = "011" then --STB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					en <= '1';
					wen <= '1';
					REG_Mux <= '1';
					DATA_Mux <= "00";
					
				elsif Instruction_sig = "000" then --LDAI
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '1';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					A_MUX <= '1';
					
				elsif Instruction_sig = "001" then --LDBI
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '1';
					clr_C <= '0';
					ld_C <= '0';
					clr_Z <= '0';
					ld_Z <= '0';
					clr_SA <= '0';
			        ld_SA <= '0';
					B_MUX <= '1';
					
					
				elsif Instruction_sig2 = "1100" then --ADD
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '1';
					clr_Z <= '0';
					ld_Z <= '1';
					clr_SA <= '0';
			        ld_SA <= '1';
					ALU_Op <= '0';
					A_MUX <= '0';
					test_mux <= '1';
					
				elsif Instruction_sig2 = "1101" then --SUB
					clr_IR <= '0';
					ld_IR <= '0';
					ld_PC <= '0';
					inc_PC <= '0';
					clr_A <= '0';
					ld_A <= '0';
					clr_B <= '0';
					ld_B <= '0';
					clr_C <= '0';
					ld_C <= '1';
					clr_Z <= '0';
					ld_Z <= '1';
					clr_SA <= '0';
			        ld_SA <= '1';
					ALU_Op <= '1';
					A_MUX <= '0';
					test_mux <= '1';
					
				elsif Instruction_sig2 = "1110" then --CLR_SA
						clr_IR <= '0';
                        ld_IR <= '0';
                        ld_PC <= '0';
                        inc_PC <= '0';
                        clr_A <= '0';
                        ld_A <= '0';
                        clr_B <= '0';
                        ld_B <= '0';
                        clr_C <= '0';
                        ld_C <= '0';
                        clr_Z <= '0';
                        ld_Z <= '0';
                        clr_SA <= '0';
                        ld_SA <= '0';
                        clr_SA <= '1';
			            ld_SA <= '0';
				elsif Instruction_sig2 = "1111" then -- CLR_A
						clr_IR <= '0';
                        ld_IR <= '0';
                        ld_PC <= '0';
                        inc_PC <= '0';
                        clr_A <= '1';
                        ld_A <= '0';
                        clr_B <= '1';
                        ld_B <= '0';
                        clr_C <= '0';
                        ld_C <= '0';
                        clr_Z <= '0';
                        ld_Z <= '0';
                        clr_SA <= '0';
                        ld_SA <= '0';
                        clr_SA <= '0';
			            ld_SA <= '0';
				end if; -- For state 2 Ops
			end if;
		end if;  -- For Tet Enable
end process;

	process (clk, enable, test_enable)
		begin
			if (enable = '1' or test_enable ='1') then
				if rising_edge (clk) then
					if present_state = state_0 then present_state <= state_1;
					elsif present_state = state_1 then present_state <= state_2;
					else present_state <= state_0;
					end if;
				end if;
			else present_state <= state_0;
			end if;
	end process;

		with present_state select 
			T <= "001" when state_0,
				  "010" when state_1,
				  "011" when state_2,
				  "001" when others;
end description;