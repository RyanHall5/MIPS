-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Create Date : 8/2/26
-- Design Name : MIPS_tb
-- Module Name : MIPS_tb - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : MIPS_tb
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS_tb is
end MIPS_tb;

-- Test Programs:

    -- Logical instruction test (Should Result in 0x12345678 being displayed)
--    0  => X"3C011234", -- LUI  $1, 0x1234       = 0x12340000
--    1  => X"34215678", -- ORI  $1, $1, 0x5678    = 0x12345678
--    2  => X"3C02FFFF", -- LUI  $2, 0xFFFF       = 0xFFFF0000
--    3  => X"3442FFFF", -- ORI  $2, $2, 0xFFFF    = 0xFFFFFFFF

--    4  => X"00221824", -- AND  $3, $1, $2        = 0x12345678
--    5  => X"00222025", -- OR   $4, $1, $2        = 0xFFFFFFFF
--    6  => X"00222826", -- XOR  $5, $1, $2        = 0xEDCBA987
--    7  => X"00223027", -- NOR  $6, $1, $2        = 0x00000000

--    8  => X"AC0303FF", -- SW $3, 1023($0)

    -- Fibinacci
--    0 => X"20010001", -- ADDI $1, $zero, 1
--    1 => X"20020001", -- ADDI $2, $zero, 1
--    2 => X"AC0203FF", -- SW $2, 1023($zero)
--    3 => X"00221820", -- Loop: ADD $3, $1, $2
--    4 => X"AC0303FF", -- SW $3, 1023($zero)
--    5 => X"00430820", -- ADD $1, $2, $3
--    6 => X"AC0103FF", -- SW $1, 1023($zero)
--    7 => X"00611020", -- ADD $2, $3, $1
--    8 => X"AC0203FF", -- SW $2, 1023($zero)
--    9 => X"1000FFF9", -- BEQ $zero, $zero, Loop
--        others => X"00000000" -- placeholder values

    -- 1 + 2 = 3 test
--    0 => X"20010001", -- ADDI $1, $0, 1
--    1 => X"20020002", -- ADDI $2, $0, 2
--    2 => X"00221820", -- ADD $3, $1, $2
--    3 => X"AC0303FF", -- SW $3, 1023($0)
--    others => X"00000000" -- placeholder values

    -- Prime Numbers
--    0 => X"20010002", -- ADDI R1, $0, 2
--    1 => X"20020002", -- Outer: ADDI R2, $0, 2
--    2 => X"00222822", -- Inner: SUB R5, R1, R2
--    3 => X"18A0000A", -- BLEZ R5, Prime
--    4 => X"00201820", -- ADD R3, R1, $0
--    5 => X"00432822", -- ModLoop: SUB R5, R2, R3
--    6 => X"1CA00002", -- BGTZ R5, ModDone
--    7 => X"00621822", -- SUB R3, R3, R2
--    8 => X"1000FFFC", -- BEQ $0,$0, ModLoop
--    9 => X"10600002", -- ModDone: BEQ R3,$0, NotPrime
--    10 => X"20420001", -- ADDI R2, R2, 1
--    11 => X"1000FFF6", -- BEQ $0,$0, Inner
--    12 => X"20210001", -- NotPrime: ADDI R1, R1, 1
--    13 => X"1000FFF3", -- BEQ $0,$0, Outer
--    14 => X"AC0103FF", -- Prime: SW R1, 1023($0)
--    15 => X"20210001", -- ADDI R1, R1, 1
--    16 => X"1000FFF0", -- BEQ $0,$0, Outer
--    others => X"00000000" -- placeholder values

-- Arithmetic verificaiton
--    0 => X"20011234", -- ADDI  R1, $0, 0x1234       = 0x00001234
--    1 => X"20025678", -- ADDI  R2, $0, 0x5678       = 0x00005678
--    2 => X"00221820", -- ADD   R3, R1, R2          = 0x000068AC
--    3 => X"00612021", -- ADDU  R4, R3, R1          = 0x00007AE0
--    4 => X"00822822", -- SUB   R5, R4, R2          = 0x00002468
--    5 => X"00A13023", -- SUBU  R6, R5, R1          = 0x00001234
--    6 => X"00C3382A", -- SLT   R7, R6, R3          = 0x00000001
--    7 => X"00C3402B", -- SLTU  R8, R6, R3          = 0x00000001
--    8 => X"29090001", -- SLTI  R9, R8, 1           = 0x00000000
--    9 => X"2D2A0002", -- SLTIU R10, R9, 2          = 0x00000001
--    10 => X"00A15819", -- MULTU R11, R5, R1         = 0x0296B520
--    11 => X"01636021", -- ADDU  R12, R11, R3        = 0x02971DCC
--    12 => X"01846823", -- SUBU  R13, R12, R4        = 0x0296A2EC
--    13 => X"01A57021", -- ADDU  R14, R13, R5        = 0x0296C754
--    14 => X"01C67821", -- ADDU  R15, R14, R6        = 0x0296D988
--    15 => X"01E78021", -- ADDU  R16, R15, R7        = 0x0296D989
--    16 => X"02088821", -- ADDU  R17, R16, R8        = 0x0296D98A
--    17 => X"02299021", -- ADDU  R18, R17, R9        = 0x0296D98A
--    18 => X"024A9821", -- ADDU  R19, R18, R10       = 0x0296D98B
--    19 => X"3C14DC16", -- LUI   R20, 0xDC16         = 0xDC160000
--    20 => X"3694E564", -- ORI   R20, R20, 0xE564    = 0xDC16E564
--    21 => X"0293A821", -- ADDU  R21, R20, R19       = 0xDEADBEEF
--    22 => X"AC1503FF", -- SW    R21, 1023($0)       = 0xDEADBEEF
--    others => X"00000000" -- placeholder values

