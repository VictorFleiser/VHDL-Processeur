library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity memoire_data is
port (
	clk, reset, WrEn : in std_logic;
	DataIn : in std_logic_vector(31 downto 0);
	DataOut : out std_logic_vector(31 downto 0);
	Addr : in std_logic_vector(5 downto 0)
	);

-- Declaration Type Tableau Memoire
	type mem is array(63 downto 0) of std_logic_vector(31 downto 0);
end entity;

architecture Behavorial of memoire_data is

-- Fonction d'Initialisation de la memoire de Registres
	function init_Memory return mem is
	variable result : mem;
	begin
		for i in 63 downto 0 loop
			result(i) := (others=>'0');
		end loop;
		return result;
	end init_Memory;

-- Déclaration et Initialisation de la memore de 64 registres 32 bits
	signal Memory: mem:=init_Memory;

begin

	process (clk, reset)
	begin
		if reset = '1' then

			--RESET de la mémoire de registres
			for i in 63 downto 0 loop
				Memory(i) <= (others=>'0');
			end loop;

		elsif rising_edge(clk) then
			if WrEn = '1' then
				--ECRITURE dans la mémoire de registres
				Memory(to_integer(unsigned(Addr))) <= DataIn;
			end if;
		end if;
	end process;

	DataOut <= Memory(to_integer(unsigned(Addr)));

end architecture Behavorial;
