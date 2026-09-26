-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Control_Unit
-- Module Name : Control_Unit- behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Determines Instruction type, and sets appropriate signals 
-- to be used in execution and writeback stages later.
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;
use work.Instruction_OP_pkg.all;
use work.ALU_OP_pkg.all;

entity Control_Unit is
    PORT(
        Opcode : in std_logic_vector(5 downto 0);       -- Opcode of the instruction
        Funct  : in std_logic_vector(5 downto 0);       -- Funct of the instruction
        
        RegWrite   : out std_logic;                     -- Control bit. Set if the instruction requires register writing.
        WBSrc      : out std_logic_vector(1 downto 0);  -- Control bit. determines source of data being written back to registers.
        MemWrite   : out std_logic;                     -- Control bit. Set if the instruction requires writing to Memory.
        ALUControl : out std_logic_vector(3 downto 0);  -- Op-code specific to the ALU
        ALUSrc     : out std_logic;                     -- Control bit. Set if the ALU will use an immedite.
        RegDst     : out std_logic_vector(1 downto 0);  -- Control bit. Determines which register will be used as the destination register.
        ZExtend    : out std_logic;                     -- Control bit. Determines if Imm should be zero extended or sign-extended 
        Branch     : out std_logic;                     -- Control bit. Determines if instruction is branching type
        ShamtSrc : out std_logic                     -- Control bit. Determines if shift amount is in shamt(0) or input2(1)
        );
end Control_Unit;

architecture behavioral of Control_Unit is
begin

    RegWrite_Process : process(Opcode) -- need to add exception for JR
    begin
        RegWrite <= '1';
        if Opcode /= "000000" then
            case Opcode is 
                when I_SW_OP                                        -- Mem Write Actions
                   | I_BEQ_OP | I_BNE_OP | I_BGTZ_OP | I_BLEZ_OP    -- Conditional Branching
                   | J_J_OP =>                                      -- Unlinked Jump Op
                        RegWrite <= '0'; 
                when J_JAL_OP => RegWrite <= '1';                   -- Linked Jump Op
                when others => null; -- Stay with default
            end case;
        end if;
    end process RegWrite_Process;
    
    WBSrc_Process : process(Opcode, Funct)
    begin
        WBSrc <= "00"; -- Default (ALU Result; No Mem Read)
        if Opcode = "000000" and Funct = R_JALR_Funct then
            WBSrc <= "10"; -- pc_next for JALR 
        else
            case Opcode is
                when I_LW_OP => WBSrc <= "01"; -- Data from Memory 
                when J_JAL_OP => WBSrc <= "10"; -- pc_next (JAL)
                when others => null; -- Stay with default
            end case;
        end if;
    end process WBSrc_Process;

    MemWrite_Process : process(Opcode)
    begin
        MemWrite <= '0'; -- Default
        case Opcode is 
            when I_SW_OP => MemWrite <= '1'; -- Store value in Memory
            when others => null; -- Stay with default
        end case;
    end process MemWrite_Process;

    ALUSrc_Process : process(Opcode)
    begin
        ALUSrc <= '0'; -- Default (R-type) (Branches/Jumps technically don't care but default to '0')
        if Opcode /= "000000" then
            case Opcode is
                when I_ADDI_OP | I_ANDI_OP | I_ORI_OP | I_XORI_OP   -- Bitwise Logic Immediates
                   | I_SW_OP  | I_LW_OP                             -- Memory Access Immediates
                   | I_SLTI_OP | I_SLTIU_OP | I_LUI_OP =>           -- SLT/LUI Immediates
                        ALUSrc <= '1';
                when others => null; -- Stay with default
            end case;
        end if;
    end process ALUSrc_Process;
    
    RegDst_Process : process(Opcode)
    begin
        RegDst <= "00";
        if Opcode = "000000" then
            RegDst <="01";
        elsif Opcode = J_JAL_OP then
            RegDst <= "10";
        end if;    
    end process RegDst_Process;
    
    ZExtend_Process : process(Opcode)
    begin
        ZExtend <= '0';
        if Opcode /= "000000" then
            case Opcode is
                when I_ANDI_OP | I_ORI_OP | I_XORI_OP => ZExtend <= '1'; -- Bitwise logic immediates
                when others => null; -- Stay with default
            end case;
        end if;
    end process ZExtend_Process;
    
    Branch_Process : process(Opcode, Funct)
    begin
        Branch <= '0'; -- default
        if Opcode = "000000" then
            if Funct = R_JR_Funct then
                Branch <= '1';
            end if;
        else
            case Opcode is
                when I_BEQ_OP | I_BNE_OP | I_BGTZ_OP | I_BLEZ_OP    -- Branching Instruction
                   | J_J_OP =>                                      -- Registerless Jumps
                        Branch <= '1';
                when others => null; -- Stay with default
            end case;
        end if;
    end process Branch_Process;
    
    ShamtSrc_Process : process(Opcode, Funct)
    begin
        ShamtSrc <= '0'; -- default
        if Opcode = "000000" then
            case Funct is
                when R_SLLV_Funct | R_SRLV_Funct | R_SRAV_Funct => ShamtSrc <= '1'; -- Variable Shifts
                when others => null; -- Stay with default
            end case;
        end if;
    end process ShamtSrc_Process;
    
    ALUControl_Process : process(Opcode, Funct)
begin
    if Opcode = R_OP then
        case Funct is
            when R_ADD_Funct   => ALUControl <= ALU_ADD_OP;
            when R_SUB_Funct   => ALUControl <= ALU_SUB_OP;
            when R_ADDU_Funct  => ALUControl <= ALU_ADDU_OP;
            when R_SUBU_Funct  => ALUControl <= ALU_SUBU_OP;
            when R_AND_Funct   => ALUControl <= ALU_AND_OP;
            when R_OR_Funct    => ALUControl <= ALU_OR_OP;
            when R_NOR_Funct   => ALUControl <= ALU_NOR_OP;
            when R_XOR_Funct   => ALUControl <= ALU_XOR_OP;
            when R_SLL_Funct  | R_SLLV_Funct => ALUControl <= ALU_SLL_OP;
            when R_SRL_Funct  | R_SRLV_Funct => ALUControl <= ALU_SRL_OP;
            when R_SRA_Funct  | R_SRAV_Funct => ALUControl <= ALU_SRA_OP;
            when R_SLT_Funct   => ALUControl <= ALU_SLT_OP;
            when R_SLTU_Funct  => ALUControl <= ALU_SLTU_OP;
            when R_MULTU_Funct => ALUControl <= ALU_MULTU_OP;
            when others        => ALUControl <= "0000";
        end case;
    else
        case Opcode is
            when I_ADDI_OP | I_SW_OP | I_LW_OP => ALUControl <= ALU_ADD_OP;
            when I_ANDI_OP  => ALUControl <= ALU_AND_OP;
            when I_ORI_Op   => ALUControl <= ALU_OR_OP;
            when I_XORI_OP  => ALUControl <= ALU_XOR_OP;
            when I_SLTI_OP  => ALUControl <= ALU_SLT_OP;
            when I_SLTIU_OP => ALUControl <= ALU_SLTU_OP;
            when I_LUI_OP   => ALUControl <= ALU_LUI_OP;
            when others     => ALUControl <= "0000";
        end case;
    end if;
end process ALUControl_Process;
    
end architecture behavioral;