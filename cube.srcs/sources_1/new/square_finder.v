module DataProcessor(
    input wire [31:0] a,
    input wire [31:0] b,
    input wire clk,
    output reg [31:0] data_out_a_sq,
    output reg [31:0] data_out_2ab_100,
    output reg [31:0] data_out_b_sq
);

reg [3:0] lut_count =0;
reg [1:0] lut_select;
reg [3:0] lut_address;
wire [9:0] lut_data;
  
always @(posedge clk) begin
    // Calculate a² x 100 and assign it to data_out_a_sq
    data_out_a_sq <= a * a * 100;

    // Calculate 2 x a x b x 100 and assign it to data_out_2ab_100
    data_out_2ab_100 <= 2 * a * b * 10;

    // Calculate b² and assign it to data_out_b_sq
    data_out_b_sq <= b * b;
end

LookupTable lut(
    .select(lut_select),
    .address(lut_address),
    .data(lut_data),
    .en(lut_en),
    .clk(clk)
);

endmodule

module DataProcessor_tb;

    // Define constants for test values
    parameter A_VAL = 12;
    parameter B_VAL = 3;

    // Declare signals for the module
    reg [31:0] a;
    reg [31:0] b;
    reg clk;
    wire [31:0] data_out_a_sq;
    wire [31:0] data_out_2ab_100;
    wire [31:0] data_out_b_sq;

    // Instantiate the module to be tested
    DataProcessor uut (
        .a(a),
        .b(b),
        .clk(clk),
        .data_out_a_sq(data_out_a_sq),
        .data_out_2ab_100(data_out_2ab_100),
        .data_out_b_sq(data_out_b_sq)
    );

    // Clock generation
    always begin
        #5 clk = ~clk; // Toggle the clock every 5 time units
    end

    // Initial values
    initial begin
        a = A_VAL;
        b = B_VAL;
        clk = 0;
        // Simulate for 20 time units
        #20 $finish;
    end

    // Display results
    initial begin
        $display("a = %d", a);
        $display("b = %d", b);
        $display("a² x 100 = %d", data_out_a_sq);
        $display("2ab x 100 = %d", data_out_2ab_100);
        $display("b² = %d", data_out_b_sq);
    end

endmodule
