module EX_MEM (
    input         clk,
    input         reset,

    // WB
    input         in_RegWrite,
    input         in_MemtoReg,
    // M
    input         in_Branch,
    input         in_MemRead,
    input         in_MemWrite,
    // Data
    input  [31:0] in_branch_target,
    input         in_zero,
    input  [31:0] in_alu_result,
    input  [31:0] in_read_data2,
    input  [4:0]  in_write_reg,

    // WB outputs
    output reg        out_RegWrite,
    output reg        out_MemtoReg,
    // M outputs
    output reg        out_Branch,
    output reg        out_MemRead,
    output reg        out_MemWrite,
    // Data outputs
    output reg [31:0] out_branch_target,
    output reg        out_zero,
    output reg [31:0] out_alu_result,
    output reg [31:0] out_read_data2,
    output reg [4:0]  out_write_reg
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out_RegWrite      <= 1'b0;
        out_MemtoReg      <= 1'b0;
        out_Branch        <= 1'b0;
        out_MemRead       <= 1'b0;
        out_MemWrite      <= 1'b0;
        out_branch_target <= 32'b0;
        out_zero          <= 1'b0;
        out_alu_result    <= 32'b0;
        out_read_data2    <= 32'b0;
        out_write_reg     <= 5'b0;
    end else begin
        out_RegWrite      <= in_RegWrite;
        out_MemtoReg      <= in_MemtoReg;
        out_Branch        <= in_Branch;
        out_MemRead       <= in_MemRead;
        out_MemWrite      <= in_MemWrite;
        out_branch_target <= in_branch_target;
        out_zero          <= in_zero;
        out_alu_result    <= in_alu_result;
        out_read_data2    <= in_read_data2;
        out_write_reg     <= in_write_reg;
    end
end

endmodule
