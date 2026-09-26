-- ----------------------------------------------------
-- Company : Rochester Institute of Technology (RIT )
-- Engineer : Ryan Hall (rah3587@rit.edu)
--
-- Design Name : MIPS
-- Module Name : MIPS - behavioral
-- Project Name : MIPS
-- Target Devices : ASIC (Librelane / OpenLane flow)
--
-- Description : 5-stage pipelined MIPS core.
--               ASIC port notes:
--                 - Basys3 board I/O removed: switches_in, seven_seg_out,
--                   active_digit_out, and the (already-unused) clock
--                   divider stub are gone. Data_Memory/Memory_Stage were
--                   trimmed to match.
--                 - clk_100MHz -> clk, fetch_reset -> rst : renamed to be
--                   board-agnostic. Update instantiations/testbench
--                   accordingly.
-- ----------------------------------------------------
library IEEE;
use IEEE.STD_LOGIC_1164.ALL;
use IEEE.NUMERIC_STD.ALL;

entity MIPS is
    port(
        clk : in std_logic;
        rst : in std_logic;
        
	    pc_debug : out std_logic_vector(31 downto 0);
	    
	    -- Data Memory debug signals for ASIC
	    addr_debug : out std_logic_vector(5 downto 0);
	    we_debug   : out std_logic;
	    din_debug  : out std_logic_vector(31 downto 0)
	);
end MIPS;

architecture behavioral of MIPS is
    
    -- Hazard Check Signals
    signal HazardMux_ALUin1 : std_logic_vector(31 downto 0);
    signal HazardMux_ALUin2 : std_logic_vector(31 downto 0);
    signal HazardMux_StoreData : std_logic_vector(31 downto 0);

    -- Branch Hazard Signals
    signal BranchHazard_RD1out : std_logic_vector(31 downto 0);
    signal BranchHazard_RD2out : std_logic_vector(31 downto 0);

    -- Reg1 Inputs
    signal Reg1_instr_in : std_logic_vector(31 downto 0);
    signal Reg1_pc_in    : std_logic_vector(31 downto 0);

    -- Reg1 Outputs
    signal Reg1_instr_out : std_logic_vector(31 downto 0);
    signal Reg1_pc_out    : std_logic_vector(31 downto 0);

    -- Reg2 Inputs
    signal Reg2_RegWrite_in   : std_logic;
    signal Reg2_WBSrc_in      : std_logic_vector(1 downto 0);
    signal Reg2_MemWrite_in   : std_logic;
    signal Reg2_ALUControl_in : std_logic_vector(3 downto 0);
    signal Reg2_ALUSrc_in     : std_logic;
    signal Reg2_RegDst_in     : std_logic_vector(1 downto 0);
    signal Reg2_RD1_in        : std_logic_vector(31 downto 0);
    signal Reg2_RD2_in        : std_logic_vector(31 downto 0);
    signal Reg2_RsDest_in     : std_logic_vector(4 downto 0);
    signal Reg2_RtDest_in     : std_logic_vector(4 downto 0);
    signal Reg2_RdDest_in     : std_logic_vector(4 downto 0);
    signal Reg2_Imm_in        : std_logic_vector(31 downto 0);
    signal Reg2_Shamt_in      : std_logic_vector(4 downto 0);
    signal Reg2_ShamtSrc_in   : std_logic;
    signal Reg2_pc_in         : std_logic_vector(31 downto 0);

    -- Reg2 Outputs
    signal Reg2_RegWrite_out   : std_logic;
    signal Reg2_WBSrc_out      : std_logic_vector(1 downto 0);
    signal Reg2_MemWrite_out   : std_logic;
    signal Reg2_ALUControl_out : std_logic_vector(3 downto 0);
    signal Reg2_ALUSrc_out     : std_logic;
    signal Reg2_RegDst_out     : std_logic_vector(1 downto 0);
    signal Reg2_RD1_out        : std_logic_vector(31 downto 0);
    signal Reg2_RD2_out        : std_logic_vector(31 downto 0);
    signal Reg2_RsDest_out     : std_logic_vector(4 downto 0);
    signal Reg2_RtDest_out     : std_logic_vector(4 downto 0);
    signal Reg2_RdDest_out     : std_logic_vector(4 downto 0);
    signal Reg2_Imm_out        : std_logic_vector(31 downto 0);
    signal Reg2_Shamt_out      : std_logic_vector(4 downto 0);
    signal Reg2_ShamtSrc_out   : std_logic;
    signal Reg2_pc_out         : std_logic_vector(31 downto 0);

    -- Reg3 Inputs
    signal Reg3_RegWrite_in  : std_logic;
    signal Reg3_WBSrc_in     : std_logic_vector(1 downto 0);
    signal Reg3_MemWrite_in  : std_logic;
    signal Reg3_ALUResult_in : std_logic_vector(31 downto 0);
    signal Reg3_WriteData_in : std_logic_vector(31 downto 0);
    signal Reg3_WriteReg_in  : std_logic_vector(4 downto 0);

    -- Reg3 Outputs
    signal Reg3_RegWrite_out  : std_logic;
    signal Reg3_WBSrc_out     : std_logic_vector(1 downto 0);
    signal Reg3_MemWrite_out  : std_logic;
    signal Reg3_ALUResult_out : std_logic_vector(31 downto 0);
    signal Reg3_WriteData_out : std_logic_vector(31 downto 0);
    signal Reg3_WriteReg_out  : std_logic_vector(4 downto 0);

    -- Reg4 Inputs
    signal Reg4_RegWrite_in  : std_logic;
    signal Reg4_WBSrc_in     : std_logic_vector(1 downto 0);
    signal Reg4_WriteReg_in  : std_logic_vector(4 downto 0);
    signal Reg4_Mem_in       : std_logic_vector(31 downto 0);
    signal Reg4_ALUResult_in : std_logic_vector(31 downto 0);

    -- Reg4 Outputs
    signal Reg4_RegWrite_out  : std_logic;
    signal Reg4_WBSrc_out     : std_logic_vector(1 downto 0);
    signal Reg4_WriteReg_out  : std_logic_vector(4 downto 0);
    signal Reg4_Mem_out       : std_logic_vector(31 downto 0);
    signal Reg4_ALUResult_out : std_logic_vector(31 downto 0);

    -- Wraparound signals
    signal Wrap_RegWriteAddr : std_logic_vector(4 downto 0);
    signal Wrap_RegWriteData : std_logic_vector(31 downto 0);
    signal Wrap_RegWriteEn : std_logic;
    signal Wrap_TakeBranch : std_logic;
    signal Wrap_BranchTarget : std_logic_vector(31 downto 0);
    signal LoadUse_Stall : std_logic;

