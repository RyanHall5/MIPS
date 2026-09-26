-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : IF_ID
-- Module Name : IF_ID - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Register between Instruction Fetch and Decode stages
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity IF_ID is
    PORT(
        clk         : in std_logic;         -- clk signal
        flush       : in std_logic;     -- If branching, kill the operation after the branch line before it executes
        stall       : in std_logic;     -- Hold current instruction/sp for one cycle (load-use hazard)
        instruction : in std_logic_vector(31 downto 0);    -- value in memory at sp
        pc          : in std_logic_vector(31 downto 0);     -- current program counter
    
        instructionOut : out std_logic_vector(31 downto 0); -- value in memory at pc
        pcOut          : out std_logic_vector(31 downto 0)  -- timing adjusted pc
    );
end IF_ID;

architecture behavioral of IF_ID is

begin

    passthrough_proc : process(clk)
    begin
        if rising_edge(clk) then
            if flush = '1' then
                instructionOut <= (others => '0');
                pcOut <= pc;
            elsif stall = '1' then
                null; -- hold
            else
                instructionOut <= instruction;
                pcOut <= pc;
            end if;
        end if;
    end process passthrough_proc;
end architecture behavioral;