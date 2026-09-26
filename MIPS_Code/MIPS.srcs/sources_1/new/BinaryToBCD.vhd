library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity BinaryToBCD is
    Port (
        binary_in : in  STD_LOGIC_VECTOR (15 downto 0) := X"0000"; -- 16-bit binary input
        bcd_out   : out STD_LOGIC_VECTOR (19 downto 0) := X"00000"  -- 5 BCD digits (4 bits each)
    );
end BinaryToBCD;

architecture Behavioral of BinaryToBCD is

begin
    process(binary_in)
        -- Temporary variable to hold shifted bits (16 input bits + 20 BCD output bits)
        variable shift_reg : UNSIGNED(35 downto 0);
        
        -- Aliases to easily isolate individual BCD columns inside the shift register
        alias bcd_ones     : UNSIGNED(3 downto 0) is shift_reg(19 downto 16);
        alias bcd_tens     : UNSIGNED(3 downto 0) is shift_reg(23 downto 20);
        alias bcd_hundreds : UNSIGNED(3 downto 0) is shift_reg(27 downto 24);
        alias bcd_thousands: UNSIGNED(3 downto 0) is shift_reg(31 downto 28);
        alias bcd_tenthous : UNSIGNED(3 downto 0) is shift_reg(35 downto 32);
        
    begin
        -- Step 1: Initialize the scratchpad register with 0s and place binary input at the bottom
        shift_reg := (others => '0');
        shift_reg(15 downto 0) := UNSIGNED(binary_in);
        
        -- Step 2: Loop 16 times (once for each bit of the input)
        for i in 0 to 15 loop
            
            -- If any BCD column is 5 or greater, add 3 before shifting
            if bcd_ones >= 5 then
                bcd_ones := bcd_ones + 3;
            end if;
            
            if bcd_tens >= 5 then
                bcd_tens := bcd_tens + 3;
            end if;
            
            if bcd_hundreds >= 5 then
                bcd_hundreds := bcd_hundreds + 3;
            end if;
            
            if bcd_thousands >= 5 then
                bcd_thousands := bcd_thousands + 3;
            end if;
            
            -- Note: bcd_tenthous will never exceed 6 for a 16-bit max value of 65,535, 
            -- so checking it is optional but added here for completeness.
            if bcd_tenthous >= 5 then
                bcd_tenthous := bcd_tenthous + 3;
            end if;
            
            -- Shift the entire register left by 1 bit position
            shift_reg := shift_left(shift_reg, 1);
            
        end loop;
        
        -- Step 3: Assign the upper 20 bits containing BCD data to output
        bcd_out <= STD_LOGIC_VECTOR(shift_reg(35 downto 16));
        
    end process;
end Behavioral;
