--******************************************************
-- 				 		ASIP
-- Summary:
-- this has a datapath, controlUnit, and IO_Controller
-- data goes from datapath, to control unit, to IOController (which has 7segmentDecoders)
-- the output of ASIP can go directly to HEX displays

--******************************************************

LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
use work.definitions_package.all;

ENTITY ASIP IS
PORT(		clk, rst, hard_rst, stop_prog : IN std_logic;
			program : IN std_logic_vector(3 downto 0);
			to_hex : OUT HexArr;
			PEC : OUT unsigned(3 downto 0)		);

END ASIP;


ARCHITECTURE Structure of ASIP is

		COMPONENT Datapath is
			port( clk, rst, hard_rst, stop_prog : IN std_logic;
					program : IN std_logic_vector(3 downto 0);
					inst_out : OUT std_logic_vector(6 downto 0);
					PEC : OUT unsigned(3 downto 0)			);
		end component;
		
		COMPONENT ControlUnit IS 
			PORT( clk, rst, hard_rst : IN std_logic;
					inst : IN std_logic_vector(6 downto 0);
					toSeg : OUT CUSTOMArr			);
		END COMPONENT;
		
		COMPONENT IO_controller IS
			PORT(toSeg : IN CUSTOMArr;
					toHex : OUT HexArr		);
		END COMPONENT;


	SIGNAL inst_out_TEMP : std_logic_vector(6 downto 0);
	SIGNAL CU_to_IO : CUSTOMArr;
	SIGNAL HEXSymbols : HexArr;
	SIGNAL PEC_TEMP : unsigned(3 downto 0);

BEGIN 
	
	OBJ1: Datapath
	PORT MAP(clk => clk, rst => rst, hard_rst => hard_rst, stop_prog => stop_prog, program => program, inst_out => inst_out_TEMP, PEC => PEC_TEMP);
	
	OBJ2: ControlUnit 
	PORT MAP(clk => clk, rst => rst, hard_rst => hard_rst, inst => inst_out_TEMP, toSeg => CU_to_IO);
	
	OBJ3: IO_controller
	PORT MAP(toSeg => CU_to_IO, toHex => HEXSymbols);
	--toHex(0) goes to HEX(0)... etc.
	
	
	PEC <= PEC_TEMP;
	to_Hex <= HEXSymbols;

END Structure;