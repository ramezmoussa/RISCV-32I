`timescale 1ns / 1ps
/*******************************************************************
*
* Module: NBitReg.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: The module for a register
*
**********************************************************************/


module NBitReg(
input clk,
input rst,
input load,
input [N-1:0] A,
output [N-1:0] O);

parameter N = 8;
wire [N-1:0] muxOut;

genvar i;
generate
    for(i = N-1; i >= 0; i = i - 1)
    begin
        Mux2x1 myMux(O[i], A[i], load, muxOut[i]);
        DFlipFlop myFF(clk, rst, muxOut[i], O[i]);
    end
    endgenerate
endmodule
