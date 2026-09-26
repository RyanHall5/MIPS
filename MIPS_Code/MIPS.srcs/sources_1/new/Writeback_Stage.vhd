-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Writeback_Stage
-- Module Name : Writeback_Stage - dataflow
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Writeback_Stage
-- ----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Writeback_Stage is
    PORT(
        RegWrite  : in std_logic;
        WBSrc  : in std_logic_vector(1 downto 0);
        ALUResult : in std_logic_vector(31 downto 0);
        ReadData  : in std_logic_vector(31 downto 0);
        WriteReg  : in std_logic_vector(4 downto 0);
        
       
        RegWriteOut : out std_logic;
        WriteRegOut : out std_logic_vector(4 downto 0);
        Result      : out std_logic_vector(31 downto 0)
    );
end Writeback_Stage;

architecture behavioral of Writeback_Stage is
begin

    writeback_proc : process(ReadData, WBSrc, ALUResult)
    begin
        if WBSrc = "01" then
            Result <= ReadData; 
        else -- WBSrc = "00" and WBSrc = "10" are muxed into ALUResult earlier
            Result <= ALUResult; 
        end if;
    end process writeback_proc;

    RegWriteOut <= RegWrite;
    WriteRegOut <= WriteReg;

end architecture behavioral;