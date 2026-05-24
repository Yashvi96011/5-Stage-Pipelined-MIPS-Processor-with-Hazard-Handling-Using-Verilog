module ForwardingUnit (
    input  [4:0] id_ex_rs,
    input  [4:0] id_ex_rt,
    input  [4:0] ex_mem_write_reg,
    input        ex_mem_RegWrite,
    input  [4:0] mem_wb_write_reg,
    input        mem_wb_RegWrite,

    output reg [1:0] forwardA,
    output reg [1:0] forwardB
);

always @(*) begin
    // ForwardA
    if (ex_mem_RegWrite
        && ex_mem_write_reg != 5'b0
        && ex_mem_write_reg == id_ex_rs)
        forwardA = 2'b10;
    else if (mem_wb_RegWrite
        && mem_wb_write_reg != 5'b0
        && mem_wb_write_reg == id_ex_rs)
        forwardA = 2'b01;
    else
        forwardA = 2'b00;

    // ForwardB
    if (ex_mem_RegWrite
        && ex_mem_write_reg != 5'b0
        && ex_mem_write_reg == id_ex_rt)
        forwardB = 2'b10;
    else if (mem_wb_RegWrite
        && mem_wb_write_reg != 5'b0
        && mem_wb_write_reg == id_ex_rt)
        forwardB = 2'b01;
    else
        forwardB = 2'b00;
end

endmodule
