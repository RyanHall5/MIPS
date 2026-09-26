-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/11/26
-- Design Name : Bitwise Logic Calculation Unit
-- Module Name : bitwise_logicN - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Handles Bitwise logic calculation in ALU for basic bitwise logic operations
-- such as AND/OR/XOR/NOR, ANDI/ORI/XORI
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;

entity bitwise_logicN is
    GENERIC(N : INTEGER := 32);
    PORT(
        A, B : IN  std_logic_vector(N-1 downto 0);
        sel  : IN  std_logic_vector(1 downto 0);  -- "00"=AND "01"=OR "10"=XOR "11"=NOR
        Y    : OUT std_logic_vector(N-1 downto 0)
        );
end entity;

architecture behavioral of bitwise_logicN is
    signal or_result : std_logic_vector(N-1 downto 0);
begin
    or_result <= A or B;  -- reused for OR and NOR to reduce hardware usage

    with sel select
        Y <= (A and B)      when "00",
             or_result      when "01",
             (A xor B)      when "10",
             not or_result  when others;  
end architecture;