-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Design Name : Memory_Stage
-- Module Name : Memory_Stage - behavioral
-- Project Name : MIPS
-- Target Devices : ASIC (Librelane / OpenLane flow)
--
-- Description : Stage 4 (Memory Access Stage) of Pipelined MIPS.
--               ASIC port: seven-segment display path (BinaryToBCD,
--               SevenSeg_Driver) and the switches input removed, since
--               they were Basys3 board peripherals with no ASIC analog.
-- ----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Memory_Stage is
    PORT(
        clk       : in std_logic;                       -- clk signal
        RegWrite  : in std_logic;                       -- Pass through
        WBSrc     : in std_logic_vector(1 downto 0);    -- Pass through
        WriteReg  : in std_logic_vector(4 downto 0);    -- Pass through
        MemWrite  : in std_logic;                       -- Control bit. If memory is being written to
        ALUResult : in std_logic_vector(31 downto 0);   -- Output from ALU operation
        WriteData : in std_logic_vector(31 downto 0);   -- Data provided to Memory

        RegWriteOut     : out std_logic;                    -- Pass through
        WBSrcOut        : out std_logic_vector(1 downto 0); -- Pass through
        WriteRegOut     : out std_logic_vector(4 downto 0); -- Pass Through
        MemOut          : out std_logic_vector(31 downto 0);-- Value read from memory
        ALUResultOut    : out std_logic_vector(31 downto 0) -- Passthrough
     );
end Memory_Stage;

architecture behavioral of Memory_Stage is

begin

    data_memory_inst : entity work.Data_Memory
        generic map(WIDTH => 32, ADDR_SPACE => 6)
        port map(
            clk => clk,
            w_en => MemWrite,
            addr => ALUResult(5 downto 0),
            d_in => WriteData,
            d_out => MemOut
        );

    -- Pass throughs
    ALUResultOut <= ALUResult;
    RegWriteOut <= RegWrite;
    WBSrcOut <= WBSrc;
    WriteRegOut <= WriteReg;

end architecture behavioral;