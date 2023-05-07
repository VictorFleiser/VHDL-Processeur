LIBRARY ieee;
USE ieee.std_logic_1164.ALL;
USE ieee.numeric_std.ALL;

entity top_level is
	port (
		CLOCK_50 		:  IN  STD_LOGIC;
		KEY			 	:  IN  STD_LOGIC_VECTOR(1 DOWNTO 0);
		SW 				:  IN  STD_LOGIC_VECTOR(9 DOWNTO 0);
		HEX0 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX1 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX2 			:  OUT  STD_LOGIC_VECTOR(0 TO 6);
		HEX3 			:  OUT  STD_LOGIC_VECTOR(0 TO 6)
	);
end entity top_level;


architecture RTL of top_level is

	signal rst, clk, pol  : std_logic;
	signal Afficheur : std_logic_vector(31 downto 0);


begin

	rst <= not KEY(0);
	clk <= CLOCK_50; 
	pol <= SW(9);

	processeur : entity work.processeur port map (
		clk => clk,
		reset => rst,
		Afficheur => Afficheur
		);

	SEVEN_SEG_UNITIES : entity work.SEVEN_SEG port map (
		Data => Afficheur(3 downto 0),
		Pol => pol,
		Segout => HEX0
		);

	SEVEN_SEG_TENS : entity work.SEVEN_SEG port map (
		Data => Afficheur(7 downto 4),
		Pol => pol,
		Segout => HEX1
		);

	SEVEN_SEG_HUNDREDS : entity work.SEVEN_SEG port map (
		Data => Afficheur(11 downto 8),
		Pol => pol,
		Segout => HEX2
		);

	SEVEN_SEG_THOUSNDS : entity work.SEVEN_SEG port map (
		Data => Afficheur(15 downto 12),
		Pol => pol,
		Segout => HEX3
		);

END architecture;




