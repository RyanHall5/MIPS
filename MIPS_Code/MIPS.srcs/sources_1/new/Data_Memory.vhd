-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : Data_Memory
-- Module Name : Data_Memory - dataflow
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Memory Storage Unit for Memory Stage
-- ----------------------------------------------------

library ieee;
use ieee.std_logic_1164.all;
use ieee.numeric_std.all;

entity Data_Memory is
    GENERIC(
        WIDTH : INTEGER := 32;
        ADDR_SPACE : INTEGER := 10);
    PORT(
        clk  : in std_logic;                                -- clk signal
        w_en : in std_logic;                                -- Control bit. If memory should be writtent to
        addr : in std_logic_vector(ADDR_SPACE-1 downto 0);  -- Memory addr to write to
        d_in  : in std_logic_vector(WIDTH-1 downto 0);      -- Data value to write
        switches : in std_logic_vector(15 downto 0);        -- Value on physical switches
        
        d_out : out std_logic_vector(WIDTH-1 downto 0);     -- Data read from memory
        seven_seg : out std_logic_vector(15 downto 0) := X"0000"    -- Data to be written to seven-seg
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
                case (addr) is
                    when "1111111110" => NULL; --1022
                    when "1111111111" => seven_seg <= d_in(15 downto 0);
                    when others => memory(to_integer(unsigned(addr))) <= d_in;
                end case;
            end if;
        end if;
    end process writing_proc;

-- Clocked Reading Process; Has 1-cycle delay so you can't SW then LW immediately 
--    reading_proc : process(clk)
--    begin
--        if rising_edge(clk) then
--            case (addr) is
--                when "1111111110" => d_out <= (X"0000" & switches);
--                when "1111111111" => NULL; --1023
--                when others => d_out <= memory(to_integer(unsigned(addr)));
--            end case;
--        end if;
--    end process reading_proc;

    reading_proc : process(addr, memory, switches)
    begin
        case (addr) is
            when "1111111110" => d_out <= (X"0000" & switches);
            when "1111111111" => d_out <= (others => '0'); -- or leave driven elsewhere
            when others => d_out <= memory(to_integer(unsigned(addr)));
        end case;
    end process reading_proc;

end architecture behavioral;