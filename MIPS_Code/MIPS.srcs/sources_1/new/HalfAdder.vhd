-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : HalfAdder
-- Module Name : HalfAdder - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Half Adder block
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity HalfAdder is
    PORT(
        A    : IN  std_logic; 
        B    : IN  std_logic;
        Sum  : OUT std_logic;
        Cout : OUT std_logic
        );
end HalfAdder;

architecture behavioral of HalfAdder is
begin

    Sum <= A xor B;
    Cout <= A and B;

end architecture behavioral;