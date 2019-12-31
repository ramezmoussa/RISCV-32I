`timescale 1ns / 1ps
/*******************************************************************
*
* Module: RISCV.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the RISCV processor that implements the Datapath
*in addition to some LEDS for displaying purposes
*
**********************************************************************/


module RISCV(
input DatapathClk,
input rst,
input [1:0] ledSel,
input [3:0] ssdSel,
output reg [15:0] LEDS,
output reg [12:0] SSDInput);

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

Datapath myDatapath(
DatapathClk, 
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

always@(*)
begin
    case(ssdSel)
        4'b0000: SSDInput = PC;
        4'b0001: SSDInput = PCPlus4;
        4'b0010: SSDInput = PCPlusShiftedImm;
        4'b0011: SSDInput = newPC;
        4'b0100: SSDInput = readData1;
        4'b0101: SSDInput = readData2;
        4'b0110: SSDInput = dataFromMemMux;
        4'b0111: SSDInput = gen_out;
        4'b1001: SSDInput = ALUInput2;
        4'b1010: SSDInput = ALUOut;
        4'b1011: SSDInput = MemDataOut;
        default: SSDInput = SSDInput;
    endcase
end

always@(*)
begin
    case(ledSel)
        2'b00: LEDS = instruction[15:0];
        2'b01: LEDS = instruction [31:16];
        2'b10: LEDS = {Branch,MemRead,MemtoReg,MemWrite,ALUSrc,
                       RegWrite,ALUop, ALUSelection, zeroFlag, BranchAndZero};
        default: LEDS = LEDS;
    endcase
end
endmodule
