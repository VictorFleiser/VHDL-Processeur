library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity PC_Extender is
port (
	E : in std_logic_vector(23 downto 0);
	S : out std_logic_vector(31 downto 0)
	);
end entity;

architecture Behavorial of PC_Extender is
	signal tempo : std_logic_vector(7 downto 0) := (others => '0');
begin
	tempo <= (others => E(23));
	S <= tempo & E;

end architecture Behavorial;
