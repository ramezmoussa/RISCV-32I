`timescale 1ns / 1ps
/*******************************************************************
*
* Module: RegFile.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the register file containing the 32 registers
*
**********************************************************************/


module RegFile(
input clk,
input rst,
input [4:0] readReg1,
input [4:0] readReg2,
input [4:0] writeReg,
input regWrite,
input [N-1:0] data,
output [N-1:0] readData1,
output [N-1:0] readData2
    );
    
    
parameter N = 32;
wire [N-1:0] Registers [31:0];
reg [N-1:0] load;

genvar i;

generate
    for(i = 0; i < N; i = i + 1) begin:generate_Registe
       NBitReg #(32) myInstance(clk, rst, load[i], data, Registers[i]);
    end
endgenerate

       assign  readData1 = Registers[readReg1];
       assign readData2 = Registers[readReg2];

integer j;
always@(*)
begin
    load[0] = 0;
    for(j = 1; j < N; j = j + 1)
    begin
        if(j == writeReg)  load[j] = regWrite; else load[j] = 0;
    end
end

endmodule
