`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2023 21:35:14
// Design Name: 
// Module Name: cubenormal_tb
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



module tb();

    reg  [31:0] num;
    wire [31:0] cube;

cubenormal uut(
    .num(num),
    .cube(cube)
    );
    
 initial begin
 num = 32'd8;
 
 
 end endmodule
 

