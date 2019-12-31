`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 10/17/2019 06:04:53 PM
// Design Name: 
// Module Name: pipelinedDataPath_tb
// Project Name: 
// Target Devices: 
// Tool Versions: 
// Description: 
// 
// Dependencies: 
// 
// Revision:
// Revision 0.01 - File Created
// Additional Comments:
// 
//////////////////////////////////////////////////////////////////////////////////


module Datapath_tb;

reg clk;
reg rst;
wire [31:0] PC;
wire [31:0] PCPlus4;
wire [31:0] PCPlusShiftedImm;
wire [31:0] newPC;
wire [31:0] readData1;
wire [31:0] readData2;
wire [31:0] dataFromMemMux;
wire [31:0] gen_out;
wire [31:0] ALUInput2;
wire [31:0] ALUOut;
wire [31:0] MemDataOut;
wire [1:0] ALUop;
wire [3:0] ALUSelection;
wire zeroFlag;
wire BranchAndZero;
wire [31:0] instruction;
wire Branch;
wire MemRead;
wire MemtoReg;
wire MemWrite;
wire ALUSrc;
wire RegWrite;
wire sclk;

Datapath uud(
clk, 
rst,
PC,
PCPlus4,
PCPlusShiftedImm,
newPC,
readData1,
readData2,
dataFromMemMux,
gen_out,
ALUInput2,
ALUOut,
MemDataOut,
ALUop,
ALUSelection,
zeroFlag,
BranchAndZero,
instruction,
Branch,
MemRead,
MemtoReg,
MemWrite,
ALUSrc,
RegWrite,
sclk
);

initial begin
clk = 1;
rst = 1;
#5
rst = 0;

end

always
    begin: CLOCK_GENERATOR
        #25 clk = ~ clk; //period is 100 ns
    end
endmodule
