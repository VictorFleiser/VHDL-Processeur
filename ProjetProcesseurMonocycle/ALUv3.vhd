library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity ALUv3 is
port (
	OP : in std_logic_vector(2 downto 0);
	A, B : in std_logic_vector(31 downto 0);
	S : out std_logic_vector(31 downto 0);
	N, Z, C, V : out std_logic
	);
end entity;

architecture Behavorial of ALUv3 is

	signal arithm_out : signed(32 downto 0);
	signal logic_out : std_logic_vector(31 downto 0);
	signal intA, intB, intS : integer;


begin	
	process(OP, A, B)		--arithmetic output
	begin
		case OP is
				when "000" => arithm_out <= ('0' & signed(A)) + ('0' & signed(B));
			when "010" => arithm_out <= ('0' & signed(A)) - ('0' & signed(B));
			when others => arithm_out <= (others => '-');
		end case;

		case OP is		--logic output
			when "001" => logic_out <= B;
			when "011" => logic_out <= A;
			when "100" => logic_out <= A or B;
			when "101" => logic_out <= A and B;
			when "110" => logic_out <= A xor B;
			when "111" => logic_out <= not A;
			when others => logic_out <= (others => '-');
		end case;
	end process;
	
	S <= std_logic_vector(arithm_out(31 downto 0)) when (OP = "000" or OP = "010") else
		logic_out;

	z <= '1' when ((OP = "000" or OP = "010") and arithm_out = "000000000000000000000000000000000") else
		'1' when (OP /= "000" and OP /= "010" and logic_out = "00000000000000000000000000000000") else
		'0';

	N <= arithm_out(31) when (OP = "000" or OP = "010") else
	logic_out(31);

	--probably not correct
--	C <= arithm_out(32) when (OP = "000" or OP = "010") else
--	'0';

	C <= '1' when ((OP = "000" and (to_integer(signed(A)) + to_integer(signed(B)) > 2**31-1)) or (OP = "010" and (to_integer(signed(A)) < to_integer(signed(B))))) else
	'0';
	--Or is it > 2**30-1 for addition ? -- needs testing

	V <= ( (not A(31)) and (not B(31)) and arithm_out(31) ) or ( A(31) and B(31) and (not arithm_out(31)) ) when (OP = "000" or OP = "010") else
	'0';

	intS <= (to_integer( arithm_out(31 downto 0))) when (OP = "000" or OP = "010") else
		to_integer(unsigned(logic_out));
	intA <= to_integer(signed(A));
	intB <= to_integer(signed(B));

end architecture Behavorial;

--		00000000000000000000000000000000
--		11111111111111111111111111111111