-- SevenSeg.vhd
-- ------------------------------
--   squelette de l'encodeur sept segment
-- ------------------------------

--
-- Notes :
--  * We don't ask for an hexadecimal decoder, only 0..9
--  * outputs are active high if Pol='1'
--    else active low (Pol='0')
--  * Order is : Segout(1)=Seg_A, ... Segout(7)=Seg_G
--
--  * Display Layout :
--
--       A=Seg(1)
--      -----
--    F|     |B=Seg(2)
--     |  G  |
--      -----
--     |     |C=Seg(3)
--    E|     |
--      -----
--        D=Seg(4)


library IEEE;
	use IEEE.std_logic_1164.all;
	use IEEE.numeric_std.all;

-- ------------------------------
	Entity SEVEN_SEG is
-- ------------------------------
	port (
		Data   : in  std_logic_vector(3 downto 0); -- Expected within 0 .. 15
		Pol    : in  std_logic;                    -- '0' if active LOW
		Segout : out std_logic_vector(1 to 7) );   -- Segments A, B, C, D, E, F, G
end entity SEVEN_SEG;

-- -----------------------------------------------
	Architecture COMB of SEVEN_SEG is
-- ------------------------------------------------

	signal Seg_interne : std_logic_vector(1 to 7);

begin
	
Process(Data, Pol, Seg_interne)

	Begin

	case(Data) is
		when "0000" => Seg_interne <= "1111110";
		when "0001" => Seg_interne <= "0110000";
		when "0010" => Seg_interne <= "1101101";
		when "0011" => Seg_interne <= "1111001";
		when "0100" => Seg_interne <= "0110011";
		when "0101" => Seg_interne <= "1011011";
		when "0110" => Seg_interne <= "1011111";
		when "0111" => Seg_interne <= "1110000";
		when "1000" => Seg_interne <= "1111111";
		when "1001" => Seg_interne <= "1111011";
		when "1010" => Seg_interne <= "1111101";
		when "1011" => Seg_interne <= "0011111";
		when "1100" => Seg_interne <= "1001110";
		when "1101" => Seg_interne <= "0111101";
		when "1110" => Seg_interne <= "1001111";
		when "1111" => Seg_interne <= "1000111";
		when others => Seg_interne <= (others => '-');
		end case;
		
		if (Pol='1') then
			Segout <= Seg_interne;
		else
			Segout <= not(Seg_interne);
		end if;

End process;

--	Segout <= "1000000" when (Data = "0000" and pol = '0') else		--Sans process : trop de LE, aussi le sens des 7 segments est inversé
--		"1111001" when (Data = "0001" and pol = '0') else
--		"0100100" when (Data = "0010" and pol = '0') else
--		"0110000" when (Data = "0011" and pol = '0') else
--		"0011001" when (Data = "0100" and pol = '0') else
--		"0010010" when (Data = "0101" and pol = '0') else
--		"0000010" when (Data = "0110" and pol = '0') else
--		"1111000" when (Data = "0111" and pol = '0') else
--		"0000000" when (Data = "1000" and pol = '0') else
--		"0010000" when (Data = "1001" and pol = '0') else
--
--		not("1000000") when (Data = "0000" and pol = '1') else
--		not("1111001") when (Data = "0001" and pol = '1') else
--		not("0100100") when (Data = "0010" and pol = '1') else
--		not("0110000") when (Data = "0011" and pol = '1') else
--		not("0011001") when (Data = "0100" and pol = '1') else
--		not("0010010") when (Data = "0101" and pol = '1') else
--		not("0000010") when (Data = "0110" and pol = '1') else
--		not("1111000") when (Data = "0111" and pol = '1') else
--		not("0000000") when (Data = "1000" and pol = '1') else
--		not("0010000") when (Data = "1001" and pol = '1') else
--		"-------";

end architecture COMB;

