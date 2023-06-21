`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
// Company: 
// Engineer: 
// 
// Create Date: 27.04.2023 21:26:42
// Design Name: 
// Module Name: cubenormal
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

module cubenormal(
    input  [31:0] num,
    output [31:0] cube
);
reg [63:0] add_data;
always @ (num) begin
    add_data = num * num * num;
end
assign cube = add_data[31:0];
endmodule

