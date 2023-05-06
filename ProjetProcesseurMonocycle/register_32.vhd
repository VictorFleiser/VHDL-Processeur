library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


entity register_32 is
port (
	CLK, RST, WE : in std_logic;
	DATAIN : in std_logic_vector(31 downto 0);
	DATAOUT : out std_logic_vector(31 downto 0)
	);
end entity;

architecture Combi of register_32 is

	signal DATA: std_logic_vector(31 downto 0);

begin

	process (CLK, RST)
	begin
		if RST = '1' then
			DATA <= (others => '0');

		elsif rising_edge(clk) then
			if WE = '1' then
				--ECRITURE
				DATA <= DATAIN;
			end if;
		end if;
	end process;

	DATAOUT <= DATA;

end architecture Combi;