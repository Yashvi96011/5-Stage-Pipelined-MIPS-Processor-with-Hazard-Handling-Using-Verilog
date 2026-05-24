module MIPS_Pipeline (
    input clk,
    input reset
);

// ── IF Stage wires ────────────────────────────────────────
wire [31:0] pc_out, pc4, instruction, next_pc;
wire        pcsrc, PCWrite;

// ── IF/ID wires ───────────────────────────────────────────
wire [31:0] ifid_pc4, ifid_instruction;
wire        IF_ID_Write, flush_ifid;

// ── ID Stage wires ────────────────────────────────────────
wire [31:0] read_data1, read_data2, sign_ext_out;
wire [4:0]  id_rs, id_rt, id_rd;
wire [5:0]  id_funct;
wire        ctrl_RegDst,  ctrl_ALUSrc,  ctrl_MemtoReg;
wire        ctrl_RegWrite,ctrl_MemRead, ctrl_MemWrite;
wire        ctrl_Branch;
wire [1:0]  ctrl_ALUOp;
wire        stall, flush_idex;

// Stall muxed control signals
wire        s_RegDst,  s_ALUSrc,  s_MemtoReg;
wire        s_RegWrite,s_MemRead, s_MemWrite;
wire        s_Branch;
wire [1:0]  s_ALUOp;

// ── ID/EX wires ───────────────────────────────────────────
wire        idex_RegWrite, idex_MemtoReg;
wire        idex_Branch,   idex_MemRead, idex_MemWrite;
wire        idex_RegDst,   idex_ALUSrc;
wire [1:0]  idex_ALUOp;
wire [31:0] idex_PC4, idex_read_data1, idex_read_data2, idex_sign_ext;
wire [4:0]  idex_rs,  idex_rt, idex_rd;
wire [5:0]  idex_funct;

// ── EX Stage wires ────────────────────────────────────────
wire [31:0] sl2_out, ex_branch_target;
wire [31:0] fw_alu_a, fw_alu_b, alu_input_b, ex_alu_result;
wire        ex_zero;
wire [4:0]  ex_write_reg;
wire [3:0]  alu_ctrl_out;
wire [1:0]  forwardA, forwardB;

// ── EX/MEM wires ──────────────────────────────────────────
wire        exmem_RegWrite, exmem_MemtoReg;
wire        exmem_Branch,   exmem_MemRead, exmem_MemWrite;
wire [31:0] exmem_branch_target, exmem_alu_result, exmem_read_data2;
wire        exmem_zero;
wire [4:0]  exmem_write_reg;

// ── MEM Stage wires ───────────────────────────────────────
wire [31:0] mem_read_data;

// ── MEM/WB wires ──────────────────────────────────────────
wire        memwb_RegWrite, memwb_MemtoReg;
wire [31:0] memwb_read_data, memwb_alu_result;
wire [4:0]  memwb_write_reg;

// ── WB Stage wire ─────────────────────────────────────────
wire [31:0] wb_write_data;

// ══════════════════════════════════════════════════════════
// HAZARD CONTROL SIGNALS
// ══════════════════════════════════════════════════════════

assign pcsrc      = exmem_Branch & exmem_zero;
assign flush_ifid = pcsrc;
assign flush_idex = pcsrc | stall;

// Mux control signals to zero on stall (insert NOP)
assign s_RegDst   = stall ? 1'b0 : ctrl_RegDst;
assign s_ALUSrc   = stall ? 1'b0 : ctrl_ALUSrc;
assign s_MemtoReg = stall ? 1'b0 : ctrl_MemtoReg;
assign s_RegWrite = stall ? 1'b0 : ctrl_RegWrite;
assign s_MemRead  = stall ? 1'b0 : ctrl_MemRead;
assign s_MemWrite = stall ? 1'b0 : ctrl_MemWrite;
assign s_Branch   = stall ? 1'b0 : ctrl_Branch;
assign s_ALUOp    = stall ? 2'b00: ctrl_ALUOp;

// ══════════════════════════════════════════════════════════
// IF STAGE
// ══════════════════════════════════════════════════════════

