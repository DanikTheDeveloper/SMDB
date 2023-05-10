--MOST RECENT
--												Summary
-- when we hit clear='0' (active low) we reset the input to Freq
-- however, once we have an input Freq for the registers every clock cycle they add 1 to the input waveform


--clear (active low = '0') sends loads input frequency into the register
-- Freq is the frequency of our sound. This sound is accumulated and output


LIBRARY ieee;
USE ieee.std_logic_1164.all;
USE ieee.numeric_std.all;



ENTITY ToneGenerator is
	PORT(
		WaveOut : OUT signed(15 downto 0);
		Freq : IN unsigned(15 downto 0);
		clear, clock : IN std_logic	 );
END ToneGenerator;


ARCHITECTURE Structural of ToneGenerator is

SIGNAL Reg : signed(21 downto 0);
SIGNAL temp: signed(21 downto 0) := (others => '0');


BEGIN

PROCESS(clock, clear, Reg)
BEGIN
IF(Rising_Edge(clock) ) THEN
  if clear = '0' THEN
     temp <= (others => '0'); --clear plus risingedge = synchronous
  else
    temp <= temp + signed("000000" & Freq);
	end if;
	end if;
end process;


WaveOut <= temp(21 downto 6);
	
END Structural;
