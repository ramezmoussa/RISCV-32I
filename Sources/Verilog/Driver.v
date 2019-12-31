`timescale 1ns / 1ps
/*******************************************************************
*
* Module: Driver.v
* Project: Architecture Projct 1
* Author: Abdallah El-Refaey/ Hany Moussa / Mohamed ElTohfa / Ramez Moussa
* Description: A driver module for the whole project to be run on the FPGA with
chosen LEDS and 7-segment-display for testing
*
**********************************************************************/


module Driver(
input DatapathClk,
input SSDClk,
input rst,
input [1:0] ledSel,
input [3:0] ssdSel,
output [15:0] LEDS,
output  [3:0] Anode,
output  [6:0] LED_out);

wire [12:0] SSDInput;
RISCV myProcessor(DatapathClk, rst, ledSel, ssdSel, LEDS, SSDInput);
Four_Digit_Seven_Segment_Driver_Optimized myDisplayer(SSDClk, SSDInput, Anode, LED_out);


endmodule
