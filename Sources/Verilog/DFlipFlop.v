`timescale 1ns / 1ps
/*******************************************************************
*
* Module: DFlipFlop.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for a DFlipFlop
*
**********************************************************************/


module DFlipFlop
 (input clk, input rst, input D, output reg Q);
 always @ (posedge clk or posedge rst)
 if (rst) begin
 Q <= 1'b0;
 end else begin
 Q <= D;
 end
endmodule
