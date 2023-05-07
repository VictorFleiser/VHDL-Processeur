LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity unite_traitement_tb is
	port(
		OK: out Boolean := True
		);
-- Declaration Type Tableau Memoire
	type table is array(15 downto 0) of std_logic_vector(31 downto 0);
-- Declaration Type Tableau Memoire
	type mem is array(63 downto 0) of std_logic_vector(31 downto 0);
-- Declaration Type nom d'instruction pour l'affichage dans le test bench
	type instruction_name is(
		RESET_initial,
		MOV_R1_x02,		-- R1 = 0x2
		MOV_R2_x03,		-- R2 = 0x3
		ADDr_R3_R1_R2,	-- R3 = R1 + R2 = 0x5
		ADDi_R4_R1_x55,	-- R4 = R1 + 0x55 = 0x57
		SUBr_R5_R4_R3,	-- R5 = R4 – R3 = 0x52
		SUBi_R6_R5_x01,	-- R6 = R5 – 0x1 = 0x51
		R7_egal_R6,		-- R7 = R6 = 0x51
		STR_R4_0_R1,	-- mem(R1) = R4 = 0x57
		LDR_R8_0_R1,	-- R8 = mem(R1) = 0x57
		AND_R9_R1_R2	-- R9 = R1 AND R2 = 0x2
		);
end;

architecture TEST of unite_traitement_tb is

signal clk, reset, RegWr, COM1, COM2, WrEn, RegSel: std_logic;
signal OP : std_logic_vector(2 downto 0);
signal flag, Rd, Rn, Rm : std_logic_vector(3 downto 0);
signal Imm : std_logic_vector(7 downto 0);
signal B : std_logic_vector(31 downto 0);

signal TESTS : std_logic_vector(31 downto 0);
signal instr_courante: instruction_name;

begin

-- Unit Under Test instanciation
UUT : entity work.unite_traitement
port map ( 
	clk => clk,
	reset => reset,
	RegWr => RegWr,
	WrEn => WrEn,
	COM1 => COM1,
	COM2 => COM2,
	RegSel => RegSel,
	OP => OP,
	Rn => Rn,
	Rm => Rm,
	Rd => Rd,
	Imm => Imm,

	B => B,
	flag => flag
	);

CLOCK: process
  begin
	while now <= 220 NS loop
	  clk <= '0';
	  wait for 5 NS;
	  clk <= '1';
	  wait for 5 NS;
	end loop;
	wait;
  end process;

