LIBRARY ieee;
	USE ieee.std_logic_1164.ALL;
	USE ieee.numeric_std.ALL;

entity Decod_7_Seg is
	Port (
		RESET : in STD_LOGIC;
		OUT_4 : in STD_LOGIC_VECTOR (3 downto 0);
		OUT_7 : out Std_Logic_Vector( 6 downto 0)
		);
end Decod_7_Seg;

architecture Behavioral of Decod_7_SegNew is


--TODO : 
	--verify the MSB/LSB order
	--verify the polarity
	--add the rest of the characters : a,b,c,d,e,f

begin
OUT_4 : process (OUT_4, RESET)
	begin
	if (RESET ='1') then
		OUT_7 <= "1111111";
	else
	case OUT_4 is
		when "0000" => OUT_7 <= "1000000";  --0
		when "0001" => OUT_7 <= "1111001";  --1
		when "0010" => OUT_7 <= "0100100";  --2
		when "0011" => OUT_7 <= "0110000";  --3
		when "0100" => OUT_7 <= "0011001";  --4
		when "0101" => OUT_7 <= "0010010";  --5
		when "0110" => OUT_7 <= "0000010";  --6
		when "0111" => OUT_7 <= "1111000";  --7
		when "1000" => OUT_7 <= "0000000";  --8
		when "1001" => OUT_7 <= "0010000";  --9
		when "1011" => OUT_7 <= "0111111";  -- -
		when others => OUT_7 <= "1111111";
	end case;
	end if;
 end process OUT_4;

end Behavioral;
