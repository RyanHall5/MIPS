-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Branching_Unit
-- Module Name : Branching_Unit - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Compares registers to determine branching comparisons
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Instruction_OP_pkg.all;

entity Branching_Unit is
    Port (
        pc_id         : in  STD_LOGIC_VECTOR(31 downto 0); -- PC value from IF/ID pipeline register
        imm_ext       : in  STD_LOGIC_VECTOR(31 downto 0); -- Sign-extended 32-bit immediate
        j_imm         : in  STD_LOGIC_VECTOR(25 downto 0);  -- raw 26-bit field, for J only
        rs_data       : in  STD_LOGIC_VECTOR(31 downto 0); -- Data from Rs (or forwarded data)
        rt_data       : in  STD_LOGIC_VECTOR(31 downto 0); -- Data from Rt (or forwarded data)
        opcode        : in  STD_LOGIC_VECTOR(5 downto 0);  -- Branch control signal from Main Control
        Funct         : in  STD_LOGIC_VECTOR(5 downto 0);   -- disambiguates JR from other R-type ops
        take_branch   : out STD_LOGIC;                     -- High when branch condition is met
        branch_target : out STD_LOGIC_VECTOR(31 downto 0)  -- Calculated PC target address
    );
end Branching_Unit;

architecture Behavioral of Branching_Unit is

    signal pc_next : std_logic_vector(31 downto 0);

begin

    pc_next <= std_logic_vector(unsigned(pc_id) + 1);


    branch_target <= 
    pc_next(31 downto 26) & j_imm when
        opcode = J_J_OP or opcode = J_JAL_OP else -- J / JAL
    rs_data when
        opcode = R_OP and
        (Funct = R_JR_Funct or Funct = R_JALR_Funct) else -- JR / JALR
    std_logic_vector(unsigned(pc_next) + unsigned(imm_ext)); -- Conditional branches
    
    take_branch <= 
        '1' when (opcode = J_J_OP)                             or -- J
                 (opcode = R_OP      and Funct = R_JR_Funct)   or -- JR
                 (opcode = J_JAL_OP)                           or -- JAL
                 (opcode = R_OP      and Funct = R_JALR_Funct) or -- JALR
                 (opcode = I_BEQ_OP  and rs_data = rt_data)    or -- BEQ
                 (opcode = I_BNE_OP  and rs_data /= rt_data)   or -- BNE
                 (opcode = I_BGTZ_OP and signed(rs_data) > 0)  or -- BGTZ
                 (opcode = I_BLEZ_OP and signed(rs_data) <= 0)   -- BLEZ
        else '0'; -- Continue sequentially

end Behavioral;