-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Fetch_Stage
-- Module Name : Fetch_Stage - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Instruction Fetch Stage, contains an instance of
--              The instruction memeory, and updates stack pointer.
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity Fetch_Stage is
    PORT(
        clk         : in std_logic;         -- clk signal
        rst         : in std_logic;         -- asynch pc reset
        stall       : in std_logic;         -- Control bit. Hold PC for one cycle (load-use hazard)
        take_branch : in std_logic;         -- Control bit. If branching should occur
        branch_target : in std_logic_vector(31 downto 0);   -- new PC if take_branch = '1'
        pcOut      : out std_logic_vector(31 downto 0);    -- used to calculate offset in branching math
        instruction : out std_logic_vector(31 downto 0)    -- value in memory at pc
        
    );
end Fetch_Stage;

architecture behavioral of Fetch_Stage is

    -- Program Counter signal. (in words not bytes)
    signal pc : unsigned(31 downto 0) := (others => '0');

begin

    -- Increment program counter 4 bytes (1 word) every clock cycle
    -- If reset is activated, return PC to 0 (start of instruction memory)
    pc_process : process(clk, rst)
    begin
        if(rst = '1') then
            pc <= X"00000000";
        elsif(rising_edge(clk)) then
            if (take_branch = '1') then
                pc <= unsigned(branch_target);
            elsif (stall = '1') then
                pc <= pc; -- hold PC for one cycle
            else
                pc <= pc + 1; 
            end if;       
        end if;
    end process pc_process;   

    pcOut <= std_logic_vector(pc);

    -- Getting instruction from memory stack pointer address
    Instruction_Memory_Inst : entity work.Instruction_Memory
        port map(addr => pc, d_out => instruction);

end architecture behavioral;