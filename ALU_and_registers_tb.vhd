LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity ALU_and_registers_tb is
end;

architecture TEST of ALU_and_registers_tb is

signal clk, reset, WE, N, Z, C, V : std_logic;
signal busA, busB, busW : std_logic_vector(31 downto 0);
signal RA, RB, RW : std_logic_vector(3 downto 0);
signal OP : std_logic_vector(2 downto 0);

begin

-- Unit Under Test instanciation
reg : entity work.registers
port map ( 
    clk => clk,
    reset => reset,
    WE => WE,
    W => busW,
    RA => RA,
    RB => RB,
    RW => RW,
    A => busA,
    B => busB);

alu : entity work.ALUv3
port map ( 
    OP => OP,
    A => busA,
    B => busB,
    S => busW,
    N => N,
    Z => Z,
    C => C,
    V => V);

CLOCK: process
  begin
    while now <= 110 NS loop
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
  RA <= "0001";
  RB <= "0010";
  RW <= "0000";
  OP <= "000";
  WE <= '0';

  wait for 20 ns;

  reset <= '0';
  WE <= '1';
  OP <= "011";
  RA <= "1111";
  RB <= "0000";
  RW <= "0001";

  wait for 20 ns;

  OP <= "000";
  RA <= "0001";
  RB <= "1111";
  RW <= "0001";

  wait for 20 ns;

--  OP <= "000";
--  RA <= "0001";
--  RB <= "1111";
  RW <= "0010";

  wait for 20 ns;

  OP <= "010";
--  RA <= "0001";
--  RB <= "1111";
  RW <= "0011";

  wait for 20 ns;

--  OP <= "010";
  RA <= "0111";
--  RB <= "1111";
  RW <= "0101";

  wait;
end process;

end;