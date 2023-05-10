--******************************************************
-- TOP LEVEL:		SMDB Scrolling Message Data Board

-- Summary:
-- Switch 15 = hard reset 
-- Switch 14 = soft reset
-- KEY(3) = pause program
-- CLOCK_50 is sent to Prescale which sends out a global clock signal pseudoclk
-- if we pause the program, then pseudoclk's value is held and sent globally to all components
-- else pseudoclk goes to all components

-- **timeTemp is received by all components. TimeTemp equals pseudoclk's value when key(3) activated ELSE
-- TimeTemp equals pseudoclk

--******************************************************

LIBRARY IEEE;
USE IEEE.NUMERIC_STD.ALL;
USE IEEE.STD_LOGIC_1164.ALL;
use work.definitions_package.all;


ENTITY SMDB IS
PORT(CLOCK_50 : IN STD_LOGIC;
		SW : IN STD_LOGIC_VECTOR(17 DOWNTO 0);
		HEX0, HEX1, HEX2, HEX3, HEX4, HEX5, HEX6, HEX7 : OUT std_logic_vector(6 downto 0);
		LEDG : OUT std_logic_vector(7 downto 0);
		KEY : IN std_logic_vector(3 downto 0)	

 );											
		
END SMDB;

ARCHITECTURE Structure of SMDB is

--		signal I2C_SDAT, error : std_logic;
--		signal I2C_SCLK, AUD_XCK : std_logic;
--		signal AUD_ADCDAT : std_logic;
--		signal AUD_DACDAT : std_logic;
--		signal AUD_ADCLRCK, AUD_DACLRCK, AUD_BCLK : std_logic;

		COMPONENT PRESCALE IS
			port(		ClkIn : IN std_logic;
						ClkO : OUT STD_LOGIC;
						Speed : IN std_logic_vector(1 downto 0)
																				);
		END COMPONENT;

		COMPONENT debouncer 
			  generic ( timeout_cycles : positive);
			  port (
				 clk : in std_logic;
				 rst : in std_logic;
				 switch : in std_logic;
				 switch_debounced : out std_logic
																		);
		  end component;
		
		  
		COMPONENT ASIP IS
			PORT(		clk, rst, hard_rst, stop_prog : IN std_logic;
						program : IN std_logic_vector(3 downto 0);
						to_hex : OUT HexArr;
						PEC : OUT unsigned(3 downto 0)		);
		
		END COMPONENT;
		

	signal TimeWarp, TimeTemp, pseudoCLK : std_logic; -- our signal for the slowed clock
	signal SWDebounced : std_logic_vector(7 downto 0);
	signal HEXValues : HexArr;
	signal GreenLights : unsigned(3 downto 0);
	CONSTANT Latch40ms : positive := 2000000;
	
--	SIGNAL	AudioIn, AudioOut : signed(15 downto 0);
--	SIGNAL	SamClk : std_logic;
	
