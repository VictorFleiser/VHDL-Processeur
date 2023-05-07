LIBRARY ieee;
	USE ieee.std_logic_1164.ALL;
	USE ieee.numeric_std.ALL;

entity unite_gestion_instructions is
port (
	clk, reset, nPCsel : in std_logic;
	Offset : in std_logic_vector(23 downto 0);
	Instruction : out std_logic_vector(31 downto 0)
	);
end;

architecture behaviour of unite_gestion_instructions is

signal PC_Extended, PC_Selected, Addr, PC_incremented, PC_offset : std_logic_vector(31 downto 0);

begin

	PC_incremented <= std_logic_vector(to_unsigned((to_integer(unsigned(Addr))+1),32));
	PC_offset <= std_logic_vector(to_unsigned((to_integer(unsigned(PC_incremented)) + to_integer(unsigned(PC_Extended))),32));

	PC_Extender : entity work.PC_Extender
	port map (
		E => Offset,
		S => PC_Extended
	);

	mux2v1 : entity work.mux2v1
	generic map ( N => 32)
	port map (
		A => PC_incremented,
		B => PC_offset,
		COM => nPCsel,
		S => PC_Selected
	);

	PC_register : entity work.PC_register
	port map (
		clk => clk,
		reset => reset,
		inPC => PC_Selected,
		outPC => Addr
	);

	instruction_memory : entity work.instruction_memory
	port map (
		PC => Addr,
		Instruction => Instruction
	);
	
end;