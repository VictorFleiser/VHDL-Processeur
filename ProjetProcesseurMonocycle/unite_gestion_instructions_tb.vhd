LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity unite_gestion_instructions_tb is
	port(
		OK: out Boolean := True
		);
end;

architecture TEST of unite_gestion_instructions_tb is

signal clk, reset, nPCsel : std_logic;
signal Offset : std_logic_vector(23 downto 0);
signal Instruction : std_logic_vector(31 downto 0);

begin

-- Unit Under Test instanciation
UUT : entity work.unite_gestion_instructions
port map ( 
	clk => clk,
	reset => reset,
	nPCsel => nPCsel,
	Offset => Offset,
	Instruction => Instruction
	);

CLOCK: process
  begin
	while now <= 100 NS loop
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
	nPCsel <= '0';
	Offset <= (others => '0');

	wait for 5 ns;

	--Verification	Instruction == x"E3A01020" == 1ere instruction
	if (Instruction /= x"E3A01020") then
		OK <= False;
	end if;

	wait for 2.5 ns;

	reset <= '0';

	--normal increment : increment by 1

	wait for 12.5 ns;

	--Verification	Instruction == x"E3A02000" == 2eme instruction
	if (Instruction /= x"E3A02000") then
		OK <= False;
	end if;

	wait for 10 ns;

	--Verification	Instruction == x"E6110000" == 3eme instruction
	if (Instruction /= x"E6110000") then
		OK <= False;
	end if;

	wait for 2.5 ns;

	--increment by an additional +1 : increment by 2

	Offset <= x"000001";
	nPCsel <= '1';

	wait for 7.5 ns;

	--Verification	Instruction == x"E2811001" == 5eme instruction
	if (Instruction /= x"E2811001") then
		OK <= False;
	end if;

	wait for 10 ns;

	--Verification	Instruction == x"BAFFFFFB" == 7eme instruction
	if (Instruction /= x"BAFFFFFB") then
		OK <= False;
	end if;

	wait for 2.5 ns;

	--increment by an additional -2 : increment by -1

	nPCsel <= '1';
	Offset <= x"FFFFFE";

	wait for 7.5 ns;

	--Verification	Instruction == x"E351002A" == 6eme instruction
	if (Instruction /= x"E351002A") then
		OK <= False;
	end if;

	wait for 10 ns;

	--Verification	Instruction == x"E2811001" == 5eme instruction
	if (Instruction /= x"E2811001") then
		OK <= False;
	end if;

	wait for 10 ns;

	--Verification	Instruction == x"E0822000" == 4eme instruction
	if (Instruction /= x"E0822000") then
		OK <= False;
	end if;

	wait for 10 ns;

	--Verification	Instruction == x"E6110000" == 3eme instruction
	if (Instruction /= x"E6110000") then
		OK <= False;
	end if;

	wait for 10 ns;

	--Verification	Instruction == x"E3A02000" == 2eme instruction
	if (Instruction /= x"E3A02000") then
		OK <= False;
	end if;

	wait for 10 ns;

	--Verification	Instruction == x"E3A01020" == 1ere instruction
	if (Instruction /= x"E3A01020") then
		OK <= False;
	end if;

  wait;
end process;

end;