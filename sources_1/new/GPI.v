`timescale 1ns / 1ps

module GPI(
    input           clk,
    input           reset,
    input           cs,
    input           wr,
    input           addr,
    input   [7:0]   gpi ,
    input   [31:0]  wdata, 
    output  [31:0]  rdata 
    );
    reg [31:0] regGpi,temp; 
    // do not think about latch
    // 외부에서 들어온 것을 바로 넣고 싶으면?

    // latch만들기
    always @(*) begin
        if(clk) temp = {24'b0,gpi}; // latch circuit
        else temp = temp;
    end

    // latch회로를 통해서 들어오는 FF
    always @(posedge clk, posedge reset) begin
        if(reset) regGpi <= 0; 
        else regGpi <= temp;// synchronizer
    end

    //FF을 거친 것이 rdata로 빠진다.
    assign rdata = regGpi;

endmodule
