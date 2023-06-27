`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module cube_finder(
  input wire clk,
  input wire en,
  input wire ready,
  input wire [31:0] datain,
  output wire [31:0] dataout,
  output wire [31:0] len_of_data1
);

  reg en_ds;
  wire en_ds_w;
  wire read_ds;

  reg [31:0] data_in_ds;
  
  reg [31:0] data1;
  reg [31:0] data2;
  
  wire [31:0] S1a;
  wire [31:0] S1b;
  
  //reg [31:0] S1DS_out;
  
  reg [31:0] S1_len;
  reg [3:0] no_of_digits_out;
  wire [3:0] no_of_digits_out_w;
  
  reg [3:0] state;
  reg [3:0] nextstate = 4'd0;
  parameter [3:0] S1 = 4'b0000;
  parameter [3:0] S2 = 4'b0001;

  always @(posedge clk) begin
  state = nextstate;
    case (state)
      S1: begin
        data1 = datain;
        
        if (en) begin
            data_in_ds = data1;
            en_ds = 1'b1;
        if (read_ds) begin
            data2 = S1a;
            S1_len = no_of_digits_out;
        end
        
        end
        // State transition
      end

      S2: begin
         // ...
         state = S1;
      end

      default: state = S1; // Initial state
    endcase
   // assign en_ds = en_ds_w;
    assign no_of_digits_out = no_of_digits_out_w;
  end
  
Digit_seperator ds (
    .clk(clk),
    .en(en_ds),
    .datain(data_in_ds),
    .read(read_ds),
    .no_of_digits(no_of_digits_out_w),
    .A_out(S1a),
    .B_out(S1b)
  );

endmodule

 
 
 
module cube_finder_tb;
  
  reg clk;
  reg en;
  reg ready;
  reg [31:0] datain;
  wire [31:0] dataout;
  wire [31:0] len_of_data1;

  cube_finder dut (
    .clk(clk),
    .en(en),
    .ready(ready),
    .datain(datain),
    .dataout(dataout),
    .len_of_data1(len_of_data1)
  );

  // Clock generation
  always begin
    #5 clk = ~clk;
  end
  
  // Test stimulus
  initial begin
    clk = 0;
    en = 1;
    datain = 32'd8568;
    #10;
    
    end
  
endmodule
