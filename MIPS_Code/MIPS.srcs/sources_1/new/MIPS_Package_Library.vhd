-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : MIPS_Packge_Library
-- Module Name : MIPS_Packge_Library - package ( library )
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : All packages needed in MIPS project.
-- ----------------------------------------------------

------------------------------
-- Package for ALU Decoding --
------------------------------
library ieee;
use ieee.std_logic_1164.all;

package ALU_OP_pkg is
    
    -- constant value declarations for OP codes
    
    -------------------- ADDER OPS -----------------------------------------
    -- last bit determines ADD(0) vs SUB(1). Second to last bit determines Signed(0) vs Unsigned(1)
    constant ALU_ADD_OP     : std_logic_vector(3 downto 0) := "0000"; --placeholder
    constant ALU_SUB_OP     : std_logic_vector(3 downto 0) := "0001"; --placeholder
    constant ALU_ADDU_OP    : std_logic_vector(3 downto 0) := "0010"; --placeholder
    constant ALU_SUBU_OP    : std_logic_vector(3 downto 0) := "0011"; --placeholder
    
    ------------------- BITWISE LOGIC OPS -----------------------------------------------
    -- Last two bits are used to select specific operation in ALU ------------------------
    constant ALU_AND_OP     : std_logic_vector(3 downto 0) := "0100"; -- last two MUST be "00"
    constant ALU_OR_OP      : std_logic_vector(3 downto 0) := "0101"; -- last two MUST be "01"
    constant ALU_XOR_OP     : std_logic_vector(3 downto 0) := "0110"; -- last two MUST be "10"
    constant ALU_NOR_OP     : std_logic_vector(3 downto 0) := "0111"; -- last two MUST be "11"
    
    -------------- SHIFTING OPS ---------------------------------------
    -- Last two bits are used to select specific operation in ALU ------------
    constant ALU_SLL_OP     : std_logic_vector(3 downto 0) := "1000"; -- last two MUST be "00"
    constant ALU_SRL_OP     : std_logic_vector(3 downto 0) := "1001"; -- last two MUST be "01"
    constant ALU_SRA_OP     : std_logic_vector(3 downto 0) := "1010"; -- last two MUST be "10"
    
    ----------------- SLT OPS ------------------------------------------
    -- Last bit must be 1 (so adder does subtraction). Second to last bit determines Signed(0) vs Unsigned(1)
    constant ALU_SLT_OP     : std_logic_vector(3 downto 0) := "1101"; -- last two MUST be "01" 
    constant ALU_SLTU_OP    : std_logic_vector(3 downto 0) := "1111"; -- last two MUST be "11" 
    
    
    --------------- One off OPS ----------------------------
    constant ALU_LUI_OP     : std_logic_vector(3 downto 0) := "1100";
    
    constant ALU_MULTU_OP   : std_logic_vector(3 downto 0) := "1110";
    
end ALU_OP_pkg;

--------------------------------------
-- Package for Instruction Decoding --
--------------------------------------
library ieee;
use ieee.std_logic_1164.all;

package Instruction_OP_pkg is

    -- R-type Instruction Funct codes
    constant R_OP           : std_logic_vector(5 downto 0) := "000000"; -- 0x00
    constant R_ADD_Funct    : std_logic_vector(5 downto 0) := "100000"; -- 0x20
    constant R_AND_Funct    : std_logic_vector(5 downto 0) := "100100"; -- 0x24
    constant R_MULTU_Funct  : std_logic_vector(5 downto 0) := "011001"; -- 0x19
    constant R_OR_Funct     : std_logic_vector(5 downto 0) := "100101"; -- 0x25
    constant R_SLLV_Funct   : std_logic_vector(5 downto 0) := "000100"; -- 0x04
    constant R_SRAV_Funct   : std_logic_vector(5 downto 0) := "000111"; -- 0x07
    constant R_SRLV_Funct   : std_logic_vector(5 downto 0) := "000110"; -- 0x06
    constant R_SUB_Funct    : std_logic_vector(5 downto 0) := "100010"; -- 0x22
    constant R_XOR_Funct    : std_logic_vector(5 downto 0) := "100110"; -- 0x26
    constant R_ADDU_Funct   : std_logic_vector(5 downto 0) := "100001"; -- 0x21
    constant R_SUBU_Funct   : std_logic_vector(5 downto 0) := "100011"; -- 0x23
    constant R_NOR_Funct    : std_logic_vector(5 downto 0) := "100111"; -- 0x27
    constant R_SLL_Funct    : std_logic_vector(5 downto 0) := "000000"; -- 0x00
    constant R_SRL_Funct    : std_logic_vector(5 downto 0) := "000010"; -- 0x02
    constant R_SRA_Funct    : std_logic_vector(5 downto 0) := "000011"; -- 0x03
    constant R_SLT_Funct    : std_logic_vector(5 downto 0) := "101010"; -- 0x2A
    constant R_SLTU_Funct   : std_logic_vector(5 downto 0) := "101011"; -- 0x2B
    constant R_JR_Funct     : std_logic_vector(5 downto 0) := "001000"; -- 0x08
    constant R_JALR_Funct   : std_logic_vector(5 downto 0) := "001001"; -- 0x09
    
    -- I-type Instruction opcodes
    constant I_ADDI_OP      : std_logic_vector(5 downto 0) := "001000"; -- 0x08
    constant I_ANDI_OP      : std_logic_vector(5 downto 0) := "001100"; -- 0x0c
    constant I_ORI_OP       : std_logic_vector(5 downto 0) := "001101"; -- 0x0d
    constant I_XORI_OP      : std_logic_vector(5 downto 0) := "001110"; -- 0x0e
    constant I_SW_OP        : std_logic_vector(5 downto 0) := "101011"; -- 0x2b
    constant I_LW_OP        : std_logic_vector(5 downto 0) := "100011"; -- 0x23
    constant I_BEQ_OP       : std_logic_vector(5 downto 0) := "000100"; -- 0x04
    constant I_BNE_OP       : std_logic_vector(5 downto 0) := "000101"; -- 0x05
    constant I_BGTZ_OP      : std_logic_vector(5 downto 0) := "000111"; -- 0x07
    constant I_BLEZ_OP      : std_logic_vector(5 downto 0) := "000110"; -- 0x06
    constant I_SLTI_OP      : std_logic_vector(5 downto 0) := "001010"; -- 0x0A
    constant I_SLTIU_OP     : std_logic_vector(5 downto 0) := "001011"; -- 0x0B
    constant I_LUI_OP       : std_logic_vector(5 downto 0) := "001111"; -- 0x0F
    
    -- J-type Instruction opcodes (JALR and JR are technically R-type)
    constant J_J_OP         : std_logic_vector(5 downto 0) := "000010"; -- 0x02
    constant J_JAL_OP       : std_logic_vector(5 downto 0) := "000011"; -- 0x03
    
end Instruction_OP_pkg;