`timescale 1ns / 1ps
/*******************************************************************
*
* Module: FA.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for a Full Adder
*
**********************************************************************/


module FA(
input A,
input B,
input Cin,
output S,
output Cout
);
    
    assign S = A^B^Cin;
    assign Cout = (A&B)|(A&Cin)|(B&Cin);
endmodule
