LIBRARY ieee;
  USE ieee.std_logic_1164.ALL;
  USE ieee.numeric_std.ALL;

entity ALUv3_tb is
end;

architecture TEST of ALUv3_tb is

signal OP : std_logic_vector(2 downto 0);
signal A, B : std_logic_vector(31 downto 0);
signal S : std_logic_vector(31 downto 0);
signal N, Z, C, V : std_logic;

begin

-- Unit Under Test instanciation
UUT : entity work.ALUv3
port map ( 
    OP => OP,
    A => A,
    B => B,
    S => S,
    N => N,
    Z => Z,
    C => C,
    V => V);

-- Control Simulation and check outputs
process begin

  --no idea if it's correct
  OP <= "000";
  A <= "00000000000000000000000000000001";
  B <= "00000000000000000000000000000011";
  wait for 100 ns;

  OP <= "001";
  wait for 100 ns;
  OP <= "010";
  wait for 100 ns;
  OP <= "011";
  wait for 100 ns;

  OP <= "000";
  A <= "01000000000000000000000000000001";
  B <= "01000000000000000000000000000011";
  wait for 100 ns;

  OP <= "010";
  wait for 100 ns;

  OP <= "000";
  A <= "10000000000000000000000000000001";
  B <= "10000000000000000000000000000011";
  wait for 100 ns;

  OP <= "010";
  wait for 100 ns;


  wait;
end process;

end;