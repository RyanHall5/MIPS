-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : MEM_WB
-- Module Name : MEM_WB - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Register between Instruction Decode and Execute stages
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MEM_WB is
    PORT(
        clk : in std_logic; -- clk signal
        
        RegWrite  : in std_logic;                    -- Pass through
        WBSrc     : in std_logic_vector(1 downto 0); -- Pass through
        WriteReg  : in std_logic_vector(4 downto 0); -- Pass Through
        Mem       : in std_logic_vector(31 downto 0);-- Value read from memory
        ALUResult : in std_logic_vector(31 downto 0);-- Passthrough
    
        RegWriteOut  : out std_logic;                    -- Pass through
        WBSrcOut     : out std_logic_vector(1 downto 0); -- Pass through
        WriteRegOut  : out std_logic_vector(4 downto 0); -- Pass Through
        MemOut       : out std_logic_vector(31 downto 0);-- Value read from memory
        ALUResultOut : out std_logic_vector(31 downto 0) -- Passthrough
    );
end MEM_WB;

architecture behavioral of MEM_WB is
begin

    passthrough_proc : process(clk)
    begin
        if rising_edge(clk) then
            RegWriteOut <= RegWrite;
            WBSrcOut <= WBSrc;
            WriteRegOut <= WriteReg;
            MemOut <= Mem;
            ALUResultOut <= ALUResult;
        end if;
    end process passthrough_proc;
end architecture behavioral;