`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Mux2x1.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for a 2x1 multiplexer
*
**********************************************************************/


module Mux2x1(input A, input B, input S, output O);
assign O = (S&B) | (!S&A);
endmodule
