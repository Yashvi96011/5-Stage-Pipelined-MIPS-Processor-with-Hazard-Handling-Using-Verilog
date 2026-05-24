module ID_EX (
    input         clk,
    input         reset,
    input         flush,

    // WB
    input         in_RegWrite,
    input         in_MemtoReg,
    // M
    input         in_Branch,
    input         in_MemRead,
    input         in_MemWrite,
    // EX
    input         in_RegDst,
    input         in_ALUSrc,
    input  [1:0]  in_ALUOp,
    // Data
    input  [31:0] in_PC4,
    input  [31:0] in_read_data1,
    input  [31:0] in_read_data2,
    input  [31:0] in_sign_ext,
    input  [4:0]  in_rs,
    input  [4:0]  in_rt,
    input  [4:0]  in_rd,
    input  [5:0]  in_funct,

    // WB outputs
    output reg        out_RegWrite,
    output reg        out_MemtoReg,
    // M outputs
    output reg        out_Branch,
    output reg        out_MemRead,
    output reg        out_MemWrite,
    // EX outputs
    output reg        out_RegDst,
    output reg        out_ALUSrc,
    output reg [1:0]  out_ALUOp,
    // Data outputs
    output reg [31:0] out_PC4,
    output reg [31:0] out_read_data1,
    output reg [31:0] out_read_data2,
    output reg [31:0] out_sign_ext,
    output reg [4:0]  out_rs,
    output reg [4:0]  out_rt,
    output reg [4:0]  out_rd,
    output reg [5:0]  out_funct
);

always @(posedge clk or posedge reset) begin
    if (reset || flush) begin
        out_RegWrite   <= 1'b0;
        out_MemtoReg   <= 1'b0;
        out_Branch     <= 1'b0;
        out_MemRead    <= 1'b0;
        out_MemWrite   <= 1'b0;
        out_RegDst     <= 1'b0;
        out_ALUSrc     <= 1'b0;
        out_ALUOp      <= 2'b00;
        out_PC4        <= 32'b0;
        out_read_data1 <= 32'b0;
        out_read_data2 <= 32'b0;
        out_sign_ext   <= 32'b0;
        out_rs         <= 5'b0;
        out_rt         <= 5'b0;
        out_rd         <= 5'b0;
        out_funct      <= 6'b0;
    end else begin
        out_RegWrite   <= in_RegWrite;
        out_MemtoReg   <= in_MemtoReg;
        out_Branch     <= in_Branch;
        out_MemRead    <= in_MemRead;
        out_MemWrite   <= in_MemWrite;
        out_RegDst     <= in_RegDst;
        out_ALUSrc     <= in_ALUSrc;
        out_ALUOp      <= in_ALUOp;
        out_PC4        <= in_PC4;
        out_read_data1 <= in_read_data1;
        out_read_data2 <= in_read_data2;
        out_sign_ext   <= in_sign_ext;
        out_rs         <= in_rs;
        out_rt         <= in_rt;
        out_rd         <= in_rd;
        out_funct      <= in_funct;
    end
end

endmodule

