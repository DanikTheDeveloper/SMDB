--***********************************************************************************************
--												Datapath
 
-- this is the same as a scheduler but it has a PEC bit that can be modified. 

--******PEC IMPORTANT INFORMATION
-- the PEC counts the number of programs that have successfully run
-- here, the PEC from scheduler is manipulated such that if hard_rst is input we reset PEC to "0000"
-- otherwise, PEC <= PEC+1 for every successful program run by scheduler

--NOTE: datapath is the same as a scheduler. The only difference is that we manipluate PEC in 
-- datapath, NOT scheduler.
--***********************************************************************************************

Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.definitions_package.all;

ENTITY Datapath is
	port( clk, rst, hard_rst, stop_prog : IN std_logic;
			program : IN std_logic_vector(3 downto 0);
			inst_out : OUT std_logic_vector(6 downto 0);
			PEC : OUT unsigned(3 downto 0)			);

end entity datapath;


ARCHITECTURE logic of datapath is

		
	component scheduler is
		port( clk, rst, hard_rst, stop_prog : IN std_logic;
				program : IN std_logic_vector(3 downto 0);
				inst_out : OUT std_logic_vector(6 downto 0);
				pce : OUT std_logic			);
	end component;

	
	signal numProg : unsigned(3 downto 0) := "0000"; --numPrograms (PEC) can only go to 15 before it goes back to zero
	signal pceTransfer : std_logic;

BEGIN
SchedulerInstantiated: scheduler PORT MAP( clk => clk, rst => rst, hard_rst => hard_rst, stop_prog => stop_prog, program => program, inst_out => inst_out, pce => pceTransfer);


	PROCESS(pceTransfer, hard_rst, clk)
		begin
		--pceTransfer is from pce of scheduler. pceTransfer tells us when a program has run completely!
			if( hard_rst = '1') then
				numProg <= "0000";
			elsif(rising_edge(pceTransfer) and rst = '0') then
				numProg <= numProg + 1;
			end if;
	end process;
	
	
	PEC <= numProg;



	
end logic;