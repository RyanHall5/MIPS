-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Decode_Stage
-- Module Name : Decode_Stage - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Decode 32-bit instruction to determine ALU operation
-- and control signal settings/values
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Decode_Stage is
    PORT(
        clk          : in std_logic;                        -- clk signal
        Instruction  : in std_logic_vector(31 downto 0) := X"00000000";   -- 32-bit instruction from Instruction Memory
        RegWriteAddr : in std_logic_vector(4 downto 0) := "00000";     -- Addr to Write to in register file (from previous writeback stage)
        RegWriteData : in std_logic_vector(31 downto 0) := X"00000000";    -- Data to write to reg in register file (from previous writeback stage)
        RegWriteEn   : in std_logic := '0';                        -- Control bit. If data should be written to reg or not (from previous writeback stage)
        pcin         : in std_logic_vector(31 downto 0);    -- Program Counter

        pcout      : out std_logic_vector(31 downto 0);     -- Program Counter
        RegWrite   : out std_logic;                         -- Control bit. If data should be written for next operation
        WBSrc      : out std_logic_vector(1 downto 0);      -- Control bit. determines source of data being written back to registers.y
        MemWrite   : out std_logic;                         -- Control bit. If next operation required writing to memory
        ALUControl : out std_logic_vector(3 downto 0);      -- ALU specific opcode to perform
        ALUSrc     : out std_logic;                         -- Control bit. If the ALU will use an immediate
        RegDst     : out std_logic_vector(1 downto 0);  -- Control bit. Determines which register will be used as the destination register.
        Branch     : out std_logic;                         -- Control bit. Determines if instruction is branching type
        ShamtSrc   : out std_logic;                         -- Control bit. Controls where shift amount comes from
        RD1        : out std_logic_vector(31 downto 0);     -- Reg read output 1
        RD2        : out std_logic_vector(31 downto 0);     -- Reg read output 2
        RsDest     : out std_logic_vector(4 downto 0);      -- Rs addr from Instruction
        RtDest     : out std_logic_vector(4 downto 0);      -- Rt addr from Instruction
        RdDest     : out std_logic_vector(4 downto 0);      -- Rd addr from Instruction (only means anything if R-type)
        Shamt      : out std_logic_vector(4 downto 0);      -- shift amount for SLL, SRL, SRA
        ImmOut     : out std_logic_vector(31 downto 0)     -- Sign/Zero Extended immediate for I-type Instruction
        );
end Decode_Stage;

architecture behavioral of Decode_Stage is

    -- Control bit. If ImmOut should be Zero-Extended or Sign-Extended
    signal ZExtend : std_logic := '0';
    signal Read1_sig : std_logic_vector(31 downto 0);
    signal Read2_sig : std_logic_vector(31 downto 0);
    signal Imm_sig : std_logic_vector(31 downto 0);


begin
    
    -- Control Unit Implementation
    Control_Unit_inst : entity work.Control_Unit
        port map(
            Opcode => Instruction(31 downto 26),
            Funct => Instruction(5 downto 0),
            RegWrite => RegWrite,
            WBSrc => WBSrc,
            MemWrite => MemWrite,
            ALUControl => ALUControl,
            ALUSrc => ALUSrc,
            RegDst => RegDst,
            ZExtend => ZExtend,
            Branch => Branch,
            ShamtSrc => ShamtSrc
        );
        
    
    -- Register File Implementaiton
    Register_File_inst : entity work.Register_File
        port map(
            clk_n => clk,
            we => RegWriteEn,
            Addr1 => Instruction(25 downto 21),
            Addr2 => Instruction(20 downto 16),
            Addr3 => RegWriteAddr,
            RD1 => Read1_sig,
            RD2 => Read2_sig,
            WriteData => RegWriteData
        );
        
    -- Sign/Zero-Extending 
    Imm_sig <= (X"0000" & Instruction(15 downto 0)) when ZExtend = '1' else  -- zero extend
          ((31 downto 16 => Instruction(15)) & Instruction(15 downto 0));   -- sign extend 
            
    ImmOut <= Imm_sig;
    
    RD1 <= Read1_sig;
    RD2 <= Read2_sig;
            
    -- Slicing rt and rd addresses
    RsDest <= Instruction(25 downto 21);
    RtDest <= Instruction(20 downto 16);
    RdDest <= Instruction(15 downto 11); -- only means anything if R-type
    Shamt  <= Instruction(10 downto 6); -- only does anything if Shift
          
    pcout <= pcin;  
end architecture behavioral;