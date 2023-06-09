--******************************************************
-- 				 Control Unit
--Summary:
-- This component recieves one instruction per clock cycle
-- based on received instruction, this will output a 40 bit value - 5 bits per HEX display
-- the 40 bits are broken into 5 bit buses per HEX display (8 HEX displays total)
-- these 5bit buses * 8 HEXs are put into a custom data type CUSTOMArr 
-- CUSTOMArr is data type 8 columns, std_logic_vector(4 downto 0) stored per column
--
-- This component contains ALL possible instructions that can possibly show up in our final project.
--Numbering is like ISA. When an instruction is repeated, I will indicate it being repeated with a comment
-- numbering will continue as usual after the repeated instruction.
--******************************************************


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


use work.definitions_package.all;

ENTITY ControlUnit IS 
	PORT( clk, rst, hard_rst : IN std_logic;
			inst : IN std_logic_vector(6 downto 0);
			toSeg : OUT CUSTOMArr								);
END ENTITY ControlUnit;

ARCHITECTURE logic of ControlUnit IS
signal ISA : CUSTOMArr;



begin

with inst select
--EVERY POSSIBLE INSTRUCTION IN MESSAGE SCROLLING BOARD BELOW

	--Start of snake R->L
		ISA <= 
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "00001") when "0000001", --1
		("00000", "00000", "00000", "00000", "00000", "00000", "00001", "00011") when "0000010", --2
		("00000", "00000", "00000", "00000", "00000", "00001", "00011", "00011") when "0000011", --3
		("00000", "00000", "00000", "00000", "00001", "00010", "00011", "00011") when "0000100", --4
		("00000", "00000", "00000", "00000", "00001", "00011", "00010", "00011") when "0000101", --5
		("00000", "00000", "00000", "00000", "00001", "00011", "00011", "00010") when "0000110", --6
		("00000", "00000", "00000", "00000", "00001", "00011", "00011", "00100") when "0000111", --7
		("00000", "00000", "00000", "00001", "00010", "00011", "00011", "00100") when "0001000", --8
		("00000", "00000", "00000", "00001", "00011", "00010", "00011", "00100") when "0001001", --9
		("00000", "00000", "00000", "00001", "00011", "00011", "00010", "00100") when "0001010", --10
		("00000", "00000", "00000", "00001", "00011", "00011", "00100", "00000") when "0001011", --11
		("00000", "00000", "00001", "00010", "00011", "00011", "00100", "00000") when "0001100", --12
		("00000", "00000", "00001", "00011", "00010", "00011", "00100", "00000") when "0001101", --13
		("00000", "00000", "00001", "00011", "00011", "00010", "00100", "00000") when "0001110", --14
		("00000", "00000", "00001", "00011", "00011", "00100", "00000", "00000") when "0001111", --15
		("00000", "00001", "00010", "00011", "00011", "00100", "00000", "00000") when "0010000", --16
		("00000", "00001", "00011", "00010", "00011", "00100", "00000", "00000") when "0010001",
		("00000", "00001", "00011", "00011", "00010", "00100", "00000", "00000") when "0010010",
		("00000", "00001", "00011", "00011", "00100", "00000", "00000", "00000") when "0010011",
		("00001", "00010", "00011", "00011", "00100", "00000", "00000", "00000") when "0010100", --20
		("00001", "00011", "00010", "00011", "00100", "00000", "00000", "00000") when "0010101",
		("00001", "00011", "00011", "00010", "00100", "00000", "00000", "00000") when "0010110",
		("00001", "00011", "00011", "00100", "00000", "00000", "00000", "00000") when "0010111", --23
		("00010", "00011", "00011", "00100", "00000", "00000", "00000", "00000") when "0011000",
		("00011", "00010", "00011", "00100", "00000", "00000", "00000", "00000") when "0011001",
		("00011", "00011", "00010", "00100", "00000", "00000", "00000", "00000") when "0011010",
		("00011", "00011", "00100", "00000", "00000", "00000", "00000", "00000") when "0011011", --27
		("00010", "00011", "00100", "00000", "00000", "00000", "00000", "00000") when "0011100",
		("00011", "00010", "00100", "00000", "00000", "00000", "00000", "00000") when "0011101",
		("00011", "00100", "00000", "00000", "00000", "00000", "00000", "00000") when "0011110", --30
		("00010", "00100", "00000", "00000", "00000", "00000", "00000", "00000") when "0011111", --31
		("00100", "00000", "00000", "00000", "00000", "00000", "00000", "00000") when "0100000", --32
	-- end of snake R->L
	
	--start of snake L->R
		("00101", "00000", "00000", "00000", "00000", "00000", "00000", "00000") when "0100001",--33
		("00011", "00101", "00000", "00000", "00000", "00000", "00000", "00000") when "0100010",
		("00011", "00011", "00101", "00000", "00000", "00000", "00000", "00000") when "0100011",--35
		("00011", "00011", "00010", "00101", "00000", "00000", "00000", "00000") when "0100100",
		("00101", "00010", "00011", "00101", "00000", "00000", "00000", "00000") when "0100101",
		("00010", "00011", "00011", "00101", "00000", "00000", "00000", "00000") when "0100110",
		("00110", "00011", "00011", "00101", "00000", "00000", "00000", "00000") when "0100111",--39
		("00110", "00011", "00011", "00010", "00101", "00000", "00000", "00000") when "0101000",--40
		("00110", "00011", "00010", "00011", "00101", "00000", "00000", "00000") when "0101001",
		("00110", "00010", "00011", "00011", "00101", "00000", "00000", "00000") when "0101010",
		("00000", "00110", "00011", "00011", "00101", "00000", "00000", "00000") when "0101011",
		("00000", "00110", "00011", "00011", "00010", "00101", "00000", "00000") when "0101100",
		("00000", "00110", "00011", "00010", "00011", "00101", "00000", "00000") when "0101101",--45
		("00000", "00110", "00010", "00011", "00011", "00101", "00000", "00000") when "0101110",
		("00000", "00000", "00110", "00011", "00011", "00101", "00000", "00000") when "0101111",
		("00000", "00000", "00110", "00011", "00011", "00010", "00101", "00000") when "0110000",
		("00000", "00000", "00110", "00011", "00010", "00011", "00101", "00000") when "0110001",
		("00000", "00000", "00110", "00010", "00011", "00011", "00101", "00000") when "0110010",--50
		("00000", "00000", "00000", "00110", "00011", "00011", "00101", "00000") when "0110011",
		("00000", "00000", "00000", "00110", "00011", "00011", "00010", "00101") when "0110100",
		("00000", "00000", "00000", "00110", "00011", "00010", "00011", "00101") when "0110101",
		("00000", "00000", "00000", "00110", "00010", "00011", "00011", "00101") when "0110110",
		("00000", "00000", "00000", "00000", "00110", "00011", "00011", "00101") when "0110111",--55
		("00000", "00000", "00000", "00000", "00110", "00011", "00011", "00010") when "0111000",
		("00000", "00000", "00000", "00000", "00110", "00011", "00010", "00011") when "0111001",
		("00000", "00000", "00000", "00000", "00110", "00010", "00011", "00011") when "0111010",
		("00000", "00000", "00000", "00000", "00000", "00110", "00011", "00011") when "0111011",
		("00000", "00000", "00000", "00000", "00000", "00110", "00011", "00010") when "0111100",--60
		("00000", "00000", "00000", "00000", "00000", "00110", "00010", "00011") when "0111101",
		("00000", "00000", "00000", "00000", "00000", "00000", "00110", "00011") when "0111110",
		("00000", "00000", "00000", "00000", "00000", "00000", "00110", "00010") when "0111111",-- 63
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "00110") when "1000000",-- 64
	-- end of snake L->R
	
	--start of fly in a box
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "00111") when "1000001", -- 65
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "01000") when "1000010", -- 66
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "01001") when "1000011", -- 67
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "01010") when "1000100", -- 68
	 --("00000", "00000", "00000", "00000", "00000", "00000", "00000", "00111") when "1000001", -- REPEAT 65
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "01011") when "1000101", -- 69 
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "00010") when "1000110",
		("00000", "00000", "00000", "00000", "00000", "00000", "00000", "01100") when "1000111", --71
	 --("00000", "00000", "00000", "00000", "00000", "00000", "00000", "00111") when "1000001", --REPEAT 65
		("00000", "00000", "00000", "00000", "00000", "00000", "00111", "00000") when "1001000", -- 72
		("00000", "00000", "00000", "00000", "00000", "00000", "01000", "00000") when "1001001", 
		("00000", "00000", "00000", "00000", "00000", "00000", "01001", "00000") when "1001010",
		("00000", "00000", "00000", "00000", "00000", "00000", "01010", "00000") when "1001011", --75
	 --("00000", "00000", "00000", "00000", "00000", "00000", "00111", "00000") when "1001000", --REPEAT 72
		("00000", "00000", "00000", "00000", "00000", "00000", "01011", "00000") when "1001100", --76
		("00000", "00000", "00000", "00000", "00000", "00000", "00010", "00000") when "1001101",
		("00000", "00000", "00000", "00000", "00000", "00000", "01100", "00000") when "1001110", --78
	 --("00000", "00000", "00000", "00000", "00000", "00000", "00111", "00000") when "1001000", --REPEAT 72
	--END OF FLY IN A BOX
	
	--START OF MESSAGE
	 --("00000", "00000", "00000", "00000", "00000", "00000", "00000", "00110") when "1000000", --REPEAT 64
		("00000", "00000", "00000", "00000", "00000", "00000", "00110", "01101") when "1001111", --79
		("00000", "00000", "00000", "00000", "00000", "00110", "01101", "01110") when "1010000",
		("00000", "00000", "00000", "00000", "00110", "01101", "01110", "00011") when "1010001", --81 
		("00000", "00000", "00000", "00110", "01101", "01110", "00011", "00000") when "1010010",
		("00000", "00110", "01101", "01110", "00011", "00000", "00011", "00011") when "1010011", --83
		("00110", "01101", "01110", "00011", "00000", "00011", "00011", "01111") when "1010100", --84
		("01101", "01110", "00011", "00000", "00011", "00011", "01111", "10000") when "1010101", --85
		("01110", "00011", "00000", "00011", "00011", "01111", "10000", "10001") when "1010110",
		("00011", "00000", "00011", "00011", "01111", "10000", "10001", "10010") when "1010111", --87
		("00000", "00011", "00011", "01111", "10000", "10001", "10010", "00000") when "1011000", --88
		("00011", "00011", "01111", "10000", "10001", "10010", "00000", "00000") when "1011001", -- 89
		("01111", "10000", "10001", "10010", "00000", "00000", "00000", "00000") when "1011010", -- 90
		("10000", "10001", "10010", "00000", "00000", "00000", "00000", "00000") when "1011011", -- 91
		("10001", "10010", "00000", "00000", "00000", "00000", "00000", "00000") when "1011100", --92
		("10010", "00000", "00000", "00000", "00000", "00000", "00000", "00000") when "1011101", --93
	--end of MSG

	--general multi-purpose instructions
	 ("00000", "00000", "00000", "10001", "10010", "10010", "01101", "10010") when "1011110", -- 94 ERROR MSG
	 ("00000", "00000", "00000", "00000", "00000", "00000", "00000", "00000") when OTHERS; -- IDLE state

	-- END OF ALL INSTRUCTIONS POSSIBLE

	toseg <= ISA;	


end architecture logic;