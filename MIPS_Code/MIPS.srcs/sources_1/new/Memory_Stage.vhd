-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Memory_Stage
-- Module Name : Memory_Stage - dataflow
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Stage 4 (Memory Access Stage) of Pipelined MIPS
-- ----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;

entity Memory_Stage is
    PORT(
        clk_100MHz : in std_logic;                      -- real clk signal
        clk       : in std_logic;                       -- clk signal 
        RegWrite  : in std_logic;                       -- Pass through
        WBSrc     : in std_logic_vector(1 downto 0);    -- Pass through
        WriteReg  : in std_logic_vector(4 downto 0);    -- Pass through
        MemWrite  : in std_logic;                       -- Control bit. If memory is being written to
        ALUResult : in std_logic_vector(31 downto 0);   -- Output from ALU operation
        WriteData : in std_logic_vector(31 downto 0);   -- Data provided to Memory
        Switches  : in std_logic_vector(15 downto 0);   -- Data from physical switches
        
       
        RegWriteOut     : out std_logic;                    -- Pass through
        WBSrcOut        : out std_logic_vector(1 downto 0); -- Pass through
        WriteRegOut     : out std_logic_vector(4 downto 0); -- Pass Through
        MemOut          : out std_logic_vector(31 downto 0);-- Value read from memory
        ALUResultOut    : out std_logic_vector(31 downto 0);-- Passthrough
        seg_out         : out std_logic_vector(6 downto 0) := "1111111";
        an_out          : out std_logic_vector(3 downto 0) := "1111"
     );
end Memory_Stage;

architecture behavioral of Memory_Stage is

    signal seven_seg_binary : std_logic_vector(15 downto 0) := X"0000";
    signal seven_seg_decimal : std_logic_vector(19 downto 0) := X"00000";

begin

    data_memory_inst : entity work.Data_Memory
        generic map(WIDTH => 32, ADDR_SPACE => 10)
        port map(
            clk => clk, 
            w_en => MemWrite, 
            addr => ALUResult(9 downto 0),
            d_in => WriteData,
            switches => Switches,
            d_out => MemOut,
            seven_seg => seven_seg_binary
        );
        
        
    BinaryToDecimal_inst : entity work.BinaryToBCD
        port map(binary_in => seven_seg_binary, bcd_out => seven_seg_decimal);    
    
    SevenSeg_Driver_inst : entity work.SevenSeg_Driver
        generic map(CLK_FREQ_HZ => 100000000, REFRESH_HZ => 4000)
        port map(clk=> clk_100MHz, dec_in => seven_seg_decimal(15 downto 0), seg => seg_out, an => an_out);
    
    -- Pass throughs
    ALUResultOut <= ALUResult;
    RegWriteOut <= RegWrite;
    WBSrcOut <= WBSrc;
    WriteRegOut <= WriteReg;
    
    
end architecture behavioral;