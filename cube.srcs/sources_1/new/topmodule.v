`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module topmodule(
   input wire clk,
   input wire en, 
   input wire [31:0] datain 
   );

wire inclk;
wire dvclk;
wire en_dsw;
wire en_ds_w;
wire read_dsw;
wire [31:0] data_in_ds;
wire [31:0] dataout;
wire [31:0] A;
wire [31:0] B;
wire [3:0] no_of_digits_out_w;
wire [3:0] lut_address;
wire [9:0] lut_data;
wire [1:0] lut_select;

cube_finder cube (
    .clk(clk),
    .dclk(dvclk),
    .en(en),
    .en_ds(en_dsw),
    .read_ds(read_dsw),
    .ready(ready),
    .datain(datain),
    .lut_en(lut_enw),
    .no_of_digitsin(no_of_digits_out_w),
    .A_in(A),
    .B_in(B),
    .lut_datain(lut_data),
    .lut_select(lut_select),
    .lut_address(lut_address),
    .dataout(dataout),
    .digitsep_data(data_in_ds),
    .len_of_data1(len_of_data1)
  );
      
Digit_seperator ds (
    .clk(clk),
    .en(en_dsw),
    .datain(data_in_ds),
    .read(read_dsw),
    .no_of_digits(no_of_digits_out_w),
    .A_out(A),
    .B_out(B)
  );

LookupTable lut(
    .select(lut_select),
    .address(lut_address),
    .data(lut_data),
    .en(lut_enw),
    .clk(clk)
);
  
ClockDivider clkd (
    .clk(clk),        
    .reset(reset),   
    .clk_out(dvclk) 
);   
endmodule

module testbench;

  // Inputs
  reg clk;
  reg en;
  reg [31:0] datain;

  // Instantiate the module under test
  topmodule uut (
    .clk(clk),
    .en(en),
    .datain(datain)
  );

  // Clock generation
  always begin
    #5 clk = ~clk; // Assuming a 10 ns clock period (adjust as needed)
  end

  // Initialize signals
  initial begin
    clk = 0;
    en = 1;
    datain = 32'd123; // Set datain to 123
    // Add any other initializations here
  end

  // Stimulus generation
  initial begin
    // Insert your test stimulus here
    // You can apply input changes, monitor outputs, and check for expected results
    // For example, you can apply a sequence of inputs, wait for some time, and then check the outputs
    // Use $display or $monitor to print simulation results
    // Example:
    //$display("At time %t, datain = %h", $time, datain);
    //$display("At time %t, output = %h", $time, uut.output);
    // ...

    // Terminate the simulation after a period of time or when your testing is complete
    #3000;
    $finish;
  end

endmodule
