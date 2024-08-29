`timescale 1ns / 1ps

module GPIO(
    input           clk,
    input           reset,
    input           wr,
    input           cs,
    input   [31:0]  addr, // 없어도됨
    input   [31:0]  wdata, 
    inout  [7:0]    ioport, 
    output  [31:0]  rdata
    );
    reg [31:0] regGpio[0:2]; // 3개
    wire [31:0] MODER = regGpio[0];
    wire [31:0] IDR   = regGpio[1];
    wire [31:0] ODR   = regGpio[2];

    always @(posedge clk or posedge reset) begin
        if(reset) begin
            regGpio[0] <= 0; // MODER
            // IDR can't write
            regGpio[2] <= 0; // ODR
        end else begin
            if(cs & wr) begin
                // prevent latch(default)
                regGpio[0] <= 0;
                regGpio[2] <= 0;
                case (addr[3:2])
                    2'b00: regGpio[0] = wdata; //MODER
                    2'b10: regGpio[2] = wdata; // ODR
                endcase
            end
        end
    end
    assign rdata = regGpio[addr[3:2]];
    
    // Added after thinking
    assign IDR[0] = MODER[0] ? 1'bz : ioport[0];

    assign ioport[0] = MODER[0] ? ODR[0] : ioport[0];
    assign ioport[1] = MODER[1] ? ODR[1] : ioport[1];
    assign ioport[2] = MODER[2] ? ODR[2] : ioport[2];
    assign ioport[3] = MODER[3] ? ODR[3] : ioport[3];
    assign ioport[4] = MODER[4] ? ODR[4] : ioport[4];
    assign ioport[5] = MODER[3] ? ODR[5] : ioport[5];
    assign ioport[6] = MODER[6] ? ODR[6] : ioport[6];
    assign ioport[7] = MODER[7] ? ODR[7] : ioport[7];


endmodule
