-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : ID_EX
-- Module Name : ID_EX - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Register between Instruction Decode and Execute stages
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity ID_EX is
    PORT(
        clk         : in std_logic;         -- clk signal
        bubble      : in std_logic;         -- Insert a NOP (load-use hazard); squashes RegWrite/MemWrite for one cycle
        
        RegWrite   : in std_logic;                         -- Control bit. If data should be written for next operation
        WBSrc      : in std_logic_vector(1 downto 0);     -- Control bit. determines source of data being written back to registers.
        MemWrite   : in std_logic;                         -- Control bit. If next operation required writing to memory
        ALUControl : in std_logic_vector(3 downto 0);      -- ALU specific opcode to perform
        ALUSrc     : in std_logic;                         -- Control bit. If the ALU will use an immediate
        RegDst     : in std_logic_vector(1 downto 0);     -- Control bit. Determines which register will be used as the destination register.
        ShamtSrc   : in std_logic;                         -- Control bit. Controls where shift amount comes from
        RD1        : in std_logic_vector(31 downto 0);     -- Reg read output 1
        RD2        : in std_logic_vector(31 downto 0);     -- Reg read output 2
        RsDest     : in std_logic_vector(4 downto 0);      -- Rs addr from Instruction
        RtDest     : in std_logic_vector(4 downto 0);      -- Rt addr from Instruction
        RdDest     : in std_logic_vector(4 downto 0);      -- Rd addr from Instruction (only means anything if R-type)
        Imm        : in std_logic_vector(31 downto 0);     -- Sign/Zero Extended immediate for I-type Instruction
        Shamt      : in std_logic_vector(4 downto 0);      -- Amount to shift by 
        pc         : in std_logic_vector(31 downto 0);     -- Program Counter
    
        pcOut         : out std_logic_vector(31 downto 0);      -- Program counter
        RegWriteOut   : out std_logic;                         -- Control bit. If data should be written for next operation
        WBSrcOut      : out std_logic_vector(1 downto 0);  -- Control bit. determines source of data being written back to registers.
        MemWriteOut   : out std_logic;                         -- Control bit. If next operation required writing to memory
        ALUControlOut : out std_logic_vector(3 downto 0);      -- ALU specific opcode to perform
        ALUSrcOut     : out std_logic;                         -- Control bit. If the ALU will use an immediate
        RegDstOut     : out std_logic_vector(1 downto 0);      -- Control bit. Determines which register will be used as the destination register.
        ShamtSrcOut   : out std_logic;                         -- Control bit. Controls where shift amount comes from
        RD1Out        : out std_logic_vector(31 downto 0);     -- Reg read output 1
        RD2Out        : out std_logic_vector(31 downto 0);     -- Reg read output 2
        RsDestOut     : out std_logic_vector(4 downto 0);      -- Rs addr from Instruction
        RtDestOut     : out std_logic_vector(4 downto 0);      -- Rt addr from Instruction
        RdDestOut     : out std_logic_vector(4 downto 0);      -- Rd addr from Instruction (only means anything if R-type)
        ImmOut        : out std_logic_vector(31 downto 0);      -- Sign/Zero Extended immediate for I-type Instruction
        ShamtOut      : out std_logic_vector(4 downto 0)      -- Amount to shift by 
    );
end ID_EX;

architecture behavioral of ID_EX is

begin

    passthrough_proc : process(clk)
    begin
        if rising_edge(clk) then
            if bubble = '1' then
                RegWriteOut <= '0';
                MemWriteOut <= '0';
            else
                RegWriteOut <= RegWrite;
                MemWriteOut <= MemWrite;
            end if;
            WBSrcOut <= WBSrc;
            ALUControlOut <= ALUControl;
            ALUSrcOut <= ALUSrc;
            RegDstOut <= RegDst;
            RD1Out <= RD1;
            RD2Out <= RD2;
            RsDestOut <= RsDest;
            RtDestOut <= RtDest;
            RdDestOut <= RdDest;
            ImmOut <= Imm;
            ShamtOut <= Shamt;
            ShamtSrcOut <= ShamtSrc;
            pcOut <= pc;
        end if;
    end process passthrough_proc;
end architecture behavioral;