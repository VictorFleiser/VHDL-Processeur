LIBRARY ieee;
	USE ieee.std_logic_1164.ALL;
	USE ieee.numeric_std.ALL;

entity VIC is
port (
	clk, reset : in std_logic;
	IRQ_SERV, IRQ0, IRQ1 : in std_logic;

	IRQ : out std_logic;
	VICPC : out std_logic_vector(31 downto 0)
	);
end;

architecture behaviour of VIC is

	signal IRQ0_prec, IRQ1_prec : std_logic;
	signal IRQ0_memo, IRQ1_memo : std_logic;

begin

	process(clk, reset)	
		if reset = '1' then

--			IRQ0_prec <= '0';		--correct?
--			IRQ1_prec <= '0';		--correct?
			IRQ0_memo <= '0';
			IRQ1_memo <= '0';
			IRQ <= '0';
			VICPC <= (others => '0');

		elsif rising_edge(clk) then
			if (IRQ0 = '1' and IRQ0_prec = '0')

			IRQ0_prec <= IRQ0;
			IRQ1_prec <= IRQ1;
		end if;

	end process;


end;