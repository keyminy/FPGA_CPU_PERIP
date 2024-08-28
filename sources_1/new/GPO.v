`timescale 1ns / 1ps

module GPO(
    input           clk,
    input           reset,
    input           wr,
    input           cs,
    input           addr, // 없어도됨
    input   [31:0]  wdata, 
    output  [31:0]  rdata, 
    output  [7:0]   gpo // led 
    );

    reg [7:0] regGpo;
    
    assign gpo = regGpo; // register값이 port로 나가게 함

    always @(posedge clk ,posedge reset) begin
        if(reset) begin
            regGpo <= 0;
        end else begin
            if(cs & wr) regGpo <= wdata[7:0]; // write 하위 8비트
        end
    end

    assign rdata = {24'b0,regGpo};

endmodule
