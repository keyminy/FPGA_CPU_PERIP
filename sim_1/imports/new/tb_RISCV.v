`timescale 1ns / 1ps

module tb_RISCV(

    );
    reg clk;
    reg reset;

    RISCV_MCU dut(
        .clk    (clk),
        .reset  (reset)
    );

    always #05 clk = ~clk;
    initial begin
        #00 reset = 1; clk = 0;
        #10 reset = 0;
        #110 $finish;
    end
endmodule
