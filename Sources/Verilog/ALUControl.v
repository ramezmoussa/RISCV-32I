`timescale 1ns / 1ps
/*******************************************************************
*
* Module: ALUControl.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the control unit for the ALU
*
**********************************************************************/


module ALUControl(
input [1:0] ALUOp,
input [14:12] Inst14To12,
input Inst30,
output reg [3:0] ALUSelection
    );
    
    
always@(*)
begin
    if(ALUOp == 2'b00) ALUSelection = 4'b0000; //JAL/JALR - ADD
    else
    if(ALUOp == 2'b01) ALUSelection = 4'b0001; //BRANCH - SUB
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'bb000) && (Inst30 == 0)) ALUSelection = 4'b0000; //R ADD
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b000) && (Inst30 == 1)) ALUSelection = 4'b0001; //R SUB
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b001) && (Inst30 == 0)) ALUSelection = 4'b1000; //R SLL
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b010) && (Inst30 == 0)) ALUSelection = 4'b1101; //R SLT
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b011) && (Inst30 == 0)) ALUSelection = 4'b1111; //R SLTU 
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b100) && (Inst30 == 0)) ALUSelection = 4'b0111; //R XOR
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b101) && (Inst30 == 0)) ALUSelection = 4'b1001; //R SRL 
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b101) && (Inst30 == 1)) ALUSelection = 4'b1010; //R SRA 
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b110) && (Inst30 == 0)) ALUSelection = 4'b0100; //R OR 
    else
    if((ALUOp == 2'b10) && (Inst14To12 == 3'b111) && (Inst30 == 0)) ALUSelection = 4'b0101; //R AND 
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b000)) ALUSelection = 4'b0000; //I ADDI 
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b010)) ALUSelection = 4'b1101; //I SLTI 
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b011)) ALUSelection = 4'b1111; //I SLTIU
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b100)) ALUSelection = 4'b0111; //I XORI
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b110)) ALUSelection = 4'b0100; //I ORI
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b111)) ALUSelection = 4'b0101; //I ANDI
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b001)&& (Inst30 == 0)) ALUSelection = 4'b0010; //I SLLI
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b101)&& (Inst30 == 0)) ALUSelection = 4'b0110; //I SRLI
    else
    if((ALUOp == 2'b11) && (Inst14To12 == 3'b101)&& (Inst30 == 1)) ALUSelection = 4'b1011; //I SRAI
    else 
        ALUSelection = 4'b0000; //to prevent having a latch
end
endmodule
