LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity registers_tb is
end;

architecture TEST of registers_tb is

signal clk, reset, WE : std_logic;
signal W : std_logic_vector(31 downto 0);
signal RA, RB, RW : std_logic_vector(3 downto 0);
signal A, B : std_logic_vector(31 downto 0);

begin

-- Unit Under Test instanciation
UUT : entity work.registers
port map ( 
    clk => clk,
    reset => reset,
    WE => WE,
    W => W,
    RA => RA,
    RB => RB,
    RW => RW,
    A => A,
    B => B);

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
  WE <= '0';
  W <= "01010101010101010101010101010101";
  RA <= "0000";
  RB <= "0001";
  RW <= "0010";
  
  wait for 20 ns;
  reset <= '0';
  RA <= "0010";
  
  wait for 20 ns;
  WE <= '1';

  wait for 20 ns;
  RW <= "0001";

  wait for 20 ns;
  WE <= '0';

  wait for 20 ns;
  RA <= "1111";

  wait for 20 ns;
  reset <= '1';

  wait;
end process;

end;