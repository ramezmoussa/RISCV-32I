`timescale 1ns / 1ps
/*******************************************************************
*
* Module: NBitAdderSub.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for an N-bit adder and subtracter based on a control signal
*
**********************************************************************/


module NBitAdderSub(
input [N-1:0] A,
input [N-1:0] B,
input Cin,
output [N-1:0] S,
output Cout
    );
  
parameter N = 32;

wire [N-1:0] secondInput = (Cin == 1)? ~B : B;
    genvar i;
    wire [N:0] c;
    assign c[0] = Cin;
    generate
    for(i = 0; i < N; i = i + 1) begin:generate_FAs
       FA myInstance(A[i], secondInput[i], c[i], S[i], c[i+1]);
    end
    endgenerate
    
    assign Cout = c[N];
endmodule
