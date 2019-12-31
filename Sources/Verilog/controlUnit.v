`timescale 1ns / 1ps
/*******************************************************************
*
* Module: controlUnit.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the control unit for the datapath
*
**********************************************************************/


module controlUnit(
input [6:0] Inst6to0,
input inst20, //used for EBREAK
output reg Branch,
output reg MemRead,
output reg MemtoReg,
output reg [1:0] ALUop,
output reg MemWrite,
output reg ALUSrc,
output reg RegWrite,
output reg JALRBranch,
output reg JALBranch,
output reg [1:0] RFData_control,
output reg PCLoad);
    
    
    always@(*)
    begin
        case(Inst6to0)
        7'b0110011: //R format
        begin
            PCLoad = 1;
            Branch = 0;
            JALRBranch = 0; 
            JALBranch = 0;
            MemRead = 0; 
            MemtoReg = 0; 
            ALUop = 2'b10;
            MemWrite = 0; 
            ALUSrc = 0; 
            RegWrite = 1;
            RFData_control = 2'b00;
        end
        7'b0000011: //Load
         begin
            PCLoad = 1;
            Branch = 0;
            JALRBranch = 0; 
            JALBranch = 0;
            MemRead = 1; 
            MemtoReg = 1; 
            ALUop = 2'b00;
            MemWrite = 0; 
            ALUSrc = 1; 
            RegWrite = 1;
            RFData_control = 2'b00;
        end
        7'b0100011: //Store
        begin
            PCLoad = 1;
            Branch = 0;
            JALRBranch = 0; 
            JALBranch = 0;
            MemRead = 0; 
            MemtoReg = 1'b?; 
            ALUop = 2'b00;
            MemWrite = 1; 
            ALUSrc = 1; 
            RegWrite = 0;
            RFData_control = 2'b00; //dont care
        end
        7'b1100011: //Branch
        begin
            PCLoad = 1;
            Branch = 1;
            JALRBranch = 0; 
            JALBranch = 0;
            MemRead = 0; 
            MemtoReg = 1'b?; 
            ALUop = 2'b01;
            MemWrite =0; 
            ALUSrc = 0; 
            RegWrite = 0;
            RFData_control = 2'b00; //dont care
        end
        
        7'b0010011: //immediate
        begin
            PCLoad = 1;
            Branch = 0; 
            JALRBranch = 0;
            JALBranch = 0;
            MemRead = 0; 
            MemtoReg = 1'b0; 
            ALUop = 2'b11;
            MemWrite =0; 
            ALUSrc = 1; 
            RegWrite = 1;
            RFData_control = 2'b00; 
        end
        
        7'b1100111: //JALR
        begin
            PCLoad = 1;
            Branch = 0; 
            JALRBranch = 1;
            JALBranch = 0;
            MemRead = 0; 
            MemtoReg = 1'b0; 
            ALUop = 2'b00;
            MemWrite =0; 
            ALUSrc = 1; 
            RegWrite = 1;
            RFData_control = 2'b10;
        end
        
        7'b1101111: //JAL
        begin
            PCLoad = 1;
            Branch = 0; //dont care
            JALRBranch = 0;
            JALBranch = 1;
            MemRead = 0; 
            MemtoReg = 1'b0; //dont care
            ALUop = 2'b00; //dont care
            MemWrite =0; 
            ALUSrc = 1; //dont care
            RegWrite = 1;
            RFData_control = 2'b10;
        end
        
        7'b0010111: //AUIPC
        begin
            PCLoad = 1;
            Branch = 0;
            JALRBranch = 0;
            JALBranch = 0;
            MemRead = 0; 
            MemtoReg = 1'b0; //dont care
            ALUop = 2'b00; //dont care
            MemWrite =0; 
            ALUSrc = 0; //dont care
            RegWrite = 1;
            RFData_control = 2'b11;
        end
        
        7'b0110111: //LUI
        begin
            PCLoad = 1;
            Branch = 0;
            JALRBranch = 0;
            JALBranch = 0;
            MemRead = 0; 
            MemtoReg = 1'b0; //dont care
            ALUop = 2'b00; //dont care
            MemWrite =0; 
            ALUSrc = 0; //dont care
            RegWrite = 1;
            RFData_control = 2'b01;
        end
        7'b1110011: //EBREAK
        begin
            if(inst20 == 1)
            begin
                PCLoad = 0;
                Branch = 0;
                JALRBranch = 0;
                JALBranch = 0;
                MemRead = 0; 
                MemtoReg = 1'b0; //dont care
                ALUop = 2'b00; //dont care
                MemWrite =0; 
                ALUSrc = 0; //dont care
                RegWrite = 0; // dont care
                RFData_control = 2'b00; //dont care
            end
            else begin
                PCLoad = 1;
                Branch = 0;
                JALRBranch = 0;
                JALBranch = 0;
                MemRead = 0; 
                MemtoReg = 1'b0; //dont care
                ALUop = 2'b00; //dont care
                MemWrite =0; 
                ALUSrc = 0; //dont care
                RegWrite = 0; // dont care
                RFData_control = 2'b00; //dont care
            end
             
        end
        default: //could be used for nops or FENCE, FENCE.I, ECALL, CSR
        begin
            PCLoad = 1; //proceed to the following instruction but dont modify anything
            Branch = 0; 
            JALRBranch = 0;
            JALBranch = 0;
            MemRead = 0; 
            MemtoReg = 1'b0; 
            ALUop = 2'b00;
            MemWrite =0; 
            ALUSrc = 0; 
            RegWrite = 0;
            RFData_control = 2'b00;
        end
        endcase
    end
endmodule