-- Control Simulation and check outputs
process begin
	--RESET
	reset <= '1';
	RegSel <= '0';
	RegWr <= '0';
	WrEn <= '0';
	COM1 <= '0';
	COM2 <= '0';
	OP <= "000";
	Rn <= "0000";
	Rm <= "0000";
	Rd <= "0000";
	Imm <= "00000000";
	instr_courante <= RESET_initial;

	wait for 10 ns;
	reset <= '0';
	--Write a registers from immediate
	--MOV R1,#0x02
	instr_courante <= MOV_R1_x02;

	Imm <= "00000010";
	COM1 <= '1';
	OP <= "001";
	Rd <= "0001";
	RegWr <= '1';

	wait for 20 ns;
	--Write a registers from immediate
	--MOV R2,#0x03
	instr_courante <= MOV_R2_x03;

	Imm <= "00000011";
	COM1 <= '1';
	COM2 <= '0';
	OP <= "001";
	Rd <= "0010";
	RegWr <= '1';

	wait for 20 ns;
	--Add 2 registers
	--ADDr R3,R1,R2
	instr_courante <= ADDr_R3_R1_R2;

	COM1 <= '0';
	COM2 <= '0';
	OP <= "000";
	Rn <= "0001";
	rm <= "0010";
	Rd <= "0011";
	RegWr <= '1';
	
	wait for 5 ns;
	--Get Signal to test
	TESTS <= << signal.unite_traitement_tb.UUT.busW : std_logic_vector >>;

	wait for 5 ns;
	--Verification	00000010 + 00000011 = 00000101
	if (TESTS /= "00000000000000000000000000000101") then
		OK <= False;
	end if;

	wait for 10 ns;
	--Add 1 register with immediate
	--ADDi R4,R1,#0x55
	instr_courante <= ADDi_R4_R1_x55;

	COM1 <= '1';
	Imm <= "01010101";
	COM2 <= '0';
	OP <= "000";
	Rn <= "0001";
	Rd <= "0100";
	RegWr <= '1';

	wait for 5 ns;
	--Get Signal to test
	TESTS <= << signal.unite_traitement_tb.UUT.busW : std_logic_vector >>;

	wait for 5 ns;
	--Verification	00000010 + 01010101 = 01010111
	if (TESTS /= "00000000000000000000000001010111") then
		OK <= False;
	end if;

	wait for 10 ns;
	--Sub 2 registers
	--SUBr R5,R4,R3
	instr_courante <= SUBr_R5_R4_R3;

	COM1 <= '0';
	COM2 <= '0';
	OP <= "010";
	Rn <= "0100";
	Rm <= "0011";
	Rd <= "0101";
	RegWr <= '1';

	wait for 5 ns;
	--Get Signal to test
	TESTS <= << signal.unite_traitement_tb.UUT.busW : std_logic_vector >>;

	wait for 5 ns;
	--Verification	01010111 - 00000101 = 01010010
	if (TESTS /= "00000000000000000000000001010010") then
		OK <= False;
	end if;

	wait for 10 ns;
	--Sub 1 register with immediate
	--SUBi R6,R5,#0x01
	instr_courante <= SUBi_R6_R5_x01;

	Imm <= "00000001";
	COM1 <= '1';
	COM2 <= '0';
	OP <= "010";
	Rn <= "0101";
	Rd <= "0110";
	RegWr <= '1';

	wait for 5 ns;
	--Get Signal to test
	TESTS <= << signal.unite_traitement_tb.UUT.busW : std_logic_vector >>;

	wait for 5 ns;
	--Verification	01010010 - 00000001 = 01010001
	if (TESTS /= "00000000000000000000000001010001") then
		OK <= False;
	end if;

	wait for 10 ns;
	--Copy register to other register
	--R7_egal_R6
	instr_courante <= R7_egal_R6;

	COM1 <= '0';
	COM2 <= '0';
	OP <= "011";
	Rn <= "0110";
	Rd <= "0111";
	RegWr <= '1';

	wait for 10 ns;
	--Get copied Register
	TESTS <= << signal.unite_traitement_tb.UUT.registers.banc : table >>(7);

	wait for 5 ns;
	--Verification	banc(RW) == banc(RA)
	if (TESTS /= "00000000000000000000000001010001") then
		OK <= False;
	end if;

	wait for 15 ns;
	--Copy register to memory		--correct?
	--STR R4,0(R1)
	instr_courante <= STR_R4_0_R1;

	COM1 <= '0';
	COM2 <= '1';
	WrEn <= '1';
	RegSel <= '1';
	OP <= "011";
	Rn <= "0001";	--write Adress is in register(RA)
	Rd <= "0100";	--RB is Read adress
	RegWr <= '0';

	wait for 10 ns;
	--Get copied Register
	TESTS <= << signal.unite_traitement_tb.UUT.memory.Memory : mem >>(2);

	wait for 5 ns;
	--Verification	mem(RA) == banc(RB)
	if (TESTS /= "00000000000000000000000001010111") then
		OK <= False;
	end if;

	wait for 10 ns;
	--load memory to register
	--LDR R8,0(R1)
	instr_courante <= LDR_R8_0_R1;

	COM1 <= '0';
	COM2 <= '1';
	WrEn <= '0';
	RegSel <= '0';
	OP <= "011";
	Rn <= "0001";	--read Adress is in register(RA)
	Rd <= "1000";	--write adress is RW
	RegWr <= '1';

	wait for 10 ns;
	--Get copied Register
	TESTS <= << signal.unite_traitement_tb.UUT.registers.banc : table >>(8);

	wait for 5 ns;
	--Verification	banc(RW) == mem(RA)
	if (TESTS /= "00000000000000000000000001010111") then
		OK <= False;
	end if;

	wait for 10 ns;
	--AND operation
	--AND R9,R1,R2
	instr_courante <= AND_R9_R1_R2;

	COM1 <= '0';
	COM2 <= '0';
	WrEn <= '0';
	RegSel <= '0';
	OP <= "101";
	Rn <= "0001";
	Rm <= "0010";
	Rd <= "1001";
	RegWr <= '1';

	wait for 10 ns;
	--Get copied Register
	TESTS <= << signal.unite_traitement_tb.UUT.registers.banc : table >>(9);

	wait for 5 ns;
	--Verification	banc(Rn) and banc(Rm)
	if (TESTS /= "00000000000000000000000000000010") then
		OK <= False;
	end if;

  wait;
end process;

end;