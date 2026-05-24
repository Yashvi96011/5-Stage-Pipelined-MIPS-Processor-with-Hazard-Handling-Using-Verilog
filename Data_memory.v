module DataMemory (
    input         clk,
    input         MemRead,
    input         MemWrite,
    input  [31:0] addr,
    input  [31:0] write_data,
    output reg [31:0] read_data
);

reg [31:0] memory [0:31];
integer i;

initial begin
    for (i = 0; i < 32; i = i + 1)
        memory[i] = 32'b0;
end

always @(posedge clk) begin
    if (MemWrite)
        memory[addr[6:2]] <= write_data;
end

always @(*) begin
    if (MemRead)
        read_data = memory[addr[6:2]];
    else
        read_data = 32'b0;
end

endmodule
