-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : ALU
-- Module Name : ALU - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Arithmetic Logic Unit
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.ALU_OP_pkg.all;

entity ALU is
    GENERIC(
        N : INTEGER := 32);
    PORT(
        in1     : IN  std_logic_vector(N-1 downto 0);   -- input 1
        in2     : IN  std_logic_vector(N-1 downto 0);   -- input 2
        Shamt   : IN  std_logic_vector(4 downto 0);     --shift amt
        control : IN  std_logic_vector(3 downto 0);     -- ALU opcode
        out1    : OUT std_logic_vector(N-1 downto 0) := (others => '0');    -- output
        FLAG_overflow : OUT std_logic -- currently unimplemented -> used for exception handling in future
        );
end ALU;

architecture behavioral of ALU is
 
    -- Handles ADD/ADDI/ADDU, SUB/SUBI/SUBU, and LW/SW
    signal add_result   : std_logic_vector(N-1 downto 0);
    -- Helpers 
    signal add_overflow_flag : std_logic;
    signal add_CarryOut : std_logic;
    
    -- Handles AND/OR/XOR/NOR, ANDI/ORI/XORI
    signal bitwise_logic_result : std_logic_vector(N-1 downto 0);
    
    -- Handles SLL/SLLV, SRL/SRLV, SRA/SRAV
    signal shift_result : std_logic_vector(N-1 downto 0);
    
    -- Handles SLT/SLTI, SLTU/SLTIU
    signal slt_result : std_logic_vector(N-1 downto 0);
    
    -- Handles LUI (lone approach because its just wire routing, no components)
    signal lui_result : std_logic_vector(N-1 downto 0);
    
    signal multu_result : std_logic_vector(N-1 downto 0);


    

begin

    -- Handles logic for ADD/ADDI/ADDU, SUB/SUBI/SUBU, and LW/SW
    add_comp : entity work.addN
        generic map(N => N)
        port map (A => in1, B => in2, OP => control(0), Sign => control(1), Sum => add_result, 
                  Overflow => add_overflow_flag, CarryOut => add_CarryOut); 

    -- Handles logic for AND/OR/XOR/NOR, ANDI/ORI/XORI
    bitwise_logic_comp : entity work.bitwise_logicN 
        generic map(N => N)
        port map(A => in1, B => in2, sel => control(1 downto 0), Y => bitwise_logic_result);

    -- Handles logic for SLL/SLLV, SRL/SRLV, SRA/SRAV
    shift_comp : entity work.shiftN 
        generic map(N => N)
        port map(A => in2, shift_amt => Shamt, sel => control(1 downto 0), Y => shift_result);
    
    -- Handles logic for SLT/SLTI, SLTU/SLTIU
    slt_result <= (N-1 downto 1 => '0') & (add_result(31) xor add_overflow_flag) when control(1) = '0' else -- SLT/SLTI
                  (N-1 downto 1 => '0') & not add_CarryOut; -- SLTU/SLTIU
    
    -- Handles logic for LUI
    lui_result <= in2(15 downto 0) & X"0000";

    mult_comp : entity work.multuN
        generic map(N => N)
        port map (A => in1(15 downto 0), B => in2(15 downto 0), Product => multu_result);
    
    with control select
        out1 <= add_result          when ALU_ADD_OP | ALU_SUB_OP | ALU_ADDU_OP | ALU_SUBU_OP,
                bitwise_logic_result when ALU_AND_OP | ALU_OR_OP | ALU_XOR_OP | ALU_NOR_OP,
                shift_result         when ALU_SLL_OP | ALU_SRL_OP | ALU_SRA_OP,
                slt_result           when ALU_SLT_OP | ALU_SLTU_OP,
                multu_result         when ALU_MULTU_OP,
                lui_result           when ALU_LUI_OP,
                X"00000000"          when others;
    
    -- Can probably be simplified
    FLAG_Overflow <= add_overflow_flag when (control = ALU_ADD_OP or control = ALU_SUB_OP) else '0';
    
end architecture behavioral;