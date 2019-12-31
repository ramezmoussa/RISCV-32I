`timescale 1ns / 1ps
/*******************************************************************
*
* Module: DataMem.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A module for the data memory
*
**********************************************************************/


module DataMem
 (input clk, input MemRead, input MemWrite, input [14:12] Inst14To12,
 input [31:0] addr, input [31:0] data_in, output reg [31:0] data_out);
 reg [7:0] mem [0:511];

wire [8:0] saddr = addr;
 always @(posedge clk) 
 begin
     if (MemWrite)
     begin
        case(Inst14To12)
            3'b000: mem[saddr] <= data_in[15:0]; //SB
            3'b001: {mem[saddr+1],mem[saddr]} <= data_in[15:0]; //SH
            3'b010: {mem[saddr+3],mem[saddr+2],mem[saddr+1],mem[saddr]} <= data_in; //SW
            default: mem[saddr] <= 0;
        endcase
     end
     else 
     begin
        mem[saddr] <= mem[saddr]; 
     end
 end
 
 /*
initial begin
  //Experiment3
     {mem[3],mem[2],mem[1],mem[0]} =32'd17;
     {mem[7],mem[6],mem[5],mem[4]}=32'd9;
     {mem[11],mem[10],mem[9],mem[8]}=32'd25;
 end 
*/
always@(*)
begin
    if(MemRead)
    begin
        case(Inst14To12)
            3'b000: data_out = {{24{mem[saddr][7]}},mem[saddr]};//LB
            3'b001: data_out = {{16{mem[saddr + 1][7]}},{mem[saddr + 1], mem[saddr]}};//LH
            3'b010: data_out = {mem[saddr+3],mem[saddr+2],mem[saddr+1],mem[saddr]};//LW
            3'b100: data_out = {{24{1'b0}},mem[saddr]};//LBU
            3'b101: data_out = {{16{1'b0}},{mem[saddr + 1], mem[saddr]}};//LHU
            default: data_out = 0;
        endcase
    end
    else
        data_out = 0;
end



initial begin

 //$readmemh("FormatedMemory_Bonus1.mem", mem, 128);
  /*{mem[3],mem[2],mem[1],mem[0]} = 32'd17;
  {mem[7],mem[6],mem[5],mem[4]} = 32'd9;
  {mem[11],mem[10],mem[9],mem[8]} = 32'd25;*/
  
  /*
  {mem[131],mem[130],mem[129],mem[128]}=32'b000000000000_00000_010_00001_0000011 ; //lw x1, 0(x0)
  {mem[135],mem[134],mem[133],mem[132]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
  {mem[139],mem[138],mem[137],mem[136]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
  {mem[143],mem[142],mem[141],mem[140]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
  {mem[147],mem[146],mem[145],mem[144]}=32'b000000000100_00000_010_00010_0000011 ; //lw x2, 4(x0)
  {mem[151],mem[150],mem[149],mem[148]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
  {mem[155],mem[154],mem[153],mem[152]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
  {mem[159],mem[158],mem[157],mem[156]}=32'b0000000_00000_00000_000_00000_0110011 ; //add x0, x0, x0
  {mem[163],mem[162],mem[161],mem[160]}=32'b000000001000_00000_010_00011_0000011 ; //lw x3, 8(x0)
  */
end



initial begin

mem[128]= 8'h93;
mem[129]= 8'h04;
mem[130]= 8'h10;
mem[131]= 8'h00;
mem[132]= 8'h13;
mem[133]= 8'h0d;
mem[134]= 8'hf0;
mem[135]= 8'hff;
mem[136]= 8'h23;
mem[137]= 8'h06;
mem[138]= 8'ha0;
mem[139]= 8'h01;
mem[140]= 8'h23;
mem[141]= 8'h18;
mem[142]= 8'ha0;
mem[143]= 8'h01;
mem[144]= 8'h23;
mem[145]= 8'h2a;
mem[146]= 8'ha0;
mem[147]= 8'h01;
mem[148]= 8'h83;
mem[149]= 8'h24;
mem[150]= 8'h40;
mem[151]= 8'h01;
mem[152]= 8'h83;
mem[153]= 8'h04;
mem[154]= 8'hc0;
mem[155]= 8'h00;
mem[156]= 8'h83;
mem[157]= 8'h14;
mem[158]= 8'h00;
mem[159]= 8'h01;
mem[160]= 8'h83;
mem[161]= 8'h44;
mem[162]= 8'hc0;
mem[163]= 8'h00;
mem[164]= 8'h83;
mem[165]= 8'h54;
mem[166]= 8'h00;
mem[167]= 8'h01;
mem[168]= 8'h83;
mem[169]= 8'h14;
mem[170]= 8'h00;
mem[171]= 8'h01;
mem[172]= 8'h83;
mem[173]= 8'h24;
mem[174]= 8'h40;
mem[175]= 8'h01;
mem[176]= 8'h33;
mem[177]= 8'h89;
mem[178]= 8'h94;
mem[179]= 8'h00;
mem[180]= 8'h93;
mem[181]= 8'h04;
mem[182]= 8'hb0;
mem[183]= 8'hff;
mem[184]= 8'h13;
mem[185]= 8'ha9;
mem[186]= 8'h04;
mem[187]= 8'h00;
mem[188]= 8'h13;
mem[189]= 8'hb9;
mem[190]= 8'h04;
mem[191]= 8'h00;
mem[192]= 8'h93;
mem[193]= 8'hc4;
mem[194]= 8'hb4;
mem[195]= 8'hff;
mem[196]= 8'h44;
mem[197]= 8'h48;
mem[198]= 8'hFD;
mem[199]= 8'h14;
mem[200]= 8'hFD;
mem[201]= 8'h98;
mem[202]= 8'h48;
mem[203]= 8'h48;
mem[204]= 8'hA9;
mem[205]= 8'h8C;
mem[206]= 8'h89;
mem[207]= 8'h8C;
mem[208]= 8'hFD;
mem[209]= 8'h14;
mem[210]= 8'hFD;
mem[211]= 8'h14;
mem[212]= 8'h93;
mem[213]= 8'he4;
mem[214]= 8'h54;
mem[215]= 8'h00;
mem[216]= 8'h93;
mem[217]= 8'hf4;
mem[218]= 8'hf4;
mem[219]= 8'h00;
mem[220]= 8'h93;
mem[221]= 8'h94;
mem[222]= 8'h14;
mem[223]= 8'h00;
mem[224]= 8'h93;
mem[225]= 8'hd4;
mem[226]= 8'h14;
mem[227]= 8'h00;
mem[228]= 8'h93;
mem[229]= 8'h84;
mem[230]= 8'h64;
mem[231]= 8'hff;
mem[232]= 8'h93;
mem[233]= 8'hd4;
mem[234]= 8'h14;
mem[235]= 8'h40;
mem[236]= 8'hb7;
mem[237]= 8'hfa;
mem[238]= 8'hff;
mem[239]= 8'hff;
mem[240]= 8'hb3;
mem[241]= 8'h04;
mem[242]= 8'h90;
mem[243]= 8'h00;
mem[244]= 8'hb3;
mem[245]= 8'h04;
mem[246]= 8'h90;
mem[247]= 8'h40;
mem[248]= 8'hb3;
mem[249]= 8'h94;
mem[250]= 8'h94;
mem[251]= 8'h00;
mem[252]= 8'hb3;
mem[253]= 8'hd4;
mem[254]= 8'ha4;
mem[255]= 8'h01;
mem[256]= 8'hb3;
mem[257]= 8'hd4;
mem[258]= 8'ha4;
mem[259]= 8'h41;
mem[260]= 8'hb3;
mem[261]= 8'ha4;
mem[262]= 8'ha4;
mem[263]= 8'h01;
mem[264]= 8'h93;
mem[265]= 8'h04;
mem[266]= 8'hb0;
mem[267]= 8'hff;
mem[268]= 8'hb3;
mem[269]= 8'h34;
mem[270]= 8'h9d;
mem[271]= 8'h00;
mem[272]= 8'hb3;
mem[273]= 8'hc4;
mem[274]= 8'h94;
mem[275]= 8'h00;
mem[276]= 8'hb3;
mem[277]= 8'he4;
mem[278]= 8'ha4;
mem[279]= 8'h01;
mem[280]= 8'h93;
mem[281]= 8'h04;
mem[282]= 8'hf0;
mem[283]= 8'h00;
mem[284]= 8'hb3;
mem[285]= 8'hf4;
mem[286]= 8'ha4;
mem[287]= 8'h01;
mem[288]= 8'h83;
mem[289]= 8'h24;
mem[290]= 8'h40;
mem[291]= 8'h01;
mem[292]= 8'h63;
mem[293]= 8'h84;
mem[294]= 8'h24;
mem[295]= 8'h01;
mem[296]= 8'h93;
mem[297]= 8'h84;
mem[298]= 8'h14;
mem[299]= 8'h00;
mem[300]= 8'h63;
mem[301]= 8'h94;
mem[302]= 8'ha4;
mem[303]= 8'h01;
mem[304]= 8'h93;
mem[305]= 8'h84;
mem[306]= 8'h14;
mem[307]= 8'h00;
mem[308]= 8'h63;
mem[309]= 8'hc6;
mem[310]= 8'ha4;
mem[311]= 8'h01;
mem[312]= 8'h93;
mem[313]= 8'h84;
mem[314]= 8'h14;
mem[315]= 8'h00;
mem[316]= 8'h83;
mem[317]= 8'h24;
mem[318]= 8'h40;
mem[319]= 8'h01;
mem[320]= 8'h63;
mem[321]= 8'hd4;
mem[322]= 8'ha4;
mem[323]= 8'h01;
mem[324]= 8'h93;
mem[325]= 8'h84;
mem[326]= 8'h14;
mem[327]= 8'h00;
mem[328]= 8'h93;
mem[329]= 8'h04;
mem[330]= 8'hb0;
mem[331]= 8'hff;
mem[332]= 8'h63;
mem[333]= 8'h64;
mem[334]= 8'h9d;
mem[335]= 8'h00;
mem[336]= 8'h93;
mem[337]= 8'h84;
mem[338]= 8'ha4;
mem[339]= 8'h00;
mem[340]= 8'h63;
mem[341]= 8'hf4;
mem[342]= 8'ha4;
mem[343]= 8'h01;
mem[344]= 8'h93;
mem[345]= 8'h84;
mem[346]= 8'ha4;
mem[347]= 8'h00;
mem[348]= 8'hef;
mem[349]= 8'h04;
mem[350]= 8'h40;
mem[351]= 8'h01;
mem[352]= 8'hb3;
mem[353]= 8'h04;
mem[354]= 8'ha0;
mem[355]= 8'h01;
mem[356]= 8'hb3;
mem[357]= 8'h84;
mem[358]= 8'ha4;
mem[359]= 8'h01;
mem[360]= 8'hb3;
mem[361]= 8'h84;
mem[362]= 8'h94;
mem[363]= 8'h00;
mem[364]= 8'h93;
mem[365]= 8'h04;
mem[366]= 8'h90;
mem[367]= 8'h01;
mem[368]= 8'h97;
mem[369]= 8'h14;
mem[370]= 8'h00;
mem[371]= 8'h00;
mem[372]= 8'h17;
mem[373]= 8'h09;
mem[374]= 8'h00;
mem[375]= 8'h00;
mem[376]= 8'h67;
mem[377]= 8'h09;
mem[378]= 8'h09;
mem[379]= 8'h00;
mem[380]= 8'hb3;
mem[381]= 8'h04;
mem[382]= 8'ha0;
mem[383]= 8'h01;
mem[384]= 8'hb3;
mem[385]= 8'h84;
mem[386]= 8'ha4;
mem[387]= 8'h01;
mem[388]= 8'hb3;
mem[389]= 8'h84;
mem[390]= 8'h94;
mem[391]= 8'h00;
mem[392]= 8'h93;
mem[393]= 8'h04;
mem[394]= 8'h90;
mem[395]= 8'h01;


end
endmodule



