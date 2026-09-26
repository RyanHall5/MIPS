-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Instruction_Memory
-- Module Name : Instruction_Memory - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Holds all of the instructions for program execution.
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Instruction_Memory is
    PORT(
        addr  : in unsigned(31 downto 0);           -- Address in memory to read from
        d_out : out std_logic_vector(31 downto 0)   -- Value contained at addr in memory
    );
end Instruction_Memory;

architecture behavioral of Instruction_Memory is

    -- 256 word capacity storage (256 instructions)
    type memory_type is array (0 to 255) of std_logic_vector(31 downto 0);

    -- Instruction Memory
    constant memory : memory_type := (
        0 => X"20010002", -- ADDI R1, $0, 2
        1 => X"20020002", -- Outer: ADDI R2, $0, 2
        2 => X"00222822", -- Inner: SUB R5, R1, R2
        3 => X"18A0000A", -- BLEZ R5, Prime
        4 => X"00201820", -- ADD R3, R1, $0
        5 => X"00432822", -- ModLoop: SUB R5, R2, R3
        6 => X"1CA00002", -- BGTZ R5, ModDone
        7 => X"00621822", -- SUB R3, R3, R2
        8 => X"1000FFFC", -- BEQ $0,$0, ModLoop
        9 => X"10600002", -- ModDone: BEQ R3,$0, NotPrime
        10 => X"20420001", -- ADDI R2, R2, 1
        11 => X"1000FFF6", -- BEQ $0,$0, Inner
        12 => X"20210001", -- NotPrime: ADDI R1, R1, 1
        13 => X"1000FFF3", -- BEQ $0,$0, Outer
        14 => X"AC0103FF", -- Prime: SW R1, 1023($0)
        15 => X"20210001", -- ADDI R1, R1, 1
        16 => X"1000FFF0", -- BEQ $0,$0, Outer
            others => X"00000000" -- placeholder values
    );
begin
    -- Value at addr
    d_out <= memory(to_integer(addr));
end architecture behavioral;