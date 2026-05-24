module reg32 (
    output [31:0] q,
    input  [31:0] d,
    input         clk,
    input         reset
);

genvar i;
generate
    for(i = 0; i < 32; i = i + 1) begin: reg_loop
        dff_async_clear dff(q[i], d[i], clk, reset);
    end
endgenerate

endmodule
