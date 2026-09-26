-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Design Name : Hazard_Detection_Unit
-- Module Name : Hazard_Detection_Unit - behavioral
-- Project Name : MIPS
-- Target Devices : Basys3
--
-- Description : Detects load-use hazards: the instruction currently
-- latched in ID/EX (Reg2) is a load, and the instruction currently
-- being decoded (in IF/ID) reads the register that load will write.
-- Forwarding cannot fix this case because the loaded value does not
-- exist yet (Data_Memory hasn't been read). When asserted, Stall
-- freezes PC/IF_ID for one cycle and injects a bubble into ID_EX.
-- ----------------------------------------------------
library ieee;
use ieee.std_logic_1164.all;

entity Hazard_Detection_Unit is
    PORT(
        IDEX_WBSrc  : in std_logic_vector(1 downto 0); -- Reg2 (ID/EX) WBSrc out; "01" = load
        IDEX_RtDest : in std_logic_vector(4 downto 0);  -- Reg2 (ID/EX) RtDest out (load's destination reg)

        IFID_Rs     : in std_logic_vector(4 downto 0);  -- rs field of instruction currently in Decode
        IFID_Rt     : in std_logic_vector(4 downto 0);  -- rt field of instruction currently in Decode

        Stall       : out std_logic
    );
end Hazard_Detection_Unit;

architecture behavioral of Hazard_Detection_Unit is
begin
    process(all)
    begin
        if IDEX_WBSrc = "01" and IDEX_RtDest /= "00000" and
           (IDEX_RtDest = IFID_Rs or IDEX_RtDest = IFID_Rt) then
            Stall <= '1';
        else
            Stall <= '0';
        end if;
    end process;
end architecture behavioral;