-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/3/26
-- Design Name : SevenSeg_Driver
-- Module Name : SevenSeg_Driver - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Takes BCD vector, and clock. Divides clock, and displays value
-- ----------------------------------------------------

library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity SevenSeg_Driver is
    generic (
        CLK_FREQ_HZ   : integer := 10000000; -- system clock frequency
        REFRESH_HZ    : integer := 4000          -- per-digit refresh rate
    );
    port (
        clk     : in  std_logic;
        dec_in  : in  std_logic_vector(15 downto 0) := "0000000000000000";
        seg     : out std_logic_vector(6 downto 0) := "1111111"; -- gfedcba, active-low
        an      : out std_logic_vector(3 downto 0) := "1111" -- active-low digit enable
    );
end entity SevenSeg_Driver;

architecture Behavioral of SevenSeg_Driver is

    -- Number of clk cycles per digit refresh tick
    constant DIV_MAX : integer := CLK_FREQ_HZ / REFRESH_HZ;

    signal div_counter : integer range 0 to DIV_MAX - 1 := 0;
    signal digit_sel    : unsigned(1 downto 0) := (others => '0');

    signal current_bcd : std_logic_vector(3 downto 0);

begin

    -- Clock divider + digit rotation
    -- Every DIV_MAX clk cycles, advance to the next digit (0 -> 1 -> 2 -> 3 -> 0...)
    process (clk)
    begin
        if rising_edge(clk) then
            if div_counter = DIV_MAX - 1 then
                div_counter <= 0;
                digit_sel   <= digit_sel + 1;
            else
                div_counter <= div_counter + 1;
            end if;
        end if;
    end process;

    -- Select the active digit's 4-bit BCD group out of dec_in
    with digit_sel select
        current_bcd <=
            dec_in(3 downto 0)   when "00",
            dec_in(7 downto 4)   when "01",
            dec_in(11 downto 8)  when "10",
            dec_in(15 downto 12) when others;

    -- Anode select: drive only the active digit low, all others high
    with digit_sel select
        an <=
            "1110" when "00",
            "1101" when "01",
            "1011" when "10",
            "0111" when others;

    -- BCD -> 7-segment decode (active-low segments, gfedcba)
    process (current_bcd)
    begin
        case current_bcd is
            when "0000" => seg <= "1000000"; -- 0
            when "0001" => seg <= "1111001"; -- 1
            when "0010" => seg <= "0100100"; -- 2
            when "0011" => seg <= "0110000"; -- 3
            when "0100" => seg <= "0011001"; -- 4
            when "0101" => seg <= "0010010"; -- 5
            when "0110" => seg <= "0000010"; -- 6
            when "0111" => seg <= "1111000"; -- 7
            when "1000" => seg <= "0000000"; -- 8
            when "1001" => seg <= "0010000"; -- 9
            when others => seg <= "1111111"; -- blank for invalid BCD (10-15)
        end case;
    end process;

end architecture Behavioral;