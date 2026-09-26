-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Execute_Stage
-- Module Name : Execute_Stage - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Executes operation determined by instruction
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Execute_Stage is
    PORT(
        RegWrite    : IN std_logic; -- Passthrough
        WBSrc       : IN std_logic_vector(1 downto 0);  -- passthrough
        MemWrite    : IN std_logic; -- Passthrough
        ALUControl  : IN std_logic_vector(3 downto 0) := "0000"; -- Opcode
        RegDst      : IN std_logic_vector(1 downto 0);  -- Control bit. Determines which register will be used as the destination register.
        ALUin1      : IN std_logic_vector(31 downto 0); -- data for ALU input1
        ALUin2      : IN std_logic_vector(31 downto 0); -- data for ALU input2
        StoreData   : IN std_logic_vector(31 downto 0); -- data in second register being read
        RtDest      : IN std_logic_vector(4 downto 0);  -- addr of rt in instruction
        RdDest      : IN std_logic_vector(4 downto 0);  -- addr of rd in instruction
        shamt       : IN std_logic_vector(4 downto 0);  -- Amount to shift by
        ShamtSrc    : IN std_logic;                     -- control bit. used to determine shift amount location 
        sp          : IN std_logic_vector(31 downto 0); -- Instruction Memory
        
        RegWriteOut : OUT std_logic; -- Passthrough
        WBSrcOut    : OUT std_logic_vector(1 downto 0); -- Passthrough
        MemWriteOut : OUT std_logic; -- Passthrough
        ALUResult   : OUT std_logic_vector(31 downto 0); -- result of operation
        WriteData   : OUT std_logic_vector(31 downto 0); -- data to be written to memory
        WriteReg    : OUT std_logic_vector(4 downto 0) -- The address of the register being written to.
        );
end Execute_Stage;

architecture behavioral of Execute_Stage is

    signal ShamtMux : std_logic_vector(4 downto 0) := "00000";

    signal ALUOut   : std_logic_vector(31 downto 0) := (others => '0');
begin

    -- Pick Shift Amount Location
    ShamtMux <= shamt when ShamtSrc = '0' else ALUin1(4 downto 0);

    -- passthrough Controls
    RegWriteOut <= RegWrite;
    WBSrcOut <= WBSrc;
    MemWriteOut <= MemWrite;
    
    -- ALU declaration
    alu_inst : entity work.ALU
        generic map(N => 32)
        port map(in1 => ALUin1, in2 => ALUin2, Shamt => ShamtMux, control => ALUControl, out1 => ALUOut);
    
    ALUResult <= std_logic_vector((unsigned(sp) + 1)) when WBSrc = "10" else ALUOut;
    
    
    WriteReg <= RtDest when (RegDst = "00") else -- I-type
                RdDest when (RegDst = "01") else -- R-type
                "11111" when (RegDst = "10") else -- JAL
                "00000"; -- default R0
    WriteData <= StoreData;

end architecture behavioral;