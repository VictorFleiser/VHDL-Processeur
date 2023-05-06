library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity decodeur_instructions is
port (
	Instruction, PSR : in std_logic_vector(31 downto 0);
	nPC_SEL, RegWr, RegSel, ALUSrc, RegAff, MemWr, PSREn, WrSrc : out std_logic;
	ALUCtrl : out std_logic_vector(2 downto 0)
	);

	type enum_instruction is(MOV, ADDi, ADDr, CMP, LDR, STR, B, BLT, UNDEFINED);	--UNDEFINED added by me

end entity;

architecture Behavorial of decodeur_instructions is

	signal instr_courante: enum_instruction;
	signal N,C,Z,V: std_logic;

begin	

	process(all)		--TODO : CHANGE LIST OF SENSIBILITIES
	begin
		if (Instruction(27 downto 26) = "00") then 				--Instruction de traitement :
			case Instruction(24 downto 21) is
				when "1101" => instr_courante <= MOV;									--MOV
				when "1010" => instr_courante <= CMP;									--CMP
				when "0100" => instr_courante <= ADDi when (Instruction(25) = '1') else	--ADDi
				ADDr when Instruction(25) = '0' else 									--ADDr
				UNDEFINED;
				when others => instr_courante <= UNDEFINED;
			end case;

		elsif (Instruction(27 downto 26) = "01") then			--Instruction de transfert :
			if (Instruction(20) = '0') then						-- Link = 0 = Store
				instr_courante <= STR;													--STR
			elsif (Instruction(20) = '1') then					-- Link = 1 = Load
				instr_courante <= LDR;													--LDR
			else
				instr_courante <= UNDEFINED;
			end if;

		elsif (Instruction(27 downto 25) = "101") then			--Instruction de branchement relatif :

			if Instruction(31 downto 28) = "1011" then			--cond = LT
				instr_courante <= BLT;													--BLT

			elsif Instruction(31 downto 28) = "1110" then		--cond = AL

				if (Instruction(24) = '0') then					-- Link = 0 = Branch
					instr_courante <= B;												--B
				elsif (Instruction(24) = '1') then				-- Link = 1 = Branch and link
					instr_courante <= UNDEFINED;										--BAL (NOT IMPLEMENTED)
				else
					instr_courante <= UNDEFINED;
				end if;
			else
				instr_courante <= UNDEFINED;
			end if;
		
		else
			instr_courante <= UNDEFINED;
		end if;

		N <= PSR(28);
		C <= PSR(29);
		Z <= PSR(30);
		V <= PSR(31);


		if (instr_courante = ADDi) then
			nPC_SEL <= '0';
			RegWr <= '1';
			ALUSrc <= '1';
			ALUCtrl <= "000";
			PSREn <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
			RegAff <= '0';
		elsif (instr_courante = ADDr) then
			nPC_SEL <= '0';
			RegWr <= '1';
			ALUSrc <= '0';
			ALUCtrl <= "000";
			PSREn <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
			RegAff <= '0';
		elsif (instr_courante = B) then
			nPC_SEL <= '1';
			RegWr <= '0';
			ALUSrc <= '0';
			ALUCtrl <= "000";
			PSREn <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
			RegAff <= '0';
		elsif (instr_courante = BLT) then
			nPC_SEL <= '1' when (N = '1') else '0';	--Branch if (reg<imm) <=> (reg-imm negatif) <=> (N flag = 1)
			RegWr <= '0';
			ALUSrc <= '0';
			ALUCtrl <= "000";
			PSREn <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
			RegAff <= '0';
		elsif (instr_courante = CMP) then
			nPC_SEL <= '0';
			RegWr <= '0';
			ALUSrc <= '1';
			ALUCtrl <= "010";
			PSREn <= '1';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
			RegAff <= '0';
		elsif (instr_courante = LDR) then
			nPC_SEL <= '0';
			RegWr <= '1';
			ALUSrc <= '1';
			ALUCtrl <= "000";
			PSREn <= '0';
			MemWr <= '0';
			WrSrc <= '1';
			RegSel <= '0';
			RegAff <= '0';
		elsif (instr_courante = MOV) then
			nPC_SEL <= '0';
			RegWr <= '1';
			ALUSrc <= '1';
			ALUCtrl <= "001";
			PSREn <= '0';
			MemWr <= '0';
			WrSrc <= '0';
			RegSel <= '0';
			RegAff <= '0';
		elsif (instr_courante = STR) then
			nPC_SEL <= '0';
			RegWr <= '0';
			ALUSrc <= '1';
			ALUCtrl <= "000";
			PSREn <= '0';
			MemWr <= '1';
			WrSrc <= '0';
			RegSel <= '1';
			RegAff <= '1';
		else							--UNDEFINED
			nPC_SEL <= '-';
			RegWr <= '-';
			ALUSrc <= '-';
			ALUCtrl <= "---";
			PSREn <= '-';
			MemWr <= '-';
			WrSrc <= '-';
			RegSel <= '-';
			RegAff <= '-';
		end if;
		end process;

	--CHEESE METHOD : 
--	instr_courante <=
--		MOV when Instruction(31 downto 20) = x"E3A" else
--		ADDi when Instruction(31 downto 20) = x"E28" else
--		ADDr when Instruction(31 downto 20) = x"E08" else
--		CMP when Instruction(31 downto 20) = x"E35" else
--		LDR when Instruction(31 downto 20) = x"E61" else
--		STR when Instruction(31 downto 20) = x"E60" else
--		BAL when Instruction(31 downto 20) = x"EAF" else
--		BLT when Instruction(31 downto 20) = x"BAF" else


end architecture Behavorial;
