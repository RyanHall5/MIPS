library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity clock_divider is
    Port ( 
        clk_100MHz : in  STD_LOGIC;  -- Onboard 100 MHz clock input
        clk_slow    : out STD_LOGIC   -- Output 7 Hz square-wave clock
    );
end clock_divider;

architecture Behavioral of clock_divider is
    -- A 23-bit counter register can hold values up to 8,388,607
    signal counter   : unsigned(31 downto 0) := (others => '0');
    signal clk_state : std_logic := '0';
begin

    process(clk_100MHz)
    begin
        if rising_edge(clk_100MHz) then
            -- 100,000,000 / (Target_Hz * 2) - 1 = Counter Limit
            if counter = 49 then
                counter   <= (others => '0');
                clk_state <= not clk_state; -- Toggle output signal
            else
                counter   <= counter + 1;
            end if;
        end if;
    end process;
    
    -- Assign the internal toggle state to the output pin
    clk_slow <= clk_state;

end Behavioral;
