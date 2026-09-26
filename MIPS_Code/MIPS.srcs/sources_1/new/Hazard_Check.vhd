-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/3/26
-- Design Name : Hazard_Check
-- Module Name : Hazard_Check - dataflow
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Hazard_Check
-- ----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Check is
    PORT(
        
        Reg2_addr1_out : in std_logic_vector(4 downto 0);
        Reg2_addr2_out : in std_logic_vector(4 downto 0);
        
        Reg2_ALUSrc_out : in std_logic;                     -- 0 = use 2 registers, 1 = use immediate
        Reg2_RD1data_out : in std_logic_vector(31 downto 0);
        Reg2_RD2data_out : in std_logic_vector(31 downto 0);
        Reg2_Imm_out : in std_logic_vector(31 downto 0);     -- sign extended immediate
        
        Reg3_addr_out : in std_logic_vector(4 downto 0);
        Reg3_RegWrite_out : in std_logic;
        Reg3_data_out : in std_logic_vector(31 downto 0);
        
        Reg4_addr_out : in std_logic_vector(4 downto 0);
        Reg4_RegWrite_out : in std_logic;
        Reg4_ALUResult_out : in std_logic_vector(31 downto 0);
        Reg4_MemResult_out : in std_logic_vector(31 downto 0);  -- MEM/WB's memory-read data (for loads)
        Reg4_WBSrc_out : in std_logic_vector(1 downto 0);       -- "01" = load; selects which of the two above is real
        
        ALUin1 : out std_logic_vector(31 downto 0);
        ALUin2 : out std_logic_vector(31 downto 0);
        StoreData : out std_logic_vector(31 downto 0)
    );
end Hazard_Check;

architecture behavioral of Hazard_Check is
    signal Hazardless_ALUin2 : std_logic_vector(31 downto 0);

    -- Reg4_ALUResult_out alone is only correct for non-load writebacks;
    -- for a load, the value actually written to the register file is
    -- Reg4_MemResult_out, selected by WBSrc. Forward the right one.
    signal Reg4_data_out : std_logic_vector(31 downto 0);
begin

    Reg4_data_out <= Reg4_MemResult_out when Reg4_WBSrc_out = "01" else Reg4_ALUResult_out;

    -- Determinig ALUin1
    ALUin1_proc : process(all)
    begin
        if Reg2_addr1_out = Reg3_addr_out and Reg3_RegWrite_out = '1' and Reg3_addr_out /= "00000" then
            ALUin1 <= Reg3_data_out;
        elsif Reg2_addr1_out = Reg4_addr_out and Reg4_RegWrite_out = '1' and Reg4_addr_out /= "00000" then
            ALUin1 <= Reg4_data_out;
        else
            ALUin1 <= Reg2_RD1data_out;
        end if;
    end process;
    
    -- Determinig ALUin2
    ALUin2_proc : process(all)
    begin
        if Reg2_ALUSrc_out = '1' then
            ALUin2 <= Reg2_Imm_out;
        elsif Reg2_addr2_out = Reg3_addr_out and Reg3_RegWrite_out = '1' and Reg3_addr_out /= "00000" then
            ALUin2 <= Reg3_data_out;
        elsif Reg2_addr2_out = Reg4_addr_out and Reg4_RegWrite_out = '1' and Reg4_addr_out /= "00000" then
            ALUin2 <= Reg4_data_out;
        else
            ALUin2 <= Reg2_RD2data_out;
        end if;
    end process ALUin2_proc;
    
    -- Determining value for store instructions
    StoreData_proc : process(all)
    begin
        if Reg2_addr2_out = Reg3_addr_out and Reg3_RegWrite_out = '1' and Reg3_addr_out /= "00000" then
            StoreData <= Reg3_data_out;
        elsif Reg2_addr2_out = Reg4_addr_out and Reg4_RegWrite_out = '1' and Reg4_addr_out /= "00000" then
            StoreData <= Reg4_data_out;
        else
            StoreData <= Reg2_RD2data_out;
        end if;
    end process;
end architecture behavioral;