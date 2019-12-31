`timescale 1ns / 1ps
/*******************************************************************
*
* Module: DataMem.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the binary-coded-decimal to display numbers on FPGA
*
**********************************************************************/

module BCD (
input [12:0] binary,
output reg [3:0] Thousands,
output reg [3:0] Hundreds,
output reg [3:0] Tens,
output reg [3:0] Ones
);
integer i;
always @(binary)
begin
//initialization
Thousands = 4'd0;
Hundreds = 4'd0;
Tens = 4'd0;
Ones = 4'd0;
for (i = 12; i >= 0 ; i = i-1 )
begin
if(Thousands >= 5 )
Thousands = Thousands + 3 ;
if(Hundreds >= 5 )
Hundreds = Hundreds + 3 ;
if (Tens >= 5 )
Tens = Tens + 3;
if (Ones >= 5)
Ones = Ones +3;
//shift left one
Thousands = Thousands << 1;
Thousands [0] = Hundreds [3];
Hundreds = Hundreds << 1;
Hundreds [0] = Tens [3];
Tens = Tens << 1;
Tens [0] = Ones[3];
Ones = Ones << 1;
Ones[0] = binary[i];
end
end
endmodule
