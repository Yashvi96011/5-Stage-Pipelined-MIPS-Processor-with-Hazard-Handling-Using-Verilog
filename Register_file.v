module RegisterFile (
    input         clk,
    input         reset,
    input         RegWrite,
    input  [4:0]  rs,
    input  [4:0]  rt,
    input  [4:0]  rd,
    input  [31:0] write_data,
    output [31:0] read_data1,
    output [31:0] read_data2
);

reg [31:0] reg_file [0:31];
integer i;

always @(posedge clk or posedge reset) begin
    if (reset) begin
        for (i = 0; i < 32; i = i + 1)
            reg_file[i] <= 32'b0;
    end else begin
        if (RegWrite && rd != 0)
            reg_file[rd] <= write_data;
    end
end

assign read_data1 = reg_file[rs];
assign read_data2 = reg_file[rt];

endmodule
