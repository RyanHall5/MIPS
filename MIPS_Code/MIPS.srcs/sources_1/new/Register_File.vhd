-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Register_File
-- Module Name : Register_File- behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Contains the 32, 32-bit registers used in the MIPS
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Register_File is
    PORT(
        clk_n     : in std_logic;                       -- clk signal
        we        : in std_logic;                       -- Control bit: Write enabled
        Addr1     : in std_logic_vector(4 downto 0);    -- First reg to read
        Addr2     : in std_logic_vector(4 downto 0);    -- Second reg to read
        Addr3     : in std_logic_vector(4 downto 0);    -- Reg to write to
        WriteData : in std_logic_vector(31 downto 0);   -- Data to be written to Addr3
        
        RD1 : out std_logic_vector(31 downto 0);        -- Data at Addr1
        RD2 : out std_logic_vector(31 downto 0)         -- Data at Addr2
        );
end Register_File;

architecture behavioral of Register_File is

    -- Container of 32 32-bit registers
    type register_file is array (0 to 31) of std_logic_vector(31 downto 0);
    
    -- Instantiating registers to be blank
    signal registers : register_file := (others => (others => '0'));

begin

    -- Reading Registers RD1 and RD2 (asynch)
    read_process : process(Addr1, Addr2, registers)
    begin
        RD1 <= registers(to_integer(unsigned(Addr1)));
        RD2 <= registers(to_integer(unsigned(Addr2)));
    end process read_process;

    -- Writing to Register at Addr3 on falling clock edge to avoid hazards
    write_process : process(clk_n)
    begin
        if(falling_edge(clk_n)) then
            if(we = '1') then -- check writing enabled
                if(Addr3 /= "00000") then -- prevent writing to R0
                    registers(to_integer(unsigned(Addr3))) <= WriteData;
                end if;
            end if;
        end if;
    end process write_process;
    
end architecture behavioral;