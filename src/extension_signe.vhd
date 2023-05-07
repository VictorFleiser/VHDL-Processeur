library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity extension_signe is
generic(
	N : integer := 32
	);
port (
	E : in std_logic_vector(N-1 downto 0);
	S : out std_logic_vector(31 downto 0)
	);
end entity;

architecture Behavorial of extension_signe is
	signal tempo : std_logic_vector((31-N) downto 0) := (others => '0');
begin
	tempo <= (others => E(N-1));
	S <= tempo & E;
end architecture Behavorial;
