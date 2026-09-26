-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/9/26
-- Design Name : Branch_Hazard_Check
-- Module Name : Branch_Hazard_Check - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description :
------------------------------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Branch_Hazard_Check is
    PORT(
        
        RsAddr : in std_logic_vector(4 downto 0);
        RtAddr : in std_logic_vector(4 downto 0);
        
        RD1in : in std_logic_vector(31 downto 0);
        RD2in : in std_logic_vector(31 downto 0);     -- sign extended immediate

        -- Forward #1: live Execute-stage output (combinational, not yet
        -- latched into EX/MEM). Highest priority -- most recent result.
        ExFwd_addr      : in std_logic_vector(4 downto 0);
        ExFwd_RegWrite  : in std_logic;
        ExFwd_data      : in std_logic_vector(31 downto 0);

        -- Forward #2: latched EX/MEM register (i.e. instruction now in MEM)
        MemFwd_addr     : in std_logic_vector(4 downto 0);
        MemFwd_RegWrite : in std_logic;
        MemFwd_data     : in std_logic_vector(31 downto 0);

        -- Forward #3: latched MEM/WB register (i.e. instruction now in WB)
        WbFwd_addr      : in std_logic_vector(4 downto 0);
        WbFwd_RegWrite  : in std_logic;
        WbFwd_data      : in std_logic_vector(31 downto 0);
        
        RD1out : out std_logic_vector(31 downto 0);
        RD2out : out std_logic_vector(31 downto 0)
    );
end Branch_Hazard_Check;

architecture behavioral of Branch_Hazard_Check is
begin

    -- Determining RD1
    RD1_proc : process(all)
    begin
        if RsAddr = ExFwd_addr and ExFwd_RegWrite = '1' and RsAddr /= "00000" then
            RD1out <= ExFwd_data;
        elsif RsAddr = MemFwd_addr and MemFwd_RegWrite = '1' and RsAddr /= "00000" then
            RD1out <= MemFwd_data;
        elsif RsAddr = WbFwd_addr and WbFwd_RegWrite = '1' and RsAddr /= "00000" then
            RD1out <= WbFwd_data;
        else
            RD1out <= RD1in;
        end if;
    end process RD1_proc;
    
    -- Determining RD2
    RD2_proc : process(all)
    begin
        if RtAddr = ExFwd_addr and ExFwd_RegWrite = '1' and RtAddr /= "00000" then
            RD2out <= ExFwd_data;
        elsif RtAddr = MemFwd_addr and MemFwd_RegWrite = '1' and RtAddr /= "00000" then
            RD2out <= MemFwd_data;
        elsif RtAddr = WbFwd_addr and WbFwd_RegWrite = '1' and RtAddr /= "00000" then
            RD2out <= WbFwd_data;
        else
            RD2out <= RD2in;
        end if;
    end process RD2_proc;
    
end architecture behavioral;