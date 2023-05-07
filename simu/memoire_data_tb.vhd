LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity memoire_data_tb is
end;

architecture TEST of memoire_data_tb is

signal clk, reset, WrEn : std_logic;
signal DataIn, DataOut : std_logic_vector(31 downto 0);
signal Addr : std_logic_vector(5 downto 0);

begin

-- Unit Under Test instanciation
UUT : entity work.memoire_data
port map ( 
    clk => clk,
    reset => reset,
    WrEn => WrEn,
    DataIn => DataIn,
    DataOut => DataOut,
    Addr => Addr
    );

CLOCK: process
  begin
    while now <= 200 NS loop
      clk <= '0';
      wait for 5 NS;
      clk <= '1';
      wait for 5 NS;
    end loop;
    wait;
  end process;

-- Control Simulation and check outputs
process begin
  reset <= '1';
  WrEn <= '0';
  DataIn <= "01010101010101010101010101010101";
  Addr <= "000000";
  
  wait for 20 ns;
  reset <= '0';
  Addr <= "000001";
  
  wait for 20 ns;
  WrEn <= '1';
  Addr <= "000010";

  wait for 20 ns;
  DataIn <= "11111111111111111111111111111111";
  Addr <= "000011";

  wait for 20 ns;
  Addr <= "000100";

  wait for 20 ns;
  DataIn <= "00001111000011110000111100001111";
  Addr <= "000011";

  wait;
end process;

end;