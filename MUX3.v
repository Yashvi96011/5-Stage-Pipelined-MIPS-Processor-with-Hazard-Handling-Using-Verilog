module MUX3 (
    input  [31:0] a,
    input  [31:0] b,
    input  [31:0] c,
    input  [1:0]  sel,
    output reg [31:0] out
);
// sel: 2'b00=a(ID/EX), 2'b01=b(MEM/WB), 2'b10=c(EX/MEM)

always @(*) begin
    case (sel)
        2'b00: out = a;
        2'b01: out = b;
        2'b10: out = c;
        default: out = a;
    endcase
end

endmodule
