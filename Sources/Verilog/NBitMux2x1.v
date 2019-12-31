`timescale 1ns / 1ps
/*******************************************************************
*
* Module: NBitMux2x1.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for a series of 2x1 multiplexers
*
**********************************************************************/


module NBitMux2x1(
input [N-1:0] A,
input [N-1:0] B,
input select,
output [N-1:0] O);

parameter N = 8;
wire [N-1:0] muxOut;
genvar i;
generate
    for(i = N-1; i >= 0; i = i - 1)
    begin
        Mux2x1 myMux(A[i], B[i], select, O[i]);
    end
    endgenerate
endmodule
