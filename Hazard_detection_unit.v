module HazardDetectionUnit (
    input        id_ex_MemRead,
    input  [4:0] id_ex_rt,
    input  [4:0] if_id_rs,
    input  [4:0] if_id_rt,

    output reg   PCWrite,
    output reg   IF_ID_Write,
    output reg   stall
);

always @(*) begin
    if (id_ex_MemRead &&
       (id_ex_rt == if_id_rs || id_ex_rt == if_id_rt))
    begin
        PCWrite     = 1'b0;
        IF_ID_Write = 1'b0;
        stall       = 1'b1;
    end else begin
        PCWrite     = 1'b1;
        IF_ID_Write = 1'b1;
        stall       = 1'b0;
    end
end

endmodule
