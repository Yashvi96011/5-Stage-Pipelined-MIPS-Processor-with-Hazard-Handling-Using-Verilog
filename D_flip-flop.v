module dff_async_clear (
    output reg q,
    input d,
    input clk,
    input reset
);

always @(posedge clk or posedge reset) begin
    if (reset)
        q <= 1'b0;
    else
        q <= d;
end

endmodule
