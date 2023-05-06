LIBRARY ieee;
	USE ieee.std_logic_1164.ALL;
	USE ieee.numeric_std.ALL;

entity unite_traitement is
port (
	clk, reset, RegWr, WrEn, COM1, COM2, RegSel: in std_logic;
	OP : in std_logic_vector(2 downto 0);
	Rd, Rn, Rm : in std_logic_vector(3 downto 0);
	Imm : in std_logic_vector(7 downto 0);

	B : out std_logic_vector(31 downto 0);
	flag : out std_logic_vector(3 downto 0)
	);
end;

architecture behaviour of unite_traitement is

	signal busA, busB, busW, ALUOut, DataOut, ImmExtended, ALUIn : std_logic_vector(31 downto 0);
	signal Rb_IN : std_logic_vector(3 downto 0);

begin

	mux2v1_registers : entity work.mux2v1
	generic map (
		N => 4
	)
	port map (
		A => Rm,
		B => Rd,
		COM => RegSel,

		S => Rb_IN
	);

	registers : entity work.registers
	port map (
		clk => clk,
		reset => reset,
		WE => RegWr,
		W => busW,
		RA => Rn,
		RB => Rb_IN,
		RW => Rd,
		A => busA,
		B => busB
	);

	ALU : entity work.ALUv3
	port map (
		OP => OP,
		A => busA,
		B => ALUIn,
		S => ALUOut,
		N => flag(0),
		Z => flag(1),
		C => flag(2),
		V => flag(3)
	);

	mux2v1_a : entity work.mux2v1
	generic map ( N => 32)
	port map (
		A => busB,
		B => ImmExtended,
		COM => COM1,
		S => ALUIn
	);

	mux2v1_b : entity work.mux2v1
	generic map ( N => 32)
	port map (
		A => ALUOut,
		B => DataOut,
		COM => COM2,
		S => busW
	);

	memory : entity work.memoire_data
	port map (
		clk => clk,
		reset => reset,
		WrEn => WrEn,
		DataIn => busB,
		DataOut => DataOut,
		Addr => ALUOut(5 downto 0)
	);

	Imm_Extender : entity work.extension_signe
	generic map ( N => 8)
	port map (
		E => Imm,
		S => ImmExtended
	);
	
	B <= busB;

end;