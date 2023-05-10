--******************************************************
-- 				 	IO Controller
--Summary:
-- Recieves instructions from the Control Unit
-- Custom 7 Segment decoder decodes incoming instructions
-- Ouptut is a series of HEX Display instructions, each 7 bits stdlogic 
-- Our output is toHex, a HexArr data type, which has 
-- 8 columns (one column sent to one HEX display) with 7 bit stdlogic vectors
-- within each column

--******************************************************
LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;

use work.definitions_package.all;

ENTITY IO_controller IS
	PORT(toSeg : IN CUSTOMArr;
			toHex : OUT HexArr);
END IO_controller;


ARCHITECTURE Structure of IO_controller is
	
	
	COMPONENT Custom7Seg IS
	PORT(D : IN std_logic_vector(4 DOWNTO 0);
		Y : OUT std_logic_vector(6 downto 0));
	END COMPONENT;

	
BEGIN

--CUSTOMArray(0) is for Hex8, CUSTOMArray(1) is for Hex7, 
-- We'll switch toHex such that:
-- 					toHex(0) => HEX(0)
		obj1: Custom7Seg
		PORT MAP(D => toSeg(0), Y => toHex(7));
		obj2: Custom7Seg
		PORT MAP(D => toSeg(1), Y => toHex(6));
		obj3: Custom7Seg
		PORT MAP(D => toSeg(2), Y => toHex(5));
		obj4: Custom7Seg
		PORT MAP(D => toSeg(3), Y => toHex(4));
		obj5: Custom7Seg
		PORT MAP(D => toSeg(4), Y => toHex(3));
		obj6: Custom7Seg
		PORT MAP(D => toSeg(5), Y => toHex(2));
		obj7: Custom7Seg
		PORT MAP(D => toSeg(6), Y => toHex(1));
		obj8: Custom7Seg
		PORT MAP(D => toSeg(7), Y => toHex(0));

END Structure;