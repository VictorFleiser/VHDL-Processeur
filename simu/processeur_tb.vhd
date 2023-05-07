LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity processeur_tb is
	port(
		OK: out Boolean := True
		);
-- Declaration Type Tableau Memoire
	type table is array(15 downto 0) of std_logic_vector(31 downto 0);
-- Declaration Type Tableau Memoire
	type mem is array(63 downto 0) of std_logic_vector(31 downto 0);

-- Declaration des Types de tests
	type TEST_memory_array_type is array(10 downto 0) of std_logic_vector(31 downto 0);
	-- les 11 logic vectors correspondent à la mémoire de x20 à x2c
	type TEST_registers_array_type is array(2 downto 0) of std_logic_vector(31 downto 0);
	-- les 3 logic vectors correspondent aux registres 0 à 2

end;

architecture TEST of processeur_tb is


signal clk, reset : std_logic;
signal Afficheur : std_logic_vector(31 downto 0);

signal TESTS_memory : TEST_memory_array_type;
signal TESTS_registers : TEST_registers_array_type;
signal TESTS_registre_tempo : std_logic_vector(31 downto 0);

begin

-- Unit Under Test instanciation
UUT : entity work.processeur
port map ( 
	clk => clk,
	reset => reset,
	Afficheur => Afficheur
	);

CLOCK: process
  begin
	while now <= 540 NS loop
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

	wait for 10 ns;	--10
	reset <= '0';

	--VERIFICATION DES VALEURS INITIALES
	for i in 0 to 9 loop
		TESTS_memory(i) <= << signal.processeur_tb.UUT.unite_traitement.memory.Memory : mem >>(32+i);	--load memory
	end loop;
	for i in 0 to 2 loop
		TESTS_registers(i) <= << signal.processeur_tb.UUT.unite_traitement.registers.Banc : table >>(i);--load register
	end loop;	

	wait for 2.5 ns;--12.5 NS

	for i in 0 to 9 loop
		if (TESTS_memory(i) /= std_logic_vector(to_unsigned(i+1,32))) then								--test si c'est la bonne valeur
			OK <= False;
		end if;
	end loop;

	for i in 0 to 2 loop
		if (TESTS_registers(i) /= "00000000000000000000000000000000") then								--test si c'est la bonne valeur
			OK <= False;
		end if;
	end loop;	

	wait for 5 ns;	--17.5 NS

	--PREMIERE INSTRUCTION FINIE
	--MOV R1,#0x20
	TESTS_registers(1) <= << signal.processeur_tb.UUT.unite_traitement.registers.Banc : table >>(1);--load register 1
	wait for 5 ns;--22.5
	if (TESTS_registers(1) /= x"00000020") then								--test si c'est la bonne valeur
		OK <= False;
	end if;
	wait for 5 ns;	--27.5 NS

	--2EME INSTRUCTION FINIE
	--MOV R2,#0x00
	TESTS_registers(2) <= << signal.processeur_tb.UUT.unite_traitement.registers.Banc : table >>(2);--load register 2
	wait for 5 ns;	--32.5 NS
	if (TESTS_registers(2) /= x"00000000") then								--test si c'est la bonne valeur
		OK <= False;
	end if;
	wait for 5 ns;	--37.5 NS

	--Il y a 10 itérations de la boucle
	for i in 0 to 9 loop

		--3EME INSTRUCTION FINIE
		--LDR R0,0(R1)
		TESTS_registers(0) <= << signal.processeur_tb.UUT.unite_traitement.registers.Banc : table >>(0);--load register 0
		wait for 5 ns;
		if (TESTS_registers(0) /= << signal.processeur_tb.UUT.unite_traitement.memory.Memory : mem >>(to_integer(unsigned(TESTS_registers(1))))) then								--test si c'est la bonne valeur
			OK <= False;
		end if;

		TESTS_registre_tempo <= << signal.processeur_tb.UUT.unite_traitement.registers.Banc : table >>(2);--load register 2
		wait for 5 ns;

		--4EME INSTRUCTION FINIE
		--ADD R2,R2,R0
		TESTS_registers(2) <= << signal.processeur_tb.UUT.unite_traitement.registers.Banc : table >>(2);--load register 2
		wait for 5 ns;
		if (TESTS_registers(2) /= std_logic_vector(to_unsigned(to_integer(unsigned(TESTS_registre_tempo))+to_integer(unsigned(TESTS_registers(0))),32))) then								--test si c'est la bonne valeur
			OK <= False;
		end if;

		TESTS_registre_tempo <= << signal.processeur_tb.UUT.unite_traitement.registers.Banc : table >>(1);--load register 1
		wait for 5 ns;

		--5EME INSTRUCTION FINIE
		--ADD R1,R1,#1
		TESTS_registers(1) <= << signal.processeur_tb.UUT.unite_traitement.registers.Banc : table >>(1);--load register 1
		wait for 5 ns;
		if (TESTS_registers(1) /= std_logic_vector(to_unsigned(to_integer(unsigned(TESTS_registre_tempo))+1,32))) then								--test si c'est la bonne valeur
			OK <= False;
		end if;
		wait for 5 ns;

		--on passe la 6EME et 7EME INSTRUCTION
		wait for 20 ns;

	end loop;

	--537.5 NS
	--AVANT DERNIERE INSTRUCTION FINIE
	--STR R2,0(R1)
	TESTS_memory(10) <= << signal.processeur_tb.UUT.unite_traitement.memory.Memory : mem >>(42);	--load memory
	wait for 5 ns;	--542.5 NS
	if (TESTS_memory(10) /= x"00000037" ) then								--test si c'est la bonne valeur (1+2+...+9+10 = 55 = 0x37)
		OK <= False;
	end if;
	wait for 5 ns;	--547.5 NS

	--DERNIERE INSTRUCTION FINIE
	--BAL main

	--Programme recomence

	wait;
end process;

end;