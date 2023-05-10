--******************************************************
-- 				 Prescaler
--Summary:
-- ClkIn is our clock signal that we want to slow
-- ClkO is our slowed ClkIn
-- Speed increases the slowness

--Switches 17 and 16 will control speed
-- switch 16 is fast
-- switch 17 is super fast

-- input clock is DE-112 FPGA's CLOCK_50 
-- we have a 25 bit number called prescale Factor
-- output clock is equal to prescale Factor's MSB (most significant bit)
-- fast is MSB-1
-- fastest is MSB-2
--******************************************************


LIBRARY ieee;
Use ieee.std_logic_1164.all;
USE ieee.numeric_std.all;


ENTITY PRESCALE IS
port(		ClkIn : IN std_logic;
			ClkO : OUT STD_LOGIC;
			Speed : IN std_logic_vector(1 downto 0)
																	);
END PRESCALE;


ARCHITECTURE Logic of PRESCALE IS

SIGNAL prescaleFactor : UNSIGNED(24 DOWNTO 0) :=(others => '0');
SIGNAL PlusOne :  UNSIGNED(24 DOWNTO 0) :=(1 => '1', others => '0');

BEGIN
	

		with Speed select ClkO <= 
			 std_logic(prescaleFactor(23) ) when "01", -- fast is selected
			 std_logic(prescaleFactor(22) ) when "10", -- super fast is selected
			 std_logic(prescaleFactor(24) ) when others;

		 PROCESS(clkIn)
		 begin
			if( RISING_EDGE(clkIn) ) then
				prescaleFactor <= prescaleFactor + plusOne;
			end if;
		end process;
		

		

end Logic;

