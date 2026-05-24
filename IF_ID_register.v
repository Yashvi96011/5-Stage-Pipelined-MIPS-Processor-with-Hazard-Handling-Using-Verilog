module IF_ID (
    input         clk,
    input         reset,
    input         flush,
    input         write_en,
    input  [31:0] in_PC4,
    input  [31:0] in_instruction,

    output reg [31:0] out_PC4,
    output reg [31:0] out_instruction
);

always @(posedge clk or posedge reset) begin
    if (reset || flush) begin
        out_PC4         <= 32'b0;
        out_instruction <= 32'b0;
    end else if (write_en) begin
        out_PC4         <= in_PC4;
        out_instruction <= in_instruction;
    end
end

endmodule
