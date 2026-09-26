-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT)
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/12/26
-- Design Name : Shifter
-- Module Name : shiftN - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : N-bit shifter shared across SLL/SLLV, SRL/SRLV, SRA/SRAV. 
-- shift_amt is muxec between Shamt and in2 in EX this component only cares about shift
-- type, not operand source.
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity shiftN is
    GENERIC(
        N : INTEGER := 32);
    PORT(
        A         : IN  std_logic_vector(N-1 downto 0);  -- value to shift
        shift_amt : IN  std_logic_vector(4 downto 0);     -- resolved shift amount
        sel       : IN  std_logic_vector(1 downto 0);      -- "00"=SLL "01"=SRL "10"=SRA
        Y         : OUT std_logic_vector(N-1 downto 0)
        );
end shiftN;

architecture behavioral of shiftN is

    function reverse_bits(v : std_logic_vector) return std_logic_vector is
        variable r : std_logic_vector(v'range);
    begin
        for i in v'range loop
            r(v'high - i) := v(i);
        end loop;
        return r;
    end function;

    signal shamt_int   : integer range 0 to N-1;
    signal fill_bit     : std_logic;
    signal shifter_in    : std_logic_vector(N-1 downto 0);
    signal shifter_out   : std_logic_vector(N-1 downto 0);
    signal ext           : std_logic_vector(2*N-1 downto 0);

begin

    shamt_int <= to_integer(unsigned(shift_amt));

    -- SLL uses the bit-reversed input; SRL/SRA use A directly
    shifter_in <= reverse_bits(A) when sel = "00" else A;

    -- fill bit: sign bit only for SRA, else 0 (covers SLL's reversed-fill too, always 0)
    fill_bit <= A(N-1) when sel = "10" else '0';

    -- single barrel shifter core: right-shift-with-fill
    ext <= (N*2-1 downto N => fill_bit) & shifter_in;  -- N fill bits concatenated on the left
    shifter_out <= ext(N-1+shamt_int downto shamt_int) when shamt_int > 0 else shifter_in;

    -- SLL result needs the bit-reversal undone
    Y <= reverse_bits(shifter_out) when sel = "00" else shifter_out;

end architecture behavioral;