Adder pc_adder (
    .a      (pc_out),
    .b      (32'd4),
    .result (pc4)
);

MUX2 mux_pc (
    .a   (pc4),
    .b   (exmem_branch_target),
    .sel (pcsrc),
    .out (next_pc)
);

PC pc (
    .clk      (clk),
    .reset    (reset),
    .write_en (PCWrite),
    .next_pc  (next_pc),
    .pc       (pc_out)
);

InstructionMemory imem (
    .addr        (pc_out),
    .instruction (instruction)
);

IF_ID if_id (
    .clk             (clk),
    .reset           (reset),
    .flush           (flush_ifid),
    .write_en        (IF_ID_Write),
    .in_PC4          (pc4),
    .in_instruction  (instruction),
    .out_PC4         (ifid_pc4),
    .out_instruction (ifid_instruction)
);

// ══════════════════════════════════════════════════════════
// ID STAGE
// ══════════════════════════════════════════════════════════

assign id_rs    = ifid_instruction[25:21];
assign id_rt    = ifid_instruction[20:16];
assign id_rd    = ifid_instruction[15:11];
assign id_funct = ifid_instruction[5:0];

HazardDetectionUnit hdu (
    .id_ex_MemRead (idex_MemRead),
    .id_ex_rt      (idex_rt),
    .if_id_rs      (id_rs),
    .if_id_rt      (id_rt),
    .PCWrite       (PCWrite),
    .IF_ID_Write   (IF_ID_Write),
    .stall         (stall)
);

Control ctrl (
    .opcode   (ifid_instruction[31:26]),
    .RegDst   (ctrl_RegDst),
    .ALUSrc   (ctrl_ALUSrc),
    .MemtoReg (ctrl_MemtoReg),
    .RegWrite (ctrl_RegWrite),
    .MemRead  (ctrl_MemRead),
    .MemWrite (ctrl_MemWrite),
    .Branch   (ctrl_Branch),
    .ALUOp    (ctrl_ALUOp)
);

RegisterFile regfile (
    .clk        (clk),
    .reset      (reset),
    .RegWrite   (memwb_RegWrite),
    .rs         (id_rs),
    .rt         (id_rt),
    .rd         (memwb_write_reg),
    .write_data (wb_write_data),
    .read_data1 (read_data1),
    .read_data2 (read_data2)
);

SignExtend sign_ext (
    .in  (ifid_instruction[15:0]),
    .out (sign_ext_out)
);

ID_EX id_ex (
    .clk            (clk),
    .reset          (reset),
    .flush          (flush_idex),
    .in_RegWrite    (s_RegWrite),
    .in_MemtoReg    (s_MemtoReg),
    .in_Branch      (s_Branch),
    .in_MemRead     (s_MemRead),
    .in_MemWrite    (s_MemWrite),
    .in_RegDst      (s_RegDst),
    .in_ALUSrc      (s_ALUSrc),
    .in_ALUOp       (s_ALUOp),
    .in_PC4         (ifid_pc4),
    .in_read_data1  (read_data1),
    .in_read_data2  (read_data2),
    .in_sign_ext    (sign_ext_out),
    .in_rs          (id_rs),
    .in_rt          (id_rt),
    .in_rd          (id_rd),
    .in_funct       (id_funct),
    .out_RegWrite   (idex_RegWrite),
    .out_MemtoReg   (idex_MemtoReg),
    .out_Branch     (idex_Branch),
    .out_MemRead    (idex_MemRead),
    .out_MemWrite   (idex_MemWrite),
    .out_RegDst     (idex_RegDst),
    .out_ALUSrc     (idex_ALUSrc),
    .out_ALUOp      (idex_ALUOp),
    .out_PC4        (idex_PC4),
    .out_read_data1 (idex_read_data1),
    .out_read_data2 (idex_read_data2),
    .out_sign_ext   (idex_sign_ext),
    .out_rs         (idex_rs),
    .out_rt         (idex_rt),
    .out_rd         (idex_rd),
    .out_funct      (idex_funct)
);

// ══════════════════════════════════════════════════════════
// EX STAGE
// ══════════════════════════════════════════════════════════

ForwardingUnit fwd (
    .id_ex_rs         (idex_rs),
    .id_ex_rt         (idex_rt),
    .ex_mem_write_reg (exmem_write_reg),
    .ex_mem_RegWrite  (exmem_RegWrite),
    .mem_wb_write_reg (memwb_write_reg),
    .mem_wb_RegWrite  (memwb_RegWrite),
    .forwardA         (forwardA),
    .forwardB         (forwardB)
);

// Forward MUX for ALU input A
MUX3 mux_fwd_a (
    .a   (idex_read_data1),
    .b   (wb_write_data),
    .c   (exmem_alu_result),
    .sel (forwardA),
    .out (fw_alu_a)
);

// Forward MUX for ALU input B
MUX3 mux_fwd_b (
    .a   (idex_read_data2),
    .b   (wb_write_data),
    .c   (exmem_alu_result),
    .sel (forwardB),
    .out (fw_alu_b)
);

// ALUSrc MUX
MUX2 mux_alusrc (
    .a   (fw_alu_b),
    .b   (idex_sign_ext),
    .sel (idex_ALUSrc),
    .out (alu_input_b)
);

// RegDst MUX
MUX2_5bit mux_regdst (
    .a   (idex_rt),
    .b   (idex_rd),
    .sel (idex_RegDst),
    .out (ex_write_reg)
);

ShiftLeft2 sl2 (
    .in  (idex_sign_ext),
    .out (sl2_out)
);

Adder branch_adder (
    .a      (idex_PC4),
    .b      (sl2_out),
    .result (ex_branch_target)
);

ALUControl alu_ctrl (
    .ALUOp       (idex_ALUOp),
    .funct       (idex_funct),
    .alu_control (alu_ctrl_out)
);

ALU alu (
    .a           (fw_alu_a),
    .b           (alu_input_b),
    .alu_control (alu_ctrl_out),
    .result      (ex_alu_result),
    .zero        (ex_zero)
);

EX_MEM ex_mem (
    .clk               (clk),
    .reset             (reset),
    .in_RegWrite       (idex_RegWrite),
    .in_MemtoReg       (idex_MemtoReg),
    .in_Branch         (idex_Branch),
    .in_MemRead        (idex_MemRead),
    .in_MemWrite       (idex_MemWrite),
    .in_branch_target  (ex_branch_target),
    .in_zero           (ex_zero),
    .in_alu_result     (ex_alu_result),
    .in_read_data2     (fw_alu_b),
    .in_write_reg      (ex_write_reg),
    .out_RegWrite      (exmem_RegWrite),
    .out_MemtoReg      (exmem_MemtoReg),
    .out_Branch        (exmem_Branch),
    .out_MemRead       (exmem_MemRead),
    .out_MemWrite      (exmem_MemWrite),
    .out_branch_target (exmem_branch_target),
    .out_zero          (exmem_zero),
    .out_alu_result    (exmem_alu_result),
    .out_read_data2    (exmem_read_data2),
    .out_write_reg     (exmem_write_reg)
);

// ══════════════════════════════════════════════════════════
// MEM STAGE
// ══════════════════════════════════════════════════════════

DataMemory dmem (
    .clk        (clk),
    .MemRead    (exmem_MemRead),
    .MemWrite   (exmem_MemWrite),
    .addr       (exmem_alu_result),
    .write_data (exmem_read_data2),
    .read_data  (mem_read_data)
);

MEM_WB mem_wb (
    .clk            (clk),
    .reset          (reset),
    .in_RegWrite    (exmem_RegWrite),
    .in_MemtoReg    (exmem_MemtoReg),
    .in_read_data   (mem_read_data),
    .in_alu_result  (exmem_alu_result),
    .in_write_reg   (exmem_write_reg),
    .out_RegWrite   (memwb_RegWrite),
    .out_MemtoReg   (memwb_MemtoReg),
    .out_read_data  (memwb_read_data),
    .out_alu_result (memwb_alu_result),
    .out_write_reg  (memwb_write_reg)
);

// ══════════════════════════════════════════════════════════
// WB STAGE
// ══════════════════════════════════════════════════════════

MUX2 mux_memtoreg (
    .a   (memwb_alu_result),
    .b   (memwb_read_data),
    .sel (memwb_MemtoReg),
    .out (wb_write_data)
);

endmodule