--	COMPONENT AudioInterface is
--	Generic ( SID : integer := 100 ); 
--	Port (CLOCK_50 : in std_logic;
--		init : in std_logic;
--
--		I2C_SDAT : inout std_logic;
--		I2C_SCLK, AudMclk : out std_logic;
--		AUD_ADCDAT : in std_logic;
--		AUD_DACDAT : out std_logic;
--		AUD_ADCLRCK, AUD_DACLRCK, AUD_BCLK : in std_logic;
--		
--		SamClk : out std_logic;
--		AudioIn : out signed(15 downto 0);
--		AudioOut : in signed(15 downto 0));
--	END COMPONENT;
--	
--	COMPONENT ToneGenerator is
--	PORT(
--					WaveOut : OUT signed(15 downto 0);
--					Freq : IN unsigned(15 downto 0);
--					clear, clock : IN std_logic	 			);
--	END COMPONENT;
BEGIN
	--SWDebounced <= (SW14Debounced&SW15Debounced&SW16Debounced&SW17Debounced);
	
	
	obj1: prescale
	PORT MAP(clkIn => clock_50, clkO => pseudoCLK, speed => SWDebounced(7 downto 6) ); --switches 17 and 16 control speed

	
	D1: Debouncer generic map (timeout_cycles => Latch40ms)
	PORT MAP(clk => clock_50, rst => SW(14), switch => SW(14), switch_debounced => SWDebounced(4));
	
	D2: Debouncer generic map (timeout_cycles => Latch40ms)
	PORT MAP(clk => clock_50, rst => SW(14), switch => SW(15), switch_debounced => SWDebounced(5));
	
	D3: Debouncer generic map (timeout_cycles => Latch40ms)
	PORT MAP(clk => clock_50, rst => SW(14), switch => SW(16), switch_debounced => SWDebounced(6));
	
	D4: Debouncer generic map (timeout_cycles => Latch40ms)
	PORT MAP(clk => clock_50, rst => SW(14), switch => SW(17), switch_debounced => SWDebounced(7));
	
	D5: Debouncer generic map (timeout_cycles => Latch40ms)
	PORT MAP(clk => clock_50, rst => SW(14), switch => SW(0), switch_debounced => SWDebounced(0));
	
	D6: Debouncer generic map (timeout_cycles => Latch40ms)
	PORT MAP(clk => clock_50, rst => SW(14), switch => SW(1), switch_debounced => SWDebounced(1));
	
	D7: Debouncer generic map (timeout_cycles => Latch40ms)
	PORT MAP(clk => clock_50, rst => SW(14), switch => SW(2), switch_debounced => SWDebounced(2));
	
	D8: Debouncer generic map (timeout_cycles => Latch40ms)
	PORT MAP(clk => clock_50, rst => SW(14), switch => SW(3), switch_debounced => SWDebounced(3));
	
	obj2: ASIP
	PORT MAP(clk => TimeWarp, hard_rst => SWDebounced(5), rst => SWDebounced(4), stop_prog => key(3), program => SWDebounced(3 downto 0), to_hex => HEXValues, PEC => GreenLights );
	
	
	--CLOCK FREEZE
	-- this will freeze the clock if stop_program is triggered
	-- if we hit pause ( KEY(3) activated) , the current clock value is latched and sent to
	-- all components so it looks like the clock "froze"
	-- when we let go of KEY(3), the global clock from prescaler is sent to everything again
	PROCESS(key(3), pseudoCLK)
	BEGIN
	
			if(key(3) = '0' and pseudoCLK <= '1') then --b/c keys are active LOW
				TimeTemp <= '1';
			elsif(key(3) = '0' and pseudoCLK <= '0') then
				TimeTemp <= '0';
			else
				TimeTemp <= pseudoCLK;
				NULL;
			
			end if;
	end PROCESS;

		LEDG(3 downto 0) <= std_logic_vector(GreenLights);
		TimeWarp <= TimeTemp;
	
		HEX0 <= HEXValues(0);
		HEX1 <= HEXValues(1);
		HEX2 <= HEXValues(2);
		HEX3 <= HEXValues(3);
		HEX4 <= HEXValues(4);
		HEX5 <= HEXValues(5);
		HEX6 <= HEXValues(6);
		HEX7 <= HEXValues(7);
	
--	assm: AudioInterface	generic map ( SID => 85064 )
--			PORT MAP( Clock_50 => CLOCK_50, AudMclk => AUD_XCK,	-- period is 80 ns ( 12.5 Mhz )
--						init => error, 									-- +ve edge initiates I2C data
--						I2C_Sclk => I2C_SCLK,
--						I2C_Sdat => I2C_SDAT,
--						AUD_BCLK => AUD_BCLK, AUD_ADCLRCK => AUD_ADCLRCK, AUD_DACLRCK => AUD_DACLRCK,
--						AUD_ADCDAT => AUD_ADCDAT, AUD_DACDAT => AUD_DACDAT,
--						AudioOut => AudioOut, AudioIn => AudioIn, SamClk => SamClk );
--			Tone: ToneGenerator port map(Freq => "0000011110000000", clear => error, clock => samclk, waveout => AudioOut);
--	error <= '0' when (SWDebounced /= "0000" or SWDebounced /= "1000" or SWDebounced /= "0100" or SWDebounced /= "0010" or SWDebounced /= "0001") else '1';
	
END Structure;