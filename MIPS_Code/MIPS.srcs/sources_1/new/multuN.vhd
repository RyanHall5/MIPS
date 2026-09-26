-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : multuN
-- Module Name : multuN - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : N-bit Multiplication Unit
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity multuN is
    GENERIC(
        N : INTEGER := 32);
    PORT(
        A       : IN  std_logic_vector((N/2)-1 downto 0);   -- Factor 1
        B       : IN  std_logic_vector((N/2)-1 downto 0);   -- Factor 2
        Product : OUT std_logic_vector(N-1 downto 0)    -- output
        );
end multuN;




architecture behavioral of multuN is

    type adder_type is (FA, HA);
    type adder_matrix is array (0 to (N/2)-2, 0 to (N/2)-1) of adder_type;
    
    function init_adder_grid return adder_matrix is
        variable grid : adder_matrix := (others => (others => FA));
    begin
    
        for i in grid'range(1) loop
            grid(i, 0) := HA;
        end loop;
    
        grid(0, (N/2)-1) := HA;
    
        return grid;
    end function;
    
    type signal_matrix is array (0 to (N/2)-1) of std_logic_vector((N/2)-1 downto 0);
    
    signal PP_matrix, Sum_matrix, Carry_matrix: signal_matrix;

    -- Example: Initialize everything to FA except the (first col) and (first row last col)
    constant my_adder_grid : adder_matrix := init_adder_grid;

begin

    -- Partial products A & B for each combination A0&B0 A1&B0 A0&B1, etc
    PP_ROW_GEN: for i in 0 to (N/2)-1 generate
        PP_COL_GEN: for j in 0 to (N/2)-1 generate
            PP_matrix(i)(j) <= A(j) and B(i);
        end generate;
    end generate;


    -- First row of sums in just partial products
    Sum_matrix(0) <= PP_matrix(0);


    -- Nested generate loops to build the 32x32 grid    
    ROW_GEN: for i in 0 to (N/2)-2 generate
        COL_GEN: for j in 0 to (N/2)-2 generate
        
            -- Condition 1: Instantiate Full Adder (all columns except for first)
            FA_INST: if my_adder_grid(i, j) = FA generate
                U_FA: entity work.FullAdder port map (
                    A    => PP_matrix(i+1)(j),
                    B    => Sum_matrix(i)(j+1),
                    Cin  => Carry_matrix(i)(j-1),
                    Sum  => Sum_matrix(i+1)(j),
                    Cout => Carry_matrix(i)(j)
                );
            end generate FA_INST;

            -- Condition 2: Instantiate Half Adder (all of the first column)
            HA_INST: if my_adder_grid(i, j) = HA generate
                U_HA: entity work.HalfAdder port map (
                    A    => PP_matrix(i+1)(j),
                    B    => Sum_matrix(i)(j+1),
                    Sum  => Sum_matrix(i+1)(j),
                    Cout => Carry_matrix(i)(j)
                );
            end generate HA_INST;
            
        end generate COL_GEN;
    end generate ROW_GEN;
    
    --edge case generate
    END_COL_GEN : for i in 0 to (N/2)-2 generate
    
        -- Should be i = 1 to i = (N/2)-2
        FA_INST: if my_adder_grid(i, (N/2)-1) = FA generate
            U_FA: entity work.FullAdder port map (
                A    => PP_matrix(i+1)((N/2)-1),
                B    => Carry_matrix(i-1)((N/2)-1),
                Cin  => Carry_matrix(i)((N/2)-2),
                Sum  => Sum_matrix(i+1)((N/2)-1),
                Cout => Carry_matrix(i)((N/2)-1)
            );
        end generate FA_INST;
            
        -- Condition 2: Instantiate Half Adder (should just be i = 0)
        HA_INST: if my_adder_grid(i, (N/2)-1) = HA generate
            U_HA: entity work.HalfAdder port map (
                A    => PP_matrix(i+1)((N/2)-1),
                B    => Carry_matrix(i)((N/2)-2),
                Sum  => Sum_matrix(i+1)((N/2)-1),
                Cout => Carry_matrix(i)((N/2)-1)
            );
        end generate HA_INST;
            
    end generate END_COL_GEN;
    
    
    Product_Proc : process(Sum_matrix, Carry_matrix)
    begin
        for i in 0 to (N/2)-1 loop
            Product(i) <= Sum_matrix(i)(0);
        end loop;
        Product(N-2 downto N/2) <= Sum_matrix((N/2)-1)((N/2)-1 downto 1);
        Product(N-1) <= Carry_matrix((N/2)-2)((N/2)-1);
    end process Product_Proc;

end architecture behavioral;