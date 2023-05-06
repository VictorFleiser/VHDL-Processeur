LIBRARY ieee;
	USE ieee.std_logic_1164.ALL;
	USE ieee.numeric_std.ALL;

entity unite_controle is
port (
	clk, reset : in std_logic;

	NCVZ : in std_logic_vector(31 downto 0);
	Instruction : in std_logic_vector(31 downto 0);
	Afficheur_Reg_IN : in std_logic_vector(31 downto 0);

	nPC_SEL, RegWr, RegSel, ALUSrc, MemWr, WrSrc : out std_logic;
	ALUCtrl : out std_logic_vector(2 downto 0);
	Afficheur : out std_logic_vector(31 downto 0)
	);
end;

architecture behaviour of unite_controle is

	signal PSREn, RegAff : std_logic;
	signal Flags : std_logic_vector(31 downto 0);

begin

	decodeur_instructions : entity work.decodeur_instructions
	port map (
		Instruction => Instruction,
		PSR => Flags,

		nPC_SEL => nPC_SEL,
		RegWr => RegWr,
		RegSel => RegSel,
		ALUSrc => ALUSrc,
		RegAff => RegAff,
		MemWr => MemWr,
		ALUCtrl => ALUCtrl,
		PSREn => PSREn,
		WrSrc => WrSrc
	);

	reg_PSR : entity work.register_32
	port map (
		CLK => clk,
		RST => reset,
		WE => PSREn,
		DATAIN => NCVZ,

		DATAOUT => Flags
	);

	reg_Aff : entity work.register_32
	port map (
		CLK => clk,
		RST => reset,
		WE => RegAff,
		DATAIN => Afficheur_Reg_IN,

		DATAOUT => Afficheur
	);



end;