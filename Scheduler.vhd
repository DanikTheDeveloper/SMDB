--******************************************************
-- 				 		Scheduler
-- Summary:
-- input "program" details what program (and their corresponding ISA instructions) to run
-- For prog 3 Fly in a box and prog 4 MSG we have a hard coded array containing each program's 
-- instructions. If we activate prog 3 and prog 4 we read each instruction from array(0) to array(last instruction)

-- pce (= NOT pceTemp) is default to 1 for program not active
-- when a program is run it goes to zero
-- when a program ends it goes back to 1

-- we count PEC in Datapath when pce is a rising edge (aka program is running -> program successfully run)
-- NOTE pce in Scheduler DOES NOT EQUAl PEC in datapath
--******************************************************


Library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;


use work.definitions_package.all;

ENTITY scheduler is
	port( clk, rst, hard_rst, stop_prog : IN std_logic;
			program : IN std_logic_vector(3 downto 0);
			inst_out : OUT std_logic_vector(6 downto 0);
			pce : OUT std_logic			);
			
end entity scheduler;


ARCHITECTURE logic of scheduler is
	COMPONENT CONTROLUNIT IS 
	PORT( clk, rst, hard_rst : IN std_logic;
			inst : IN std_logic_vector(6 downto 0);
			toSeg : OUT CUSTOMArr								);
	END COMPONENT;
	
	signal instTemp : unsigned(6 downto 0); 
	signal pceTemp : std_logic := '0'; -- pce = '1' means program is running. pce = '0' means no program is running at the moment 
	signal errorflag : std_logic := '0'; --this helps us alternate between error msg and idle/no msg => error looks like it's flashing
	signal programTemp : std_logic_vector(3 downto 0); -- reads "program input" from entity and is held until a program stops/is reset
	signal counter : integer := 0; -- this is used to read the array index of fly in a box's data type flyArr
	signal counter1 : integer := 0; --this is used to read the JohnMayerArr index
	signal readJMArr : JohnMayerArr := ("1000000", "1001111", "1010000", "1010001", "1010010", "1010011", "1010100", "1010101", "1010110", "1010111", "1011000", "1011001", "1011010", "1011011", "1011100", "1011101");
	signal readflyArr : flyArr := ("1000001", "1000010", "1000011", "1000100", "1000001", "1000101", "1000110", "1000111", "1000001", "1001000", "1001001", "1001010", "1001011", "1001000", "1001100", "1001101", "1001110", "1001000", "1001000");
	-- these custom data types contain the hard coded instructions to produce the output
	
	BEGIN
	
	
	
	process(clk, rst, hard_rst, stop_prog, instTemp, programTemp, pceTemp)
	BEGIN
	--If we encounter a soft rest
		if( rst = '1') THEN
			instTemp <= "1111111";
			pceTemp <= '0';
	--If we encounter a hard reset
		elsif( hard_rst = '1') THEN
			instTemp <= "1111111";
			pceTemp <= '0';
	--if our program in is nothing, then display idle state (nothing on hex displays)
		elsif(rising_edge(clk) and programTemp = "0000") then
			instTemp <= "1111111";
	
	--PROGRAM 1:
	--snake R->L
		elsif(rising_edge(clk) and programTemp = "0001" and pceTemp = '0') then -- nothing is running and program 1 activated
			pceTemp <= '1';
			instTemp <= "0000001";
		elsif(rising_edge(clk) and programTemp = "0001" and pceTemp = '1') then -- if program 1 is running then keep going
			instTemp <= instTemp + "0000001";
		elsif(rising_edge(clk) and programTemp = "0001" and pceTemp = '1' and instTemp = "0011111") then -- if program 1 is running and it's last instruction is the last of program 1 then end program 1 and read next program to run
			pceTemp <= '0';
			programTemp <= "0000";
	----------- END OF PROGRAM 1
	
	--PROGRAM 2:
	-- SNAKE L->R
		elsif(rising_edge(clk) and programTemp = "0010" and pceTemp = '0') then -- nothing is running and program 2 activated
			pceTemp <= '1';
			instTemp <= "0100001";
		elsif(rising_edge(clk) and programTemp = "0010" and pceTemp = '1') then -- if program 2 running then keep going
			instTemp <= instTemp + "0000001";
		elsif(rising_edge(clk) and programTemp = "0010" and pceTemp = '1' and instTemp = "0111111") then -- if program 2 is running and last program 2 instruction is output then end program 2 and read next program to run
			pceTemp <= '0';
			programTemp <= "0000";
	----------- END OF PROGRAM 2
	
	--PROGRAM 3:
	-- FLY IN A BOX
		elsif(rising_edge(clk) and programTemp = "0100" and pceTemp = '0') then -- if nothing is running and program 3 activated then start prog 3
			counter <= 0;
			pceTemp <= '1';
		elsif(programTemp = "0100" and counter = 17) then -- if program 3's last instruction is output then end program 3 and read next program to run
			pceTemp <= '0';
			counter <= 0;
		elsif(rising_edge(clk) and programTemp = "0100") then -- if program 3 is running then read next FlyArray index with counter
			pceTemp <= '1';
			counter <= counter + 1;
	----------- END OF PROGRAM 3
	

	--PROGRAM 4:
	-- MESSAGE
		elsif(rising_edge(clk) and programTemp = "1000" and pceTemp = '0') then -- if nothing is running and program 4 activated then start prog 4
			counter1 <= 0;
			pceTemp <= '1';
		elsif(rising_edge(clk) and programTemp = "1000" and counter1 = 15) then -- if program 4's last instruction is output then end prog 4 and read next prog to run
			pceTemp <= '0';
		elsif(rising_edge(clk) and programTemp = "1000") then -- if prog 4 is running then read next array index with counter1
			pceTemp <= '1';
			counter1 <= counter1 + 1;
	----------- END OF PROGRAM 4
		
	--FLASHING ERROR MSG
	-- triggers if our program requested is something other than program 1-4 or "no program selected"
		elsif(rising_edge(clk) and (program /= "0000" or program /= "1000" or program /= "0100" or program /= "0010" or program /= "0001") and errorflag = '0') then
			instTemp <= "1011110";
			errorflag <= '1';
		elsif(rising_edge(clk) and (program /= "0000" or program /= "1000" or program /= "0100" or program /= "0010" or program /= "0001") and errorflag = '1') then
			instTemp <= "1111111";
			errorflag <= '0';
	----------- END OF FLASHING ERROR MSG
	
	end if;
	
	--If a program is not running (pceTemp = '0') then we read from the user again
		if(pceTemp = '0') then
			programTemp <= program;
		end if;
	
	-- conditional statements for our output instructions
		if(programTemp = "0100" and pceTemp = '1') then
			instTemp <= readflyArr(counter);
		elsif(programTemp = "1000" and pceTemp = '1') then
			instTemp <= readJMArr(counter1);
		end if;
	
		inst_out <= std_logic_vector(instTemp);
		PCE <= not pceTemp;

	
	END PROCESS;

	
end logic;