-- Logical instruction test
-- Expected final result: 0xDEADBEEF at Memory[1023]
--
-- Instructions tested:
--     LUI
--     ANDI
--     ORI
--     XORI
--     AND
--     OR
--     XOR
--     NOR
--
-- Every instruction contributes to the final result.
--
--    0 => X"3C01ABCD", -- LUI   R1, 0xABCD           = 0xABCD0000
--    1 => X"34211234", -- ORI   R1, R1, 0x1234        = 0xABCD1234
--    2 => X"3022FFFF", -- ANDI  R2, R1, 0xFFFF        = 0x00001234
--    3 => X"34434440", -- ORI   R3, R2, 0x4440        = 0x00005674
--    4 => X"386400AA", -- XORI  R4, R3, 0x00AA        = 0x000056DE
--    5 => X"3C051234", -- LUI   R5, 0x1234           = 0x12340000
--    6 => X"00853025", -- OR    R6, R4, R5            = 0x123456DE
--    7 => X"00C53824", -- AND   R7, R6, R5            = 0x12340000
--    8 => X"3C083366", -- LUI   R8, 0x3366           = 0x33660000
--    9 => X"35084110", -- ORI   R8, R8, 0x4110        = 0x33664110
--    10 => X"00E84826", -- XOR  R9, R7, R8            = 0x21524110
--    11 => X"01205027", -- NOR  R10, R9, $0           = 0xDEADBEEF
--    12 => X"AC0A03FF", -- SW   R10, 1023($0)         = 0xDEADBEEF
--    others => X"00000000" -- placeholder values

-- Shift instruction test
-- Expected final result: 0xDEADBEEF at Memory[1023]
--
-- Instructions tested:
--     SLL
--     SRL
--     SRA
--     SLLV
--     SRLV
--     SRAV
--
-- Every shift operation contributes to the final result.
--
--    0 => X"3C019234", -- LUI   R1, 0x9234           = 0x92340000
--    1 => X"34215678", -- ORI   R1, R1, 0x5678        = 0x92345678
--
--    2 => X"20020003", -- ADDI  R2, $0, 3             = 0x00000003
--    3 => X"20030005", -- ADDI  R3, $0, 5             = 0x00000005
--    4 => X"20040002", -- ADDI  R4, $0, 2             = 0x00000002
--    5 => X"20050003", -- ADDI  R5, $0, 3             = 0x00000003
--    6 => X"20060004", -- ADDI  R6, $0, 4             = 0x00000004
--    7 => X"20070001", -- ADDI  R7, $0, 1             = 0x00000001
--
--    8 => X"000140C0", -- SLL   R8, R1, 3             = 0x91A2B3C0
--    9 => X"00084942", -- SRL   R9, R8, 5             = 0x048D159E
--    10 => X"00095083", -- SRA   R10, R9, 2           = 0x01234567
--    11 => X"00AA5804", -- SLLV  R11, R10, R5         = 0x091A2B38
--    12 => X"00CB6006", -- SRLV  R12, R11, R6         = 0x0091A2B3
--    13 => X"00EC6807", -- SRAV  R13, R12, R7         = 0x0048D159
--
--    14 => X"3C0EDE64", -- LUI   R14, 0xDE64           = 0xDE640000
--    15 => X"35CEED96", -- ORI   R14, R14, 0xED96       = 0xDE64ED96
--    16 => X"01CD7821", -- ADDU  R15, R14, R13         = 0xDEADBEEF
--    17 => X"AC0F03FF", -- SW    R15, 1023($0)         = 0xDEADBEEF
--    others => X"00000000" -- placeholder values

