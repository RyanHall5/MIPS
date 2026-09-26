-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT)
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/11/26
-- Design Name : Adder/Subtractor
-- Module Name : addN - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : N-bit adder/subtractor used for ADD, ADDU, SUB, SUBU. 
-- OP selects add(0) vs subtract(1) and is used to flip B using twos comp logic.
-- Overflow is the signed-overflow flag only meaningful for ADD/SUB (Sign='1'),
-- ignored by ADDU/SUBU since they do not set flags in MIPS architecture.
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity addN is
    GENERIC(
        N : INTEGER := 32);
    PORT(
        A        : IN  std_logic_vector(N-1 downto 0);  -- Operand1
        B        : IN  std_logic_vector(N-1 downto 0);  -- Operand2
        OP       : IN  std_logic;  -- '0' = add, '1' = subtract
        Sign     : IN  std_logic;  -- '0' = signed op (ADD/SUB/ADDI/SUBI), '1' = unsigned (e.g. ADDU/SUBU)
        Sum      : OUT std_logic_vector(N-1 downto 0);
        CarryOut : OUT std_logic;
        Overflow : OUT std_logic   -- signed overflow flag, valid only when Sign = '1'
        );
end addN;

architecture behavioral of addN is

    signal B_mux     : std_logic_vector(N-1 downto 0); -- flips B with twos comp if Subtraction
    signal carry_in  : std_logic; -- 0 if addition, 1 if subtraction
    signal sum_ext   : std_logic_vector(N downto 0);  -- N+1 bits: index N is carry-out

begin

    -- OP = '0' : Addition -> A + B + 0
    -- OP = '1' : Subtraction -> A + (NOT B) + 1
    B_mux    <= B when OP = '0' else not B;
    carry_in <= OP;

    -- N-bit adder, with extended signal to capture carry out for overflow detection
    sum_ext <= std_logic_vector(unsigned('0' & A) + unsigned('0' & B_mux) + unsigned'("" & carry_in));

    -- Assigning Sum & Cout outputs
    Sum      <= sum_ext(N-1 downto 0);
    CarryOut <= sum_ext(N);

    -- Signed overflow: operands share a sign, but result's sign differs from theirs.
    -- Equivalent to carry_into_MSB XOR carry_out_of_MSB, expressed here via sign bits.
    -- Only meaningful when Sign = '0' (ADD/SUB); gated off for ADDU/SUBU.
    Overflow <= '1' when (Sign = '0') and
                          (A(N-1) = B_mux(N-1)) and
                          (sum_ext(N-1) /= A(N-1))
                     else '0';

end architecture behavioral;