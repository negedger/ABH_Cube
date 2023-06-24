`timescale 1ns / 1ps
////////////////////
module LookupTable (
    input wire [1:0] select,
    input wire [3:0] address,
    output reg [7:0] data
);

    reg [7:0] rom_square [9:0];
    reg [7:0] rom_cube [9:0];

    initial begin
        // Initialize the square root lookup table
        rom_square[1] = 1;
        rom_square[2] = 4;
        rom_square[3] = 9;
        rom_square[4] = 16;
        rom_square[5] = 25;
        rom_square[6] = 36;
        rom_square[7] = 49;
        rom_square[8] = 64;
        rom_square[9] = 81;

        // Initialize the cube root lookup table
        rom_cube[1] = 1;
        rom_cube[2] = 8;
        rom_cube[3] = 27;
        rom_cube[4] = 64;
        rom_cube[5] = 125;
        rom_cube[6] = 216;
        rom_cube[7] = 343;
        rom_cube[8] = 512;
        rom_cube[9] = 729;
    end

    always @(*) begin
        case (select)
            2'b01: data = rom_square[address];
            2'b10: data = rom_cube[address];
            default: data = 0;
        endcase
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
        address = 4'd9;
        #10; // Wait for the output to stabilize
        $display("Square root of 4: %d", data);

        // Test case 2: Calculate cube root of 7
        select = 2'b10;
        address = 4'd9;
        #10; // Wait for the output to stabilize
        $display("Cube root of 7: %d", data);

        // Add more test cases here...

        $finish; // End simulation
    end

endmodule
