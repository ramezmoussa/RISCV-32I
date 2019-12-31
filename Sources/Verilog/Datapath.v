`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Datapath.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the data memory
*
**********************************************************************/


module Datapath(
input clk,
input rst,
output reg [31:0] inputToMemoryAddress, //PC or MEMORY INPUT (EXMEM_ALUOut)
output [31:0] PCPlus4,
output [31:0] PCPlusShiftedImm,
output [31:0] newPC,
output [31:0] readData1,
output [31:0] EXMEM_readData2, //data entering the memory (when writing to the memory)
output reg [31:0] RFData, //reg file input
output [31:0] gen_out,
output [31:0] ALUInput2,
output [31:0] ALUOut,
output [31:0] instructionOrMemOut, //memory out
output [1:0] ALUop,
output [3:0] ALUSelection,
output zeroFlag,
output BranchMuxSelection,
output [31:0] instructionOrMemOutDuplicate, //memory out as well (used for display on fpga)
output Branch,
output EXMEM_MemRead,
output MemtoReg,
output EXMEM_MemWrite,
output ALUSrc,
output EXMEM_WB,
output reg sclk
);

wire [31:0] instructionOrMemOutDuplicate = instructionOrMemOut; //just for displaying on 
wire [31:0] IFID_inst;
wire [31:0] IFID_PC;
wire [31:0] IFID_PCPlus4;
wire IFID_compressed;

wire [31:0] IDEX_PC;
wire [31:0] IDEX_ImmGen;
wire [31:0] IDEX_readData1;
wire [31:0] IDEX_readData2; 
wire [19:15] IDEX_inst_19to15;
wire [24:20]  IDEX_inst_24to20;
wire [14:12] IDEX_inst_14to12;
wire IDEX_inst_30;
wire [11:7] IDEX_inst_11to7;
wire IDEX_WB;
wire IDEX_MemRead;
wire IDEX_Branch;
wire IDEX_MemWrite;
wire [1:0] IDEX_ALUop;
wire IDEX_ALUSrc;
wire IDEX_MemtoReg;
wire IDEX_JALRBranch;
wire IDEX_JALBranch;
wire [1:0] IDEX_RFData_control;
wire [31:0] IDEX_PCPlus4;

wire EXMEM_WB;
wire EXMEM_MemWrite;
wire [14:12] EXMEM_inst_14to12;
wire EXMEM_BranchMuxSelection;
wire EXMEM_MemRead;
wire [31:0] EXMEM_PCPlusShiftedImm;
wire [31:0] EXMEM_ALUOut;
wire [31:0] EXMEM_readData2;
wire [11:7] EXMEM_inst_11to7;
wire EXMEM_MemtoReg;
wire EXMEM_JALBranch;
wire EXMEM_JALRBranch;
wire [1:0] EXMEM_RFData_control;
wire [31:0] EXMEM_ImmGen;
wire [31:0] EXMEM_PCPlus4;


wire MEMWB_WB;
wire [31:0] MEMWB_ALUOut;
wire [31:0] MEMWB_MemDataOut;
wire [11:7] MEMWB_inst_11to7;
wire MEMWB_MemtoReg;
wire [1:0] MEMWB_RFData_control;
wire [31:0] MEMWB_ImmGen;
wire [31:0] MEMWB_PCPlus4;
wire [31:0] MEMWB_PCPlusShiftedImm;

reg [31:0] ALUInput1WithForwarding;
reg [31:0] readData2WithForwarding;
wire [31:0] instructionOrMemOut;

wire stall;

wire forawrdA, forwardB;
//reg sclk; //slow clock (half the frequency)
initial begin
    sclk = 1;
end

always@(posedge clk, posedge rst)
begin
    if(rst)
        sclk = 1;
    else
        sclk = ~sclk;
end

wire nsclk = ~sclk; //the opposite of sclk (used instead of negedge sclk)
    
    
wire [31:0] PC;
reg [31:0] newPC;
wire PCLoad;
wire [31:0] PCPlus4;
//The ORing of PCLoad and (newPC!=PCPlus4) is to ignore 
//EBREAK if we are to branch the EBREAK
NBitReg #(32) myPC(sclk, rst, (!stall)&(PCLoad|(newPC != PCPlus4)), newPC, PC);

//multiplexer for the memory address (either PC or address from ALU (to be pipelined) )
reg [31:0] inputToMemoryAddress;
always@(*)
begin
    case(sclk)
        1'b0: inputToMemoryAddress = EXMEM_ALUOut;
        1'b1: inputToMemoryAddress = PC + 128; //instructions start from address 128 in the memory
    endcase
end

wire PCPlus4Cout;
NBitAdderSub #(32) PCPlus4Adder(PC, 4,0, PCPlus4, PCPlus4Cout);



wire Branch, MemRead, MemtoReg, MemWrite, ALUSrc, RegWrite, JALRBranch, JALBranch;
wire [1:0] ALUop;
wire [1:0] RFData_control;
controlUnit Control(
IFID_inst[6:0],
IFID_inst[20],
Branch,
MemRead,
MemtoReg,
ALUop,
MemWrite,
ALUSrc,
RegWrite,
JALRBranch,
JALBranch,
RFData_control,
PCLoad);


reg newBranch;
reg newMemRead;
reg newMemtoReg;
reg [1:0] newALUop;
reg newMemWrite;
reg newALUSrc;
reg newRegWrite ;
reg newJALRBranch ;
reg newJALBranch ;
reg [1:0] newRFData_control ;
        
        


always@(*)
begin
    if(stall)
    begin
         newBranch = 0;
         newMemRead = 0;
         newMemtoReg = 0;
         newMemWrite = 0;
         newALUop = 2'b00;
         newALUSrc = 0;
         newRegWrite = 0;
         newJALRBranch = 0;
         newJALBranch = 0;
         newRFData_control = 2'b00;
     end
     else
     begin
        newBranch = Branch;
        newMemRead = MemRead;
        newMemtoReg = MemtoReg;
        newMemWrite = MemWrite;
        newALUop = ALUop;
        newALUSrc = ALUSrc;
        newRegWrite = RegWrite;
        newJALRBranch = JALRBranch;
        newJALBranch = JALBranch;
        newRFData_control = RFData_control;
    end
end

reg newEXMEMBranch;
reg newEXMEMMemRead;
reg newEXMEMMemtoReg;
reg [1:0] newEXMEMALUop;
reg newEXMEMMemWrite;
reg newEXMEMALUSrc;
reg newEXMEMRegWrite ;
reg newEXMEMJALRBranch ;
reg newEXMEMJALBranch ;
reg [1:0] newEXMEMRFData_control ;


always@(*)
begin
    // if(newPC != PCPlus4)
    // begin
    //     newEXMEMMemRead = 0;
    //     newEXMEMMemtoReg = 0;
    //     newEXMEMMemWrite = 0;
    //     newEXMEMRegWrite = 0;
    //     newEXMEMJALRBranch = 0;
    //     newEXMEMJALBranch = 0;
    //     newEXMEMRFData_control = 2'b00;
    // end
    // else
    // begin
        newEXMEMMemRead = IDEX_MemRead;
        newEXMEMMemtoReg = IDEX_MemtoReg;
        newEXMEMMemWrite = IDEX_MemWrite;
        newEXMEMRegWrite = IDEX_WB;
        newEXMEMJALRBranch = IDEX_JALRBranch;
        newEXMEMJALBranch = IDEX_JALBranch;
        newEXMEMRFData_control = IDEX_RFData_control;
    // end
end


reg [31:0] RFData;

wire [31:0] dataFromMemMux;
wire [31:0] readData1;
wire [31:0] readData2;
RegFile #(32) Registers(
nsclk,
rst,
IFID_inst[19:15],
IFID_inst[24:20],
MEMWB_inst_11to7,
MEMWB_WB,
RFData,
readData1,
readData2);


always@(*)
begin
    case(MEMWB_RFData_control)
        2'b00: RFData = dataFromMemMux;
        2'b01: RFData = MEMWB_ImmGen;
        2'b10: RFData = MEMWB_PCPlus4Or2;
        2'b11: RFData = MEMWB_PCPlusShiftedImm; //AUIPIC
        default: RFData = 32'b0;
    endcase
end



wire [31:0] gen_out;
newImmGen ImmediateGenerator(IFID_inst, gen_out);


wire [31:0] PCPlusShiftedImm;
wire PCPlusShiftedImmCout;
NBitAdderSub #(32) PCPlusShiftedImmAdder(IDEX_PC, IDEX_ImmGen,0, 
                PCPlusShiftedImm, PCPlusShiftedImmCout);
               
wire [31:0] ALUInput2;
NBitMux2x1 #(32) ALUMux(readData2WithForwarding, IDEX_ImmGen, IDEX_ALUSrc, ALUInput2);

wire [3:0] ALUSelection;
ALUControl myALUControl(IDEX_ALUop, IDEX_inst_14to12, IDEX_inst_30, ALUSelection);

wire zeroFlag;
wire [31:0] ALUOut;
wire cf, vf, sf;
newALU myALU(ALUInput1WithForwarding, ALUInput2, IDEX_inst_24to20, ALUOut, cf, zeroFlag, vf, sf, ALUSelection);

reg BranchMuxSelection;



// always@(*) //BranchMuxSelection
// begin
//     case(IFID_inst[14:12])
//         3'b000: BranchMuxSelection = Branch&(readData1==readData2);
//         3'b001: BranchMuxSelection = Branch&(~(readData1==readData2));
//         3'b100: BranchMuxSelection = (readData1<readData2)? 0: Branch;
//         3'b101: BranchMuxSelection = (!(readData1<readData2))? 0: Branch;
//         3'b110: BranchMuxSelection = Branch&~cf;
//         3'b111: BranchMuxSelection = Branch&cf;
//         default: BranchMuxSelection = 0;
//     endcase
// end


wire branchingORJaling = Branch|JALRBranch|JALBranch;
reg [31:0] BranchingForwardedRS1;// = ((IFID_inst[19:15] == EXMEM_inst_11to7)&& (EXMEM_inst_11to7 != 0) && (branchingORJaling))? EXMEM_ALUOut: readData1;
reg [31:0] BranchingForwardedRS2;// = ((IFID_inst[24:20] == EXMEM_inst_11to7) &&(EXMEM_inst_11to7 != 0) && (branchingORJaling))? EXMEM_ALUOut: readData2;
always@(*)
begin
    if(branchingORJaling)
    begin
            if((IFID_inst[19:15] == EXMEM_inst_11to7)&& (EXMEM_inst_11to7 != 0) && (EXMEM_WB))
            begin
                if(EXMEM_RFData_control == 2'b11) 
                    BranchingForwardedRS1 = EXMEM_PCPlusShiftedImm;
                else
                    BranchingForwardedRS1 = EXMEM_ALUOut;
            end
            else
                BranchingForwardedRS1 = readData1;
               
               
            
            if((IFID_inst[24:20] == EXMEM_inst_11to7)&& (EXMEM_inst_11to7 != 0) && (EXMEM_WB))
            begin
                if(EXMEM_RFData_control == 2'b11) 
                    BranchingForwardedRS2 = EXMEM_PCPlusShiftedImm; //it was an AUIPC
                else
                    BranchingForwardedRS2 = EXMEM_ALUOut;
            end
            else
                BranchingForwardedRS2 = readData2;  
            
    end
end


// moving comparison to ID stage
wire ncf, nzf, nvf, nsf;
wire [31:0] op_2, op_b; 
wire [31:0] add;

assign op_2= ALUSrc? gen_out: BranchingForwardedRS2; 
assign op_b = ~op_2; 
assign {ncf, add} =  (BranchingForwardedRS1 +  op_b + 1'b1); 
assign nzf = (add == 0);
assign nsf = add[31];
assign nvf = (BranchingForwardedRS1[31] ^ (op_b[31]) ^ add[31] ^ ncf);


always@(*) //BranchMuxSelection
begin
    case(IFID_inst[14:12])
        3'b000: BranchMuxSelection = Branch&nzf;
        3'b001: BranchMuxSelection = Branch&(~nzf);
        3'b100: BranchMuxSelection = (nsf == nvf)? 0: Branch;
        3'b101: BranchMuxSelection = (nsf != nvf)? 0: Branch;
        3'b110: BranchMuxSelection = Branch&~ncf;
        3'b111: BranchMuxSelection = Branch&ncf;
        default: BranchMuxSelection = 0;
    endcase
end

// always@(*) //BranchMuxSelection
// begin
//     case(IDEX_inst_14to12)
//         3'b000: BranchMuxSelection = IDEX_Branch&zeroFlag;
//         3'b001: BranchMuxSelection = IDEX_Branch&(~zeroFlag);
//         3'b100: BranchMuxSelection = (sf == vf)? 0: IDEX_Branch;
//         3'b101: BranchMuxSelection = (sf != vf)? 0: IDEX_Branch;
//         3'b110: BranchMuxSelection = IDEX_Branch&~cf;
//         3'b111: BranchMuxSelection = IDEX_Branch&cf;
//         default: BranchMuxSelection = 0;
//     endcase
// end

wire [31:0] MemDataOut;

wire readSignal = (sclk)? 1: EXMEM_MemRead;
wire writeSignal = (sclk)? 0:EXMEM_MemWrite;
wire [14:12] readWholeWord = (sclk)? 3'b010: EXMEM_inst_14to12;
DataMem DataMemory(clk, readSignal, writeSignal, readWholeWord, inputToMemoryAddress, EXMEM_readData2, instructionOrMemOut);

//Old pc calculations 
// always@(*) //PC Mux
// begin
//     if(EXMEM_JALRBranch) newPC = EXMEM_ALUOut; 
//     else if(EXMEM_JALBranch || EXMEM_BranchMuxSelection) newPC = EXMEM_PCPlusShiftedImm;
//     else newPC = PCPlus4;
// end


// Compressed Instructions module
wire [31:0] compressedOrFullInstruction;
wire compressed;
compressedInstructionsUnit compressedInstructions(instructionOrMemOut, compressedOrFullInstruction, compressed);


//Moving PC calculations to ID stage
always@(*) //PC Mux
begin
    if(JALRBranch) newPC = BranchingForwardedRS1+gen_out; 
    else if(JALBranch || BranchMuxSelection) newPC = PC + gen_out ;
    else newPC = (!IFID_compressed)? PCPlus4:PC+2; 
end





NBitMux2x1 #(32) WriteBackMUX (MEMWB_ALUOut, MEMWB_MemDataOut, MEMWB_MemtoReg, dataFromMemMux);



//forwarding unit
forwardingUnit myFU (
    IDEX_inst_19to15,
    IDEX_inst_24to20,
    MEMWB_inst_11to7,
    MEMWB_WB,
    forwardA,
    forwardB
    );



always@(*)
begin
    case(forwardA)
        2'b0: ALUInput1WithForwarding = IDEX_readData1;
        
        //RFData control = 2'b11 means we need to take PCPlusShiftedImm (prev was AUIPC)
        2'b1: ALUInput1WithForwarding = (MEMWB_RFData_control == 2'b11)? MEMWB_PCPlusShiftedImm:dataFromMemMux;
    endcase
    
    case(forwardB)
        2'b0: readData2WithForwarding = IDEX_readData2;
        //RFData control = 2'b11 means we need to take PCPlusShiftedImm (prev was AUIPC)
        2'b1: readData2WithForwarding = (MEMWB_RFData_control == 2'b11)? MEMWB_PCPlusShiftedImm:dataFromMemMux;
    endcase
end


//load use hazard (needed becasue we moved branching to an earlier stage
assign stall = (branchingORJaling)&&((EXMEM_inst_11to7 == IFID_inst[19:15]) && (EXMEM_inst_11to7 != 0) && (EXMEM_MemRead)) | ((EXMEM_inst_11to7 == IFID_inst[24:20]) && (EXMEM_inst_11to7 != 0) && (EXMEM_MemRead));

wire [31:0] PCPlus4Or2;
assign PCPlus4Or2 = (compressed)? PC + 2: PCPlus4;


//pipelining
//IFID
NBitReg #(32) IFID_inst_Reg(nsclk, rst, 1, compressedOrFullInstruction, IFID_inst);
NBitReg #(32) IFID_PC_Reg(nsclk, rst, 1, PC, IFID_PC);
NBitReg #(32) IFID_PCPlus4Or2_Reg(nsclk, rst, 1, PCPlus2Or4, IFID_PCPlus4Or2);
NBitReg #(32) IFID_Compressed_Reg(nsclk, rst, 1, compressed, IFID_compressed);
//IDEX
NBitReg #(32) IDEX_PC_Reg(sclk, rst, 1,IFID_PC , IDEX_PC);
NBitReg #(32) IDEX_ImmGen_Reg(sclk, rst, 1, gen_out, IDEX_ImmGen);
NBitReg #(32) IDEX_readData1_Reg(sclk, rst, 1, readData1, IDEX_readData1);
NBitReg #(32) IDEX_readData2_Reg(sclk, rst, 1, readData2, IDEX_readData2);
NBitReg #(32) IDEX_inst_19to15_Reg(sclk, rst, 1, IFID_inst[19:15], IDEX_inst_19to15);
NBitReg #(5) IDEX_inst_24to20_Reg(sclk, rst, 1, IFID_inst[24:20], IDEX_inst_24to20);
NBitReg #(3) IDEX_inst_14to12_Reg(sclk, rst, 1, IFID_inst[14:12], IDEX_inst_14to12);
NBitReg #(1) IDEX_inst_30_Reg(sclk, rst, 1, IFID_inst[30], IDEX_inst_30);
NBitReg #(5) IDEX_inst_11to7_Reg(sclk, rst, 1, IFID_inst[11:7], IDEX_inst_11to7);
NBitReg #(1) IDEX_WB_Reg(sclk, rst, 1,newRegWrite, IDEX_WB);
NBitReg #(1) IDEX_MemRead_Reg(sclk, rst, 1,newMemRead, IDEX_MemRead);
NBitReg #(1) IDEX_Branch_Reg(sclk, rst, 1,newBranch, IDEX_Branch);
NBitReg #(1) IDEX_MemWrite_Reg(sclk, rst, 1,newMemWrite, IDEX_MemWrite);
NBitReg #(2) IDEX_ALUop_Reg(sclk, rst, 1,newALUop, IDEX_ALUop);
NBitReg #(1) IDEX_ALUSrc_Reg(sclk, rst, 1,newALUSrc, IDEX_ALUSrc);
NBitReg #(1) IDEX_MemtoReg_Reg(sclk, rst, 1,newMemtoReg, IDEX_MemtoReg);
NBitReg #(1) IDEX_JALRBranch_Reg(sclk, rst, 1,newJALRBranch, IDEX_JALRBranch);
NBitReg #(1) IDEX_JALBranch_Reg(sclk, rst, 1,newJALBranch, IDEX_JALBranch);
NBitReg #(2) IDEX_RFData_control_Reg(sclk, rst, 1,newRFData_control, IDEX_RFData_control);
NBitReg #(32) IDEX_PCPlus4Or2_Reg(sclk, rst, 1, IFID_PCPlus4Or2, IDEX_PCPlus4Or2);
//we didnt pipeline PCLoad as we would stop fetching as soon as we recognize an EBREAK


//EXMEM
NBitReg #(1) EXMEM_WB_Reg(nsclk, rst, 1,newEXMEMRegWrite, EXMEM_WB);
NBitReg #(1) EXMEM_MemWrite_Reg(nsclk, rst, 1,newEXMEMMemWrite, EXMEM_MemWrite);
NBitReg #(3) EXMEM_inst_14to12_Reg(nsclk, rst, 1, IDEX_inst_14to12, EXMEM_inst_14to12);
NBitReg #(1) EXMEM_BranchMuxSelection_Reg(nsclk, rst, 1,BranchMuxSelection, EXMEM_BranchMuxSelection);
NBitReg #(1) EXMEM_MemRead_Reg(nsclk, rst, 1,newEXMEMMemRead, EXMEM_MemRead);
NBitReg #(32) EXMEM_PCPlusShiftedImm_Reg(nsclk, rst, 1,PCPlusShiftedImm, EXMEM_PCPlusShiftedImm);
NBitReg #(32) EXMEM_ALUOut_Reg(nsclk, rst, 1,ALUOut, EXMEM_ALUOut);
NBitReg #(32) EXMEM_readData2_Reg(nsclk, rst, 1, readData2WithForwarding, EXMEM_readData2);
NBitReg #(5) EXMEM_inst_11to7_Reg(nsclk, rst, 1, IDEX_inst_11to7, EXMEM_inst_11to7);
NBitReg #(1) EXMEM_MemtoReg_Reg(nsclk, rst, 1,newEXMEMMemtoReg, EXMEM_MemtoReg);
NBitReg #(1) EXMEM_JALRBranch_Reg(nsclk, rst, 1,newEXMEMJALRBranch, EXMEM_JALRBranch);
NBitReg #(1) EXMEM_JALBranch_Reg(nsclk, rst, 1,newEXMEMJALBranch, EXMEM_JALBranch);
NBitReg #(2) EXMEM_RFData_control_Reg(nsclk, rst, 1,newEXMEMRFData_control, EXMEM_RFData_control);
NBitReg #(32) EXMEM_ImmGen_Reg(nsclk, rst, 1, IDEX_ImmGen, EXMEM_ImmGen);
NBitReg #(32) EXMEM_PCPlus4Or2_Reg(nsclk, rst, 1, IDEX_PCPlus4Or2, EXMEM_PCPlus4Or2);


//MEMWB
NBitReg #(1) MEMWB_WB_Reg(sclk, rst, 1,EXMEM_WB, MEMWB_WB);
NBitReg #(32) MEMWB_ALUOut_Reg(sclk, rst, 1,EXMEM_ALUOut, MEMWB_ALUOut);
NBitReg #(32) MEMWB_MemDataOut_Reg(sclk, rst, 1,instructionOrMemOut, MEMWB_MemDataOut);
NBitReg #(5) MEMWB_inst_11to7_Reg(sclk, rst, 1, EXMEM_inst_11to7, MEMWB_inst_11to7);
NBitReg #(1) MEMWB_MemtoReg_Reg(sclk, rst, 1,EXMEM_MemtoReg, MEMWB_MemtoReg);
NBitReg #(2) MEMWB_RFData_control_Reg(sclk, rst, 1,EXMEM_RFData_control, MEMWB_RFData_control);
NBitReg #(32) MEMWB_ImmGen_Reg(sclk, rst, 1, EXMEM_ImmGen, MEMWB_ImmGen);
NBitReg #(32) MEMWB_PCPlus4Or2_Reg(sclk, rst, 1, EXMEM_PCPlus4Or2, MEMWB_PCPlus4Or2);
NBitReg #(32) MEMWB_PCPlusShiftedImm_Reg(sclk, rst, 1,EXMEM_PCPlusShiftedImm, MEMWB_PCPlusShiftedImm);


endmodule