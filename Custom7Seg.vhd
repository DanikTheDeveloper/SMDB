--******************************************************
-- 				 Custom 7 Segment Decoder
--Summary:
-- we have 19 symbols to represent, therefore log2(19) = 5 bits needed to encode
-- Our input is a 5 bit number
-- our output is a 7 bit number. 7 bits for Y6 to Y0 of the HEX display

--******************************************************
LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
ENTITY Custom7Seg IS
PORT(D : IN std_logic_vector(4 DOWNTO 0);
		Y : OUT std_logic_vector(6 downto 0));
END Custom7Seg;
ARCHITECTURE Structure of Custom7Seg is
BEGIN
PROCESS(D)
BEGIN
	CASE D IS
		WHEN "00001" =>
			Y <= "1111000";--"7"
		WHEN "00010" =>
			Y <= "1110111";--"_"
		WHEN "00011" =>
			Y <= "1001000";--"П"
		WHEN "00100" =>
			Y <= "1000111";--"L"
		WHEN "00101" =>
			Y <= "1001110";--"Г snake head"
		WHEN "00110" =>
			Y <= "1110001";--"RevL"
		WHEN "00111" =>
			Y <= "0111111";--"Y6"
		WHEN "01000" =>
			Y <= "1011111";--"Y5"
		WHEN "01001" =>
			Y <= "1111110";--"Y0"
		WHEN "01010" =>
			Y <= "1111101";--"Y1"
		WHEN "01011" =>
			Y <= "1101111";--"Y4"
		WHEN "01100" =>
			Y <= "1111011";--"Y2"
		WHEN "01101" =>
			Y <= "0100011";--"o"
		WHEN "01110" =>
			Y <= "0001011";--"h"
		WHEN "01111" =>
			Y <= "0001000";--"A"
		WHEN "10000" =>
			Y <= "0010001";--"y"
		WHEN "10001" =>
			Y <= "0000110";--"E"
		when "10010" =>
			Y <= "0101111"; -- "lowercase r"
		WHEN others =>
			Y <= "1111111";--"NULL"
	END CASE;
END PROCESS;
END Structure;