-- Load/Store instruction test
-- Expected final result: 0xDEADBEEF at Memory[1023]
--
--    0 => X"3C01DEAD", -- LUI  R1, 0xDEAD           = 0xDEAD0000
--    1 => X"3421BEEF", -- ORI  R1, R1, 0xBEEF        = 0xDEADBEEF
--    2 => X"AC010100", -- SW   R1, 256($0)            = Memory[256] = 0xDEADBEEF
--    3 => X"8C020100", -- LW   R2, 256($0)            = 0xDEADBEEF
--    4 => X"AC0203FF", -- SW   R2, 1023($0)           = 0xDEADBEEF
--    others => X"00000000" -- placeholder values


-- BNE instruction test
-- Expected final result: 0xDEADBEEF at Memory[1023]
--
-- Tests:
--     BNE taken
--     BNE not taken
--
-- First BNE:
--     R1 != R2, so the branch MUST be taken.
--     Instruction 3 must be skipped.
--
-- Second BNE:
--     R1 == R1, so the branch MUST NOT be taken.
--     Instructions 6 and 7 MUST execute.
--
-- If either BNE behaves incorrectly, the final result will be wrong.
--
--    0  => X"20010001", -- ADDI R1, $0, 1              = 0x00000001
--    1  => X"20020002", -- ADDI R2, $0, 2              = 0x00000002
--
--    2  => X"14220001", -- BNE  R1, R2, +1             = TAKEN
--    3  => X"2003FFFF", -- ADDI R3, $0, -1             = SKIPPED
--    4  => X"20030005", -- ADDI R3, $0, 5              = 0x00000005
--
--    5  => X"14210002", -- BNE  R1, R1, +2             = NOT TAKEN
--    6  => X"20040007", -- ADDI R4, $0, 7              = 0x00000007
--    7  => X"20840002", -- ADDI R4, R4, 2              = 0x00000009
--    8  => X"00641820", -- ADD  R3, R3, R4             = 0x0000000E
--
--    9  => X"3C05DEAD", -- LUI  R5, 0xDEAD             = 0xDEAD0000
--    10 => X"34A5BEE1", -- ORI  R5, R5, 0xBEE1         = 0xDEADBEE1
--    11 => X"00A32821", -- ADDU R5, R5, R3             = 0xDEADBEEF
--
--    12 => X"ACA503FF", -- SW   R5, 1023($0)           = 0xDEADBEEF
--    others => X"00000000" -- placeholder values


-- J instruction test
-- Expected final result: 0xDEADBEEF at Memory[1023]
--
-- Tests:
--     J (unconditional jump)
--
-- The instructions between the J and its target must be skipped.
-- They contain nontrivial values so an incorrectly executed instruction
-- will corrupt the final result.
--
--    0  => X"20010005", -- ADDI R1, $0, 5              = 0x00000005
--    1  => X"20020007", -- ADDI R2, $0, 7              = 0x00000007
--    2  => X"00221820", -- ADD  R3, R1, R2             = 0x0000000C
--
--    3  => X"08000008", -- J    Target                 = JUMP TO 8
--    4  => X"2003FFFF", -- ADDI R3, $0, -1             = SKIPPED
--    5  => X"2004FFFF", -- ADDI R4, $0, -1             = SKIPPED
--    6  => X"2005FFFF", -- ADDI R5, $0, -1             = SKIPPED
--    7  => X"2006FFFF", -- ADDI R6, $0, -1             = SKIPPED
--
--    8  => X"3C07DEAD", -- LUI  R7, 0xDEAD             = 0xDEAD0000
--    9  => X"34E7BEE3", -- ORI  R7, R7, 0xBEE3         = 0xDEADBEE3
--    10 => X"00E33821", -- ADDU R7, R7, R3             = 0xDEADBEEF
--
--    11 => X"ACE703FF", -- SW   R7, 1023($0)           = 0xDEADBEEF
--    others => X"00000000" -- placeholder values

