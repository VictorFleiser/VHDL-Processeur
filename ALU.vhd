library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALU is
port (
	OP : in std_logic_vector(2 downto 0);
	A, B : in std_logic_vector(31 downto 0);
	S : out std_logic_vector(31 downto 0);
	N, Z, C, V : out std_logic
	);
end entity;

architecture RTL of ALU is
	signal Y1 : std_logic_vector(32 downto 0);
	signal aS, bS : signed(32 downto 0);
--	signal c1, c2, c3, c4, c5, c6, i1, i2 : integer;
--	signal sA, sB : signed(31 downto 0);
--	signal z1 : std_logic;
begin

	aS <= signed(A(31) & A(31) & A(30 downto 0));
	bS <= signed(B(31) & B(31) & B(30 downto 0));

	with OP select Y <=
		std_logic_vector(aS+bS) when "000",
		'-' & B when "001",
		std_logic_vector(aS-bS) when "010",
		'-' & A when "011",
		'-' & (A or B) when "100",
		'-' & (A and B) when "101",
		'-' & (A xor B) when "110",
		'-' & (not A) when "111",
--		((A or B)(31) & '-' & (A or B)(30 downto 0)) when "100",
--		((A and B)(31) & ('-') & (A and B)(30 downto 0)) when "101",
--		((A xor B)(31) & ('-') & (A xor B)(30 downto 0)) when "110",
--		((not A)(31) & ('-') & (not A)(30 downto 0)) when "111",
		"---------------------------------" when others;

	S <= Y(32) & Y(30 downto 0) when (OP = "000" or OP = "010") else
		Y(31 downto 0);

	z <= '1' when Y = "000000000000000000000000000000000" else
		'0';

	N <= Y(32) when (OP = "000" or OP = "010") else
		Y(31);

--	sA <= signed(A);
--	sB <= signed(B);
--	i1 <= to_integer(signed(A));
--	i2 <= to_integer(signed(B));
--	c1 <= to_integer(signed(A)+signed(B));
--	c2 <= (to_integer(signed(A))+to_integer(signed(A)));
--	c3 <= to_integer(signed(A)-signed(B));
--	c4 <= (to_integer(signed(A))-to_integer(signed(A)));
--	c5 <= i1 + i2;
--	c6 <= i1 - i2;

	C <= '1' when ((OP = "000") and (Y(31) = '1') ) else
		'1' when ((OP = "010") and (Y(31) = '0') ) else
		'0';

--	C <= '1' when ((OP = "000") and (to_integer(signed(A)+signed(B)) /= (c5)) ) else
--		'1' when ((OP = "010") and (to_integer(signed(A)-signed(B)) /= (c6)) ) else
--		'0';

	V <= '1' when ((OP = "000") and (A(31) = B(31)) and (Y(32) /= A(31)) ) else
		'1' when ((OP = "010") and (A(31) /= B(31)) and (Y(32) /= A(31)) ) else
		'0';
--	V <= '1' when ((OP = "000") and (A(31) = B(31) = '0') and (Y(32) = '1') ) else
--		'1' when ((OP = "000") and (A(31) = B(31) = '1') and (Y(32) = '0') ) else
--		'1' when ((OP = "010") and (A(31) /= B(31) = '0') and (Y(32) = '1') ) else
--		'1' when ((OP = "010") and (A(31) /= B(31) = '1') and (Y(32) = '0') ) else
--		'1' when ((OP = "010") and (A(31) = B(31)) and (Y(32)/=A(31)) ) else

--		'0';

end architecture RTL;
