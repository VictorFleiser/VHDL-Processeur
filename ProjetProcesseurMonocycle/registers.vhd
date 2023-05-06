library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;
--std_logic_unsigned.all ?


entity registers is
port (
	clk, reset, WE : in std_logic;
	W : in std_logic_vector(31 downto 0);
	RA, RB, RW : in std_logic_vector(3 downto 0);
	A, B : out std_logic_vector(31 downto 0)
	);
	
-- Declaration Type Tableau Memoire
	type table is array(15 downto 0) of std_logic_vector(31 downto 0);

end entity;

architecture Combi of registers is

	-- Fonction d'Initialisation du Banc de Registres
	function init_banc return table is
	variable result : table;
	begin
		for i in 14 downto 0 loop
			result(i) := (others=>'0');
		end loop;
			result(15):=X"00000030";
			return result;
	end init_banc;

-- Déclaration et Initialisation du Banc de Registres 16x32 bits
	signal Banc: table:=init_banc;

begin

	process (clk, reset)
	begin
		if reset = '1' then

			--RESET du banc de registres
			for i in 14 downto 0 loop
				banc(i) <= (others=>'0');
			end loop;
			banc(15) <= X"00000030";

		elsif rising_edge(clk) then
			if WE = '1' then
				--ECRITURE dans le banc de registres
				banc(to_integer(unsigned(RW))) <= W;
			end if;
		end if;
	end process;

	A <= banc(to_integer(unsigned(RA))) when reset = '0' else
	(others=>'0');
	B <= banc(to_integer(unsigned(RB))) when reset = '0' else
	(others=>'0');

end architecture Combi;