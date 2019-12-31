/*******************************************************************
*
* Module: newALu.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the Arithmeti and Logic Unit
*
**********************************************************************/

module newALU(
	input   signed [31:0] a, b,
	input   wire [4:0]  shamt,
	output  reg  [31:0] r,
	output  wire        cf, zf, vf, sf,
	input   wire [3:0]  alufn
);

    wire [31:0] add, op_b;
    wire cfa, cfs;
    
    assign op_b = (~b);
    
    assign {cf, add} = alufn[0] ? (a + op_b + 1'b1) : (a + b);
    
    assign zf = (add == 0);
    assign sf = add[31];
    assign vf = (a[31] ^ (op_b[31]) ^ add[31] ^ cf);
  
    always @ * begin
        r = 0;
        (* parallel_case *)
        case (alufn)
            // arithmetic
            4'b00_00 : r = add;
            4'b00_01 : r = add;//sub
            4'b00_11 : r = b; //will not be used
            // logic
            4'b01_00:  r = a | b;
            4'b01_01:  r = a & b;	
            4'b01_11:  r = a ^ b;
            // shift
            4'b10_00:  r= a << b; //SLL
            4'b10_01:  r= a >> b; //SRL
            4'b10_10:  r= a >>> b; //SRA
            // shift immediate
            4'b00_10:  r= a << shamt; //SLLI
            4'b01_10:  r= a >> shamt; //SRLI
            4'b10_11:  r= a >>> shamt; //SRAI
            
            // slt & sltu
            4'b11_01:  r = {31'b0,(sf != vf)}; //slt - slti
            4'b11_11:  r = {31'b0,(~cf)}; //sltu - sltiu           	
            default: r = 0;
        endcase
    end
endmodule