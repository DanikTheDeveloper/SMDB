--******************************************************
-- 				 		Definitions Package
--Summary:
-- we have four custom arrays
-- 1) CUSTOMArr
--			holds 5 bit stdlogic vectors in 8 columns. Used for holding ISA instructions

-- 2) flyArr
--			Holds our fly program ISA instructions. 7 bit stdlogic vectors in 19 columns

-- 3) JohnMayerArr
--			Holds our MSG program ISA instructions. 16 columns each carrying 7 bit stdlogic vectors

-- 4) HexArr
--			Used to carry data from the IO_controller to HEX outputs
--			8 columns (one per HEX). Each column has a 7 bit decoded number specifying which
--			HEX display LEDs to light up

--******************************************************


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;

package definitions_package is
-- Package Declaration Section (examples below)
TYPE CUSTOMArr IS ARRAY (0 to 7) OF STD_LOGIC_VECTOR(4 DOWNTO 0);
TYPE flyArr IS array (0 to 18) of unsigned(6 downto 0);
TYPE JohnMayerArr is array (0 to 15) of unsigned(6 downto 0);
TYPE HexArr is array(0 to 7) of std_logic_vector(6 downto 0); -- has 8 columns, one per hex. Each column has a 6bit DECODED hex symbol for Y0, ....Y6


end package definitions_package;



package body definitions_package is



end package body definitions_package;
