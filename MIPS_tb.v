module tb_MIPS_Pipeline;

reg clk, reset;

MIPS_Pipeline uut (
    .clk   (clk),
    .reset (reset)
);

initial clk = 0;
always #5 clk = ~clk;

initial begin
    $dumpfile("mips_pipeline.vcd");
    $dumpvars(0, tb_MIPS_Pipeline);
    reset = 1; #15;
    reset = 0;
    #500;
    $finish;
end

initial begin
    $monitor(
        "T=%0t | PC=%h | IR=%h | WB_data=%h | WB_reg=%0d | stall=%b | flush=%b | fwdA=%b | fwdB=%b",
        $time,
        uut.pc_out,
        uut.ifid_instruction,
        uut.wb_write_data,
        uut.memwb_write_reg,
        uut.stall,
        uut.flush_ifid,
        uut.forwardA,
        uut.forwardB
    );
end

endmodule
