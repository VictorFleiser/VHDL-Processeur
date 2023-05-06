library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity PC_register is
port (
	clk, reset : in std_logic;
	inPc : in std_logic_vector(31 downto 0);
	outPc : out std_logic_vector(31 downto 0)
	);
end entity;

architecture Behavorial of PC_register is

	signal PC_reg: std_logic_vector(31 downto 0);

begin

	process (clk, reset)
	begin
		if reset = '1' then
			PC_reg <= (others => '0');

		elsif rising_edge(clk) then
			PC_reg <= inPc;
		end if;
	end process;

    outPc <= PC_reg;
end architecture Behavorial;