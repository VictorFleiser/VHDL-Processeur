LIBRARY ieee;
	USE ieee.std_logic_1164.ALL;
	USE ieee.numeric_std.ALL;

entity processeur is
port (
	clk, reset : in std_logic;
	Afficheur : out std_logic_vector(31 downto 0)
	);
end;

architecture behaviour of processeur is

	--Decodeur d'instructions :
	signal nPC_SEL, RegWr, RegSel, ALUSrc, RegAff, MemWr, PSREn, WrSrc : std_logic;
	signal ALUCtrl : std_logic_vector(2 downto 0);
	--Flags et PSR :
	signal NCVZ : std_logic_vector(31 downto 0);
	signal Flags : std_logic_vector(31 downto 0) := (others=>'-');	--initiate value like that?

	--Instruction
	signal Instruction : std_logic_vector(31 downto 0);
	--Register addresses
	signal Rd, Rn, Rm, Rb_IN : std_logic_vector(3 downto 0);
	--immediate values
	signal Imm8 : std_logic_vector(7 downto 0);
	signal Imm24 : std_logic_vector(23 downto 0);

	--Afficheur :
	signal Afficheur_Reg_IN : std_logic_vector(31 downto 0);

begin

	Imm8 <= Instruction(7 downto 0);
	Imm24 <= Instruction(23 downto 0);
	NCVZ(27 downto 0) <= (others =>'-');	--works like this ?

	unite_traitement : entity work.unite_traitement
	port map (
		clk => clk,
		reset => reset,
		RegWr => RegWr,
		WrEn => MemWr,
		COM1 => ALUSrc,
		COM2 => WrSrc,
		OP => ALUCtrl,
		RegSel => RegSel,
		Rn => Rn,
		Rm => Rb_IN,
		Rd => Rd,
		Imm => Imm8,

		B => Afficheur_Reg_IN,
		flag => NCVZ(31 downto 28)
	);

	unite_gestion_instructions : entity work.unite_gestion_instructions
	port map (
		clk => clk,
		reset => reset,
		nPCsel => nPC_SEL,
		Offset => Imm24,

		Instruction => Instruction
	);

	unite_controle : entity work.unite_controle
	port map (
		clk => clk,
		reset => clk,
		NCVZ => NCVZ,
		Instruction => Instruction,

		nPC_SEL => nPC_SEL,
		RegWr => RegWr,
		RegSel => RegSel,
		ALUSrc => ALUSrc,
		RegAff => RegAff,
		MemWr => MemWr,
		WrSrc => WrSrc,
		ALUCtrl => ALUCtrl
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

