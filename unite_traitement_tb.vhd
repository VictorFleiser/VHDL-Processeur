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
end;

architecture TEST of unite_traitement_tb is

signal clk, reset, RegWr, COM1, COM2, WrEn, RegSel: std_logic;
signal OP : std_logic_vector(2 downto 0);
signal flag, Rd, Rn, Rm : std_logic_vector(3 downto 0);
signal Imm : std_logic_vector(7 downto 0);
signal B : std_logic_vector(31 downto 0);

signal TESTS : std_logic_vector(31 downto 0);

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
	flag => flag,
	B => B,
	Imm => Imm
	);

CLOCK: process
  begin
	while now <= 200 NS loop
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
	RA <= "0000";
	Rb_IN <= "0000";
	Rd <= "0000";
--	flag <= "0000"
	Imm <= "00000000";

	wait for 20 ns;
	reset <= '0';
	--Write a registers from immediate
	Imm <= "00000010";
	COM1 <= '1';
	OP <= "001";
	Rd <= "0001";
	RegWr <= '1';

	wait for 20 ns;
	--Write a registers from immediate
	Imm <= "00000011";
	COM1 <= '1';
	COM2 <= '0';
	OP <= "001";
	Rd <= "0010";
	RegWr <= '1';

	wait for 20 ns;
	--Add 2 registers
	COM1 <= '0';
	COM2 <= '0';
	OP <= "000";
	Rn <= "0001";
	Rb_IN <= "0010";
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
	COM1 <= '0';
	COM2 <= '0';
	OP <= "010";
	Rn <= "0100";
	Rb_IN <= "0011";
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
	--Copy register to memory
	COM1 <= '0';
	COM2 <= '1';
	WrEn <= '1';

	OP <= "011";
	Rn <= "0001";	--write Adress is in register(RA)
	Rb_IN <= "0100";	--RB is Read adress
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
	--Copy memory to register
	COM1 <= '0';
	COM2 <= '1';
	WrEn <= '0';

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

  wait;
end process;

end;