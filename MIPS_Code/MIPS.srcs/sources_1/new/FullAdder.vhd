-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : FullAdder
-- Module Name : FullAdder- behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Full Adder block
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity FullAdder is
    PORT(
        A    : IN  std_logic; 
        B    : IN  std_logic;
        Cin  : IN  std_logic;
        Sum  : OUT std_logic;
        Cout : OUT std_logic
        );
end FullAdder;

architecture behavioral of FullAdder is
begin

    Sum <= A xor B xor Cin;
    Cout <= (A and B) or (A and Cin) or (B and Cin);

end architecture behavioral;