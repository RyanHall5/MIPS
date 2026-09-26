-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : EX_MEM
-- Module Name : EX_MEM - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Register between Instruction Decode and Execute stages
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity EX_MEM is
    PORT(
        clk : in std_logic; -- clk signal
        
        RegWrite  : in std_logic;                     -- Control bit. If data should be written for next operation
        WBSrc     : in std_logic_vector(1 downto 0);  -- Control bit. determines source of data being written back to registers.
        MemWrite  : in std_logic;                     -- Control bit. If next operation required writing to memory
        ALUResult : in std_logic_vector(31 downto 0); -- result of operation
        WriteData : in std_logic_vector(31 downto 0); -- data to be written to memory
        WriteReg  : in std_logic_vector(4 downto 0);  -- The address of the register being written to.
        
    
        RegWriteOut  : out std_logic;                     -- Control bit. If data should be written for next operation
        WBSrcOut     : out std_logic_vector(1 downto 0);  -- Control bit. determines source of data being written back to registers.
        MemWriteOut  : out std_logic;                     -- Control bit. If next operation required writing to memory
        ALUResultOut : out std_logic_vector(31 downto 0); -- result of operation
        WriteDataOut : out std_logic_vector(31 downto 0); -- data to be written to memory
        WriteRegOut  : out std_logic_vector(4 downto 0)   -- The address of the register being written to.
    );
end EX_MEM;

architecture behavioral of EX_MEM is

begin

    passthrough_proc : process(clk)
    begin
        if rising_edge(clk) then
            RegWriteOut <= RegWrite;
            WBSrcOut <= WBSrc;
            MemWriteOut <= MemWrite;
            ALUResultOut <= ALUResult;
            WriteDataOut <= WriteData;
            WriteRegOut <= WriteReg;
        end if;
    end process passthrough_proc;
end architecture behavioral;