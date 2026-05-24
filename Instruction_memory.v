module InstructionMemory (
    input  [31:0] addr,
    output [31:0] instruction
);

reg [31:0] memory [0:31];
integer i;

initial begin
    memory[0] = 32'b00000010000100011001000000100000; // add
    memory[1] = 32'b00000010000100011001000000100010; // sub
    memory[2] = 32'b00000010000100011001000000100100; // and
    memory[3] = 32'b00000010000100011001000000100101; // or
    memory[4] = 32'b00000010000100011001000000100111; // nor
    memory[5] = 32'b00000010000100011001000000101010; // slt
    memory[6] = 32'b00100010000100010000000000000101; // addi
    memory[7] = 32'b10001110000100010000000000000100; // lw
    memory[8] = 32'b10101110000100010000000000001000; // sw
    memory[9] = 32'b00010010000100010000000000000010; // beq

    for (i = 10; i < 32; i = i + 1)
        memory[i] = 32'b0;
end

assign instruction = memory[addr[6:2]];

endmodule
