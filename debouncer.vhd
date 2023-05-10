--******************************************************
-- 				 Debouncer
--Summary:
-- our input mechanical switches are debounced here
-- input is a switch, output is a debounced switch
-- the larger the timeout cycle the longer the switch has to be 
-- ON without interruption to be read as "valid"
-- larger timeout_cycles increases the chance of a correct input,
-- but you have to wait more clock cycles for an output
--******************************************************


library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity debouncer is
  generic ( timeout_cycles : positive);
  port (
    clk : in std_logic;
    rst : in std_logic;
    switch : in std_logic;
    switch_debounced : out std_logic
  );
end debouncer; 

architecture rtl of debouncer is

  signal debounced : std_logic;
  signal counter : integer range 0 to timeout_cycles - 1;

begin

  -- Copy internal signal to output
  switch_debounced <= debounced;

  DEBOUNCE_PROC : process(clk)
  begin
    if rising_edge(clk) then
      if rst = '1' then
        counter <= 0;
        debounced <= switch;
        
      else
        
        if counter < timeout_cycles - 1 then
          counter <= counter + 1;
        elsif switch /= debounced then
          counter <= 0;
          debounced <= switch;
        end if;

      end if;
    end if;
  end process;

end architecture;