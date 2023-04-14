library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUv2 is
port (
	OP : in std_logic_vector(2 downto 0);
	A, B : in std_logic_vector(31 downto 0);
	S : out std_logic_vector(31 downto 0);
	N, Z, C, V : out std_logic
	);
end entity;

architecture RTL of ALUv2 is
	signal Y31 : std_logic_vector(31 downto 0);
	signal Y32 : std_logic_vector(32 downto 0);
	signal aS, bS : signed(32 downto 0);
begin

	aS <= signed(A(31) & A(31) & A(30 downto 0));
	bS <= signed(B(31) & B(31) & B(30 downto 0));

	with OP select Y31 <=
		std_logic_vector(signed(A)+signed(B)) when "000",
		B when "001",
		std_logic_vector(signed(A)-signed(B)) when "010",
		A when "011",
		(A or B) when "100",
		(A and B) when "101",
		(A xor B) when "110",
		(not A) when "111",
		"--------------------------------" when others;

	with OP select Y32 <=
		std_logic_vector(aS+bS) when "000",
		std_logic_vector(aS-bS) when "010",
		"---------------------------------" when others;


	S <= Y31;

--	S <= Y32(32) & Y32(30 downto 0) when (OP = "000" or OP = "010") else
--		Y31;

	z <= '1' when ((OP = "000" or OP = "010") and Y32 = "000000000000000000000000000000000") else
		'1' when (OP /= "000" and OP /= "010" and Y31 = "00000000000000000000000000000000") else
		'0';

	N <= Y32(32) when (OP = "000" or OP = "010") else
		Y31(31);

	C <= '1' when ((OP = "000") and (Y32(31) = '1') ) else
		'1' when ((OP = "010") and (Y32(31) = '0') ) else
		'0';
	V <= '1' when ((OP = "000") and (A(31) = B(31)) and (Y32(32) /= A(31)) ) else
		'1' when ((OP = "010") and (A(31) /= B(31)) and (Y32(32) /= A(31)) ) else
		'0';

end architecture RTL;
