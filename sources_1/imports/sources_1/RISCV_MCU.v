`timescale 1ns / 1ps

module RISCV_MCU(
        input        clk,
        input        reset,
        input  [7:0] GPIB,
        output [7:0] GPOA,
        input [7:0]  GPIOC
    );
    wire [31:0] instrData, instrAddr;
    wire [31:0] DRdData, DWrData, DAddr;
    wire        DWe;
    wire [1:0]  BHW;
    wire [3:0]  w_addrSel;
    wire [31:0] w_ramRdData, w_gpoRdData, w_gpiRdData,w_gpioRdData;

    RV32I_Core U_MCU(
        .clk        (clk),
        .reset      (reset),
        .instrData  (instrData),
        .instrAddr  (instrAddr),
        .DRdData  (DRdData),
        .DWrData  (DWrData),
        .DWe      (DWe),
        .DAddr    (DAddr),
        .BHW      (BHW)
    );

    addrDecoder U_AddrDec(
        .DAddr(DAddr),
        .sel(w_addrSel)
    );

    addrMux U_AddrMux(
        .DAddr(DAddr),
        .a(w_ramRdData),
        .b(w_gpoRdData),
        .c(w_gpiRdData),
        .y(DRdData)
    );

    RAM U_RAM(
        .clk        (clk),
        .cs(w_addrSel[0]),
        .we         (DWe),
        .addr       (DAddr[7:0]),
        .wdata      (DWrData),
        .rdata      (w_ramRdData),
        .BHW        (BHW)
    );

    GPO U_GPO(
     .clk(clk),
     .reset(reset),
     .cs(w_addrSel[1]),
     .wr(DWe),
     .addr(DAddr), // 없어도됨
     .wdata(DWrData), 
     .rdata(w_gpoRdData), 
     .gpo(GPOA) // led 
    );

    GPI U_GPI(
    .clk(clk),
    .reset(reset),
    .cs(w_addrSel[2]),
    .wr(DWe),
    .addr(DAddr),
    .gpi(GPIB) ,
    .wdata(DWrData), 
    .rdata(w_gpiRdData) 
    );

    GPIO U_GPIO(
    .clk(clk),
    .reset(reset),
    .wr(DWe),
    .cs(w_addrSel[3]),
    .addr(DAddr), // 없어도됨
    .wdata(DWrData), 
    .ioport(GPIOC), 
    .rdata(w_gpioRdData)
    );

    ROM U_ROM(
        .addr       (instrAddr),
        .data       (instrData)
    );
endmodule

module addrDecoder (
    input [31:0]     DAddr,
    output reg [3:0] sel
);
    always @(*) begin
        casex (DAddr)
            // 32'h2000_00xx: sel = 2'b01; // RAM
            32'h2000_02xx: sel = 4'b0001; // RAM
            32'h4000_00xx: sel = 4'b0010; // GPO
            32'h4000_01xx: sel = 4'b0100; // GPI
            32'h4000_02xx: sel = 4'b1000; // GPIO
            default:  sel = 4'bxx;
        endcase
    end    
endmodule

module addrMux (
    input [31:0]        DAddr,
    input [31:0]        a,
    input [31:0]        b,
    input [31:0]        c,
    input [31:0]        d,
    output reg [31:0]   y
);
    always @(*) begin
        casex (DAddr)
            // 32'h2000_00xx: y = a; // RAM
            32'h2000_02xx: y = a; // RAM
            32'h4000_00xx: y = b; // GPO
            32'h4000_01xx: y = c; // GPI
            32'h4000_02xx: y = d; // GPIO
            default:  y = 32'bx;
        endcase
    end    
endmodule
