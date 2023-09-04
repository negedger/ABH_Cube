`timescale 1ns / 1ps
////////////////////
module LookupTable (
    input wire [1:0] select,
    input wire [3:0] address,
    input wire en,
    input wire clk,
    output reg [9:0] data
);

    reg [9:0] rom_square [9:0];
    reg [9:0] rom_cube [9:0];

    initial begin
        // Initialize the square root lookup table
        rom_square[1] = 10'd1;
        rom_square[2] = 10'd4;
        rom_square[3] = 10'd9;
        rom_square[4] = 10'd16;
        rom_square[5] = 10'd25;
        rom_square[6] = 10'd36;
        rom_square[7] = 10'd49;
        rom_square[8] = 10'd64;
        rom_square[9] = 10'd81;

        // Initialize the cube root lookup table
        rom_cube[1] = 10'd1;
        rom_cube[2] = 10'd8;
        rom_cube[3] = 10'd27;
        rom_cube[4] = 10'd64;
        rom_cube[5] = 10'd125;
        rom_cube[6] = 10'd216;
        rom_cube[7] = 10'd343;
        rom_cube[8] = 10'd512;
        rom_cube[9] = 10'd729;
    end

    always @(posedge clk) begin
        if (en) begin
        case (select)
            2'b01: data = rom_square[address];
            2'b10: data = rom_cube[address];
            default: data = 0;
        endcase
    end
    end

endmodule

module LookupTable_tb;

    reg [1:0] select;
    reg [3:0] address;
    wire [7:0] data;

    LookupTable dut (
        .select(select),
        .address(address),
        .data(data)
    );

    initial begin
        // Test case 1: Calculate square root of 4
        select = 2'b01;
        address = 8'd6;
        #10; // Wait for the output to stabilize
 
        // Test case 2: Calculate cube root of 7
        select = 2'b10;
        address = 8'd5;
        #10; // Wait for the output to stabilize
 
        // Add more test cases here...

        $finish; // End simulation
    end

endmodule
