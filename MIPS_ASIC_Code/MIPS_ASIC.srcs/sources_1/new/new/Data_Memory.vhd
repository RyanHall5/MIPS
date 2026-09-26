-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Design Name : Data_Memory
-- Module Name : Data_Memory - behavioral
-- Project Name : MIPS
-- Target Devices : ASIC (Librelane / OpenLane flow)
--
-- Description : Memory Storage Unit for Memory Stage.
--               ASIC port: FPGA-only debug I/O (physical switches,
--               seven-segment mux word) removed. Implemented as a plain
--               synchronous-write / combinational-read flop array so it
--               synthesizes through Yosys without needing an SRAM macro.
-- ----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Memory is
    GENERIC(
        WIDTH : INTEGER := 32; -- 32 = word memory
        ADDR_SPACE : INTEGER := 6); -- Default 2^6 = 64 Memory spaces
    PORT(
        clk   : in std_logic;                                -- clk signal
        w_en  : in std_logic;                                -- Control bit. If memory should be written to
        addr  : in std_logic_vector(ADDR_SPACE-1 downto 0);  -- Memory addr to write to
        d_in  : in std_logic_vector(WIDTH-1 downto 0);      -- Data value to write

        d_out : out std_logic_vector(WIDTH-1 downto 0)      -- Data read from memory
    );
end Data_Memory;

architecture behavioral of Data_Memory is

    type memory_type is array (0 to 2**ADDR_SPACE-1) of std_logic_vector(WIDTH-1 downto 0);

    signal memory : memory_type := (others => X"00000000");

begin

    writing_proc : process(clk)
    begin
        if rising_edge(clk) then
            if w_en = '1' then
                memory(to_integer(unsigned(addr))) <= d_in;
            end if;
        end if;
    end process writing_proc;

    reading_proc : process(addr, memory)
    begin
        d_out <= memory(to_integer(unsigned(addr)));
    end process reading_proc;

end architecture behavioral;