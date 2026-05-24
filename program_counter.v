module PC (
    input         clk,
    input         reset,
    input         write_en,
    input  [31:0] next_pc,
    output reg [31:0] pc
);

always @(posedge clk or posedge reset) begin
    if (reset)
        pc <= 32'b0;
    else if (write_en)
        pc <= next_pc;
end

endmodule
