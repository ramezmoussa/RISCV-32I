`timescale 1ns / 1ps
/*******************************************************************
*
* Module: myFU.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the forwarding unit
*
**********************************************************************/


module forwardingUnit(
    input [4:0] IDEX_rs1,
    input [4:0] IDEX_rs2,
    input [4:0] MEMWB_rd,
    input MEMWB_regWrite,
    output reg forwardA,
    output reg forwardB
    );
    
    //we only need to forward from mem stage as by the time we reach ALU stage the prev inst
    //would have already reached the writing stage
    always@(*)
    begin
        forwardA = 1'b0;
        forwardB = 1'b0;
        if((MEMWB_regWrite && (MEMWB_rd != 0)) && (MEMWB_rd == IDEX_rs1))
        begin
            forwardA = 1'b1;
        end
        
        if((MEMWB_regWrite && (MEMWB_rd != 0)) && (MEMWB_rd == IDEX_rs2))
        begin
            forwardB = 1'b1;
        end
    end
    
endmodule
