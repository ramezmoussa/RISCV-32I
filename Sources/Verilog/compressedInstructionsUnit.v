/*******************************************************************
*
* Module: compressedInstructionsUnit.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for decoding the possible compressed instructions
*
**********************************************************************/


module compressedInstructionsUnit(input [31:0] memoryOut, output reg [31:0] Instruction, output compressed);
wire [4:0] completeRS1 = memoryOut[9:7] + 8;
wire [4:0] completeRDOrRS2 = memoryOut[4:2] + 8;

assign compressed = (memoryOut[1:0] == 2'b11) ? 0 : 1;
always @(*)
begin
    case(memoryOut[1:0]) // Check Opcode
    2'b01:
        case(memoryOut [15:13]) // Check Funct3
        3'b100:
            case(memoryOut [11:10])
            //SRLI
            2'b00:
                Instruction={7'b0000000, memoryOut [6:2],  completeRS1, 3'b101, completeRS1, 7'b0010011};
            //SRAI
            2'b01:
                Instruction={7'b0100000, memoryOut [6:2], completeRS1, 3'b101, completeRS1, 7'b0010011};
            //andi
            2'b10: 
                Instruction={{7{memoryOut [12]}}, memoryOut [6:2],completeRS1,3'b111, completeRS1, 7'b0010011};
            2'b11:
                case(memoryOut[6:5])
                //sub
                2'b00:
                    Instruction={7'b0100000, completeRDOrRS2, completeRS1, 3'b000, completeRS1, 7'b0110011};
                //xor
                2'b01:
                    Instruction={7'b0000000, completeRDOrRS2, completeRS1, 3'b100, completeRS1, 7'b0110011};
                //or
                2'b10: 
                    Instruction={7'b0000000, completeRDOrRS2, completeRS1, 3'b110, completeRS1, 7'b0110011};
                //and 
                2'b11: 
                    Instruction={7'b0000000, completeRDOrRS2, completeRS1, 3'b111, completeRS1, 7'b0110011};
                default: Instruction = 32'd0;                                                                                 
                endcase
            default: Instruction = 32'd0;    
            endcase
        //BEQZ  
        3'b110:   
            Instruction={ {4{memoryOut[12]}}, memoryOut[6:5], memoryOut[2], 5'b0, completeRS1,3'b000,memoryOut[11:10], memoryOut[4:3], memoryOut[12], 7'b1100011};
        //BNEZ 
        3'b111:      
            Instruction={ {4{memoryOut[12]}}, memoryOut[6:5], memoryOut[2], 5'b0, completeRS1,3'b001, memoryOut[11:10], memoryOut[4:3], memoryOut[12], 7'b1100011};
        //addi
        3'b000:  
            Instruction={{7{memoryOut[12]}}, memoryOut [6:2], memoryOut [11:7], 3'b000, memoryOut [11:7], 7'b0010011};
        //jal
        3'b001: 
            Instruction={memoryOut[12], memoryOut[8], memoryOut[10:9], memoryOut[6], memoryOut[7], memoryOut[2], memoryOut[11], memoryOut[5:3], memoryOut[12], {8{memoryOut[12]}}, 5'b1,7'b1101111};
        //lui
        3'b011:
            Instruction={{15{memoryOut[12]}}, memoryOut[6:2], memoryOut[11:7], 7'b0110111};
          
        default: Instruction = 32'd0;        
        endcase
    2'b10:
        case(memoryOut[15:13]) // Check Funct3
        
        3'b000:
            Instruction={7'b0000000,memoryOut[6:2], memoryOut[11:7], 3'b001,memoryOut [11:7], 7'b0010011};   
        
        3'b100:
            if ((memoryOut[6:2]==5'b0) && (memoryOut[11:7]))
                //EBREAK
                Instruction={32'b00000000000100000000000001110011};         
            else if(memoryOut[6:2] == 5'b0)
                //JAlR 
                Instruction={12'b0,memoryOut[11:7],3'b000,5'b1,7'b1100111 };         
            else//ADD
                Instruction={7'b0000000, memoryOut[6:2], memoryOut[11:7],3'b000,memoryOut[11:7],7'b0110011 };
        default: Instruction = 32'd0;    
        endcase
    2'b00:
            case(memoryOut [15:13]) // Check Funct3
            //sw
            3'b110:
                Instruction={5'b00000, memoryOut [5], memoryOut[12], completeRDOrRS2, completeRS1, 3'b010, memoryOut[11:10],  memoryOut[6],2'b00, 7'b0100011};
            //lw
            3'b010:
                Instruction={5'b00000, memoryOut[5], memoryOut [12:10], memoryOut [6], 2'b00, completeRS1, 3'b010, completeRDOrRS2, 7'b0000011};

            default: Instruction = 32'd0;    
            endcase 
    default: Instruction = memoryOut; //it is not a compressed instruction so just propagate it as is
    endcase
end
endmodule
