module MEM_WB (
    input         clk,
    input         reset,

    // WB
    input         in_RegWrite,
    input         in_MemtoReg,
    // Data
    input  [31:0] in_read_data,
    input  [31:0] in_alu_result,
    input  [4:0]  in_write_reg,

    // WB outputs
    output reg        out_RegWrite,
    output reg        out_MemtoReg,
    // Data outputs
    output reg [31:0] out_read_data,
    output reg [31:0] out_alu_result,
    output reg [4:0]  out_write_reg
);

always @(posedge clk or posedge reset) begin
    if (reset) begin
        out_RegWrite   <= 1'b0;
        out_MemtoReg   <= 1'b0;
        out_read_data  <= 32'b0;
        out_alu_result <= 32'b0;
        out_write_reg  <= 5'b0;
    end else begin
        out_RegWrite   <= in_RegWrite;
        out_MemtoReg   <= in_MemtoReg;
        out_read_data  <= in_read_data;
        out_alu_result <= in_alu_result;
        out_write_reg  <= in_write_reg;
    end
end

endmodule