begin

    -- ASIC Outputs
    pc_debug <= Reg1_pc_in;        
    addr_debug <= Reg3_ALUResult_out(5 downto 0);
    we_debug   <= Reg3_MemWrite_out;
    din_debug  <= Reg3_WriteData_out;

    Fetch_Stage_inst : entity work.Fetch_Stage
        port map(
            clk => clk,

            rst => rst,
            stall => LoadUse_Stall,
            take_branch => Wrap_TakeBranch,
            branch_target => Wrap_BranchTarget,

            instruction => Reg1_instr_in,
            pcOut => Reg1_pc_in
       );

    IF_ID_inst : entity work.IF_ID
        port map(
            clk => clk,
            flush => Wrap_TakeBranch,
            stall => LoadUse_Stall,

            instruction => Reg1_instr_in,
            pc => Reg1_pc_in,

            instructionOut => Reg1_instr_out,
            pcOut => Reg1_pc_out
        );

    Hazard_Detection_Unit_inst : entity work.Hazard_Detection_Unit
        port map(
            IDEX_WBSrc  => Reg2_WBSrc_out,
            IDEX_RtDest => Reg2_RtDest_out,

            IFID_Rs => Reg1_instr_out(25 downto 21),
            IFID_Rt => Reg1_instr_out(20 downto 16),

            Stall => LoadUse_Stall
        );

    Branch_Hazard_Check_inst : entity work.Branch_Hazard_Check
    port map(
        RsAddr => Reg2_RsDest_in,
        RtAddr => Reg2_RtDest_in,
        RD1in => Reg2_RD1_in,
        RD2in => Reg2_RD2_in,

        -- Forward #1: live Execute-stage output (not yet latched into EX/MEM)
        ExFwd_addr      => Reg3_WriteReg_in,
        ExFwd_RegWrite  => Reg3_RegWrite_in,
        ExFwd_data      => Reg3_ALUResult_in,

        -- Forward #2: latched EX/MEM register
        MemFwd_addr     => Reg3_WriteReg_out,
        MemFwd_RegWrite => Reg3_RegWrite_out,
        MemFwd_data     => Reg3_ALUResult_out,

        -- Forward #3: latched MEM/WB register
        WbFwd_addr      => Reg4_WriteReg_out,
        WbFwd_RegWrite  => Reg4_RegWrite_out,
        WbFwd_data      => Reg4_ALUResult_out,

        RD1out => BranchHazard_RD1out,
        RD2out => BranchHazard_RD2out
    );

    Branching_Unit_inst : entity work.Branching_Unit
    port map(
        pc_id => Reg1_pc_out,
        imm_ext => Reg2_Imm_in,              -- Decode_Stage's ImmOut
        j_imm => Reg1_instr_out(25 downto 0),
        rs_data => BranchHazard_RD1out,
        rt_data => BranchHazard_RD2out,
        Opcode => Reg1_instr_out(31 downto 26),
        Funct => Reg1_instr_out(5 downto 0),
        take_branch => Wrap_TakeBranch,
        branch_target => Wrap_BranchTarget
    );

    Decode_Stage_inst : entity work.Decode_Stage
        port map(
            clk => clk,

            Instruction => Reg1_instr_out,
            RegWriteAddr => Wrap_RegWriteAddr,
            RegWriteData => Wrap_RegWriteData,
            RegWriteEn => Wrap_RegWriteEn,
            pcin => Reg1_pc_out,

            pcout => Reg2_pc_in,
            RegWrite => Reg2_RegWrite_in,
            WBSrc => Reg2_WBSrc_in,
            MemWrite => Reg2_MemWrite_in,
            ALUControl => Reg2_ALUControl_in,
            ALUSrc => Reg2_ALUSrc_in,
            RegDst => Reg2_RegDst_in,
            RD1 => Reg2_RD1_in,
            RD2 => Reg2_RD2_in,
            RsDest => Reg2_RsDest_in,
            RtDest => Reg2_RtDest_in,
            RdDest => Reg2_RdDest_in,
            ImmOut => Reg2_Imm_in,
            Shamt => Reg2_Shamt_in,
            ShamtSrc => Reg2_ShamtSrc_in
        );

    ID_EX_inst : entity work.ID_EX
        port map(
            clk => clk,
            bubble => LoadUse_Stall,

            RegWrite => Reg2_RegWrite_in,
            WBSrc => Reg2_WBSrc_in,
            MemWrite =>Reg2_MemWrite_in,
            ALUControl => Reg2_ALUControl_in,
            ALUSrc => Reg2_ALUSrc_in,
            RegDst => Reg2_RegDst_in,
            RD1 => Reg2_RD1_in,
            RD2 => Reg2_RD2_in,
            RsDest => Reg2_RsDest_in,
            RtDest => Reg2_RtDest_in,
            RdDest => Reg2_RdDest_in,
            Imm => Reg2_Imm_in,
            Shamt => Reg2_Shamt_in,
            ShamtSrc => Reg2_ShamtSrc_in,
            pc => Reg2_pc_in,

            pcOut => Reg2_pc_out,
            RegWriteOut => Reg2_RegWrite_Out,
            WBSrcOut => Reg2_WBSrc_Out,
            MemWriteOut =>Reg2_MemWrite_Out,
            ALUControlOut => Reg2_ALUControl_Out,
            ALUSrcOut => Reg2_ALUSrc_Out,
            RegDstOut => Reg2_RegDst_Out,
            RD1Out => Reg2_RD1_Out,
            RD2Out => Reg2_RD2_Out,
            RsDestOut => Reg2_RsDest_Out,
            RtDestOut => Reg2_RtDest_Out,
            RdDestOut => Reg2_RdDest_Out,
            ImmOut => Reg2_Imm_Out,
            ShamtOut => Reg2_Shamt_out,
            ShamtSrcOut => Reg2_ShamtSrc_out
        );

    Hazard_Check_inst : entity work.Hazard_Check
        port map(

            Reg2_addr1_out => Reg2_RsDest_out,
            Reg2_addr2_out => Reg2_RtDest_out,

            Reg2_ALUSrc_out => Reg2_ALUSrc_out,
            Reg2_RD1data_out => Reg2_RD1_out,
            Reg2_RD2data_out => Reg2_RD2_out,
            Reg2_Imm_out => Reg2_Imm_out,

            Reg3_addr_out => Reg3_WriteReg_out,
            Reg3_RegWrite_out => Reg3_RegWrite_out,
            Reg3_data_out => Reg3_ALUResult_out,

            Reg4_addr_out => Reg4_WriteReg_out,
            Reg4_RegWrite_out => Reg4_RegWrite_out,
            Reg4_ALUResult_out => Reg4_ALUResult_out,
            Reg4_MemResult_out => Reg4_Mem_out,
            Reg4_WBSrc_out => Reg4_WBSrc_out,

            ALUin1 => HazardMux_ALUin1,
            ALUin2 => HazardMux_ALUin2,
            StoreData => HazardMux_StoreData
        );

    Execute_Stage_inst : entity work.Execute_Stage
        port map(
            RegWrite => Reg2_RegWrite_Out,
            WBSrc => Reg2_WBSrc_Out,
            MemWrite =>Reg2_MemWrite_Out,
            ALUControl => Reg2_ALUControl_Out,
            RegDst => Reg2_RegDst_Out,
            ALUin1 => HazardMux_ALUin1,
            ALUin2 => HazardMux_ALUin2,
            StoreData => HazardMux_StoreData,
            RtDest => Reg2_RtDest_Out,
            RdDest => Reg2_RdDest_Out,
            Shamt => Reg2_Shamt_out,
            ShamtSrc => Reg2_ShamtSrc_out,
            pc => Reg2_pc_out,

            RegWriteOut => Reg3_RegWrite_in,
            WBSrcOut => Reg3_WBSrc_in,
            MemWriteOut => Reg3_MemWrite_in,
            ALUResult => Reg3_ALUResult_in,
            WriteData => Reg3_WriteData_in,
            WriteReg => Reg3_WriteReg_in
        );

    EX_MEM_inst : entity work.EX_MEM
        port map(
            clk => clk,

            RegWrite => Reg3_RegWrite_in,
            WBSrc => Reg3_WBSrc_in,
            MemWrite => Reg3_MemWrite_in,
            ALUResult => Reg3_ALUResult_in,
            WriteData => Reg3_WriteData_in,
            WriteReg => Reg3_WriteReg_in,

            RegWriteOut => Reg3_RegWrite_out,
            WBSrcOut => Reg3_WBSrc_out,
            MemWriteOut => Reg3_MemWrite_out,
            ALUResultOut => Reg3_ALUResult_out,
            WriteDataOut => Reg3_WriteData_out,
            WriteRegOut => Reg3_WriteReg_out
        );

    Memory_Stage_inst : entity work.Memory_Stage
        port map(
            clk => clk,

            RegWrite => Reg3_RegWrite_out,
            WBSrc => Reg3_WBSrc_out,
            WriteReg => Reg3_WriteReg_out,
            MemWrite => Reg3_MemWrite_out,
            ALUResult => Reg3_ALUResult_out,
            WriteData => Reg3_WriteData_out,

            RegWriteOut => Reg4_RegWrite_in,
            WBSrcOut => Reg4_WBSrc_in,
            WriteRegOut => Reg4_WriteReg_in,
            MemOut => Reg4_Mem_in,
            ALUResultOut => Reg4_ALUResult_in
        );

    MEM_WB_inst : entity work.MEM_WB
        port map(
            clk => clk,

            RegWrite => Reg4_RegWrite_in,
            WBSrc => Reg4_WBSrc_in,
            WriteReg => Reg4_WriteReg_in,
            Mem => Reg4_Mem_in,
            ALUResult => Reg4_ALUResult_in,

            RegWriteOut => Reg4_RegWrite_out,
            WBSrcOut => Reg4_WBSrc_out,
            WriteRegOut => Reg4_WriteReg_out,
            MemOut => Reg4_Mem_out,
            ALUResultOut => Reg4_ALUResult_out
        );

    Writeback_Stage_inst : entity work.Writeback_Stage
        port map(
            RegWrite => Reg4_RegWrite_out,
            WBSrc => Reg4_WBSrc_out,
            ALUResult => Reg4_ALUResult_out,
            ReadData => Reg4_Mem_out,
            WriteReg => Reg4_WriteReg_out,

            RegWriteOut => Wrap_RegWriteEn,
            WriteRegOut => Wrap_RegWriteAddr,
            Result => Wrap_RegWriteData
        );

end architecture behavioral;