-- JAL / JR instruction test
-- Expected final result: 0xDEADBEEF at Memory[1023]
--
-- PC is word-indexed and JAL stores PC + 1 in $31.
--
-- JAL at instruction 2:
--     $31 = 2 + 1 = 3
--     Jump to instruction 10
--
-- JR at instruction 11:
--     Jump to instruction 3 using $31
--
--    0  => X"20010005", -- ADDI R1, $0, 5              = 0x00000005
--    1  => X"20020007", -- ADDI R2, $0, 7              = 0x00000007
--
--    2  => X"0C00000A", -- JAL  10                     = $31 = 0x00000003
--
--    3  => X"03E12820", -- ADD  R5, $31, R1            = 0x00000008
--    4  => X"00853020", -- ADD  R6, R4, R5             = 0x00000014
--    5  => X"0800000F", -- J    15                     = jump to final
--
--    6  => X"2003FFFF", -- ADDI R3, $0, -1             = SKIPPED
--    7  => X"2005FFFF", -- ADDI R5, $0, -1             = SKIPPED
--    8  => X"2006FFFF", -- ADDI R6, $0, -1             = SKIPPED
--    9  => X"2007FFFF", -- ADDI R7, $0, -1             = SKIPPED
--
--    10 => X"00222020", -- ADD  R4, R1, R2             = 0x0000000C
--    11 => X"03E00008", -- JR   $31                    = jump to instruction 3
--
--    12 => X"2008FFFF", -- ADDI R8, $0, -1             = SKIPPED
--    13 => X"2009FFFF", -- ADDI R9, $0, -1             = SKIPPED
--    14 => X"200AFFFF", -- ADDI R10, $0, -1            = SKIPPED
--
--    15 => X"3C07DEAD", -- LUI  R7, 0xDEAD             = 0xDEAD0000
--    16 => X"34E7BEDB", -- ORI  R7, R7, 0xBEDB         = 0xDEADBEDB
--    17 => X"00E63820", -- ADD  R7, R7, R6             = 0xDEADBEEF
--    18 => X"ACE703FF", -- SW   R7, 1023($0)           = 0xDEADBEEF
--    others => X"00000000" -- placeholder values

-- Final remaining-instruction test
-- Tests:
--     SLTIU
--     SRA
--     JALR
--
-- Expected final result: 0xDEADBEEF at Memory[1023]

-- PC is word-indexed.
-- JALR stores PC + 1 in R31.
--
-- Execution path:
--     0 -> 1 -> 2 -> 3 -> 4 -> 5 -> 14 -> 15 -> 6
--     -> 7 -> 8 -> 9 -> 10 -> 11 -> 12 -> 13
--
--    0  => X"20010005", -- ADDI R1, $0, 5              = 0x00000005
--    1  => X"2002FFF0", -- ADDI R2, $0, -16            = 0xFFFFFFF0
--    2  => X"2C23000A", -- SLTIU R3, R1, 10            = 0x00000001
--    3  => X"00022083", -- SRA R4, R2, 2               = 0xFFFFFFFC
--    4  => X"2005000E", -- ADDI R5, $0, 14             = 0x0000000E
--    5  => X"00A0F809", -- JALR R31, R5                = R31 = 0x00000006
--
--    6  => X"3C07DEAD", -- LUI R7, 0xDEAD              = 0xDEAD0000
--    7  => X"34E7BEEB", -- ORI R7, R7, 0xBEEB          = 0xDEADBEEB
--    8  => X"00E44020", -- ADD R8, R7, R4               = 0xDEADBEE7
--    9  => X"01034020", -- ADD R8, R8, R3               = 0xDEADBEE8
--    10 => X"011F4020", -- ADD R8, R8, R31              = 0xDEADBEEE
--    11 => X"01064020", -- ADD R8, R8, R6               = 0xDEADBEEF
--    12 => X"20091234", -- ADDI R9, $0, 0x1234          = 0x00001234
--    13 => X"AC0803FF", -- SW R8, 1023($0)               = 0xDEADBEEF
--
--    14 => X"20060001", -- ADDI R6, $0, 1               = 0x00000001
--    15 => X"03E00008", -- JR $31                       = return to instruction 6
--
--    others => X"00000000" -- placeholder values



architecture behavioral of MIPS_tb is

    constant clk_period : time := 10ns;

    signal clk_sig              : std_logic;
    signal fetch_reset_sig      : std_logic := '0';
    signal switches_sig         : std_logic_vector(15 downto 0) := "0000000000000000";
    signal seven_seg_sig        : std_logic_vector(6 downto 0) := "1111111";
    signal active_digit_sig     : std_logic_vector(3 downto 0) := "1111";
    signal expected_seven_seg   : std_logic_vector(6 downto 0) := "0000000";
    signal expected_active_digit: std_logic_vector(3 downto 0) := "0000";


begin


    MIPS_inst : entity work.MIPS
        port map(
            clk_100MHz => clk_sig, 
            fetch_reset => fetch_reset_sig,
            switches_in => switches_sig,
            seven_seg_out => seven_seg_sig,
            active_digit_out => active_digit_sig
        );

    clk_process: process
	begin
		clk_sig <= '0';
		wait for clk_period/2;
		clk_sig <= '1';
		wait for clk_period/2;
	end process clk_process;


    stim_process : process
    begin
    
        fetch_reset_sig <= '1';
        
        wait for clk_period/4;
        
        fetch_reset_sig <= '0';
    
        wait;
    end process stim_process;
end architecture behavioral;