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

  reg [3:0] lut_count =0;
  reg [1:0] lut_select;
  reg [3:0] lut_address;
  wire [9:0] lut_data;
  reg [9:0] s2_counter = 0;
  reg lut_en;
  reg lut_c = 0;
    
  reg [31:0] data_in_ds;
  
  reg [31:0] data1;
  reg [31:0] data2;
  reg [31:0] data3;
  
  wire [31:0] S1a;
  wire [31:0] S1b;
  reg [31:0] S2a;
  reg [31:0] S2b;
  reg [31:0] S2la;
  reg [31:0] S2lb;
  reg [31:0] S3a_sub;
  reg [31:0] S3b_sub;
  reg [31:0] S3_aa;
  reg [31:0] S1_2n;
  reg [31:0] S1_3n;
  reg [31:0] S4b2;
  reg [31:0] S5a;
  reg [31:0] S5b;
  reg [31:0] S5a1;
  reg [31:0] S5b1;
  reg [31:0] S5_1n;
  reg [31:0] S5_2n;
  reg [31:0] S5_3n;
  reg [31:0] S5_4n;
  reg [31:0] S5_aa;
  reg [31:0] S5_aaa;
  reg [31:0] S5_bb;
  reg [31:0] S5_bbb;
  reg [31:0] S5_n;

  
  //reg [31:0] S1DS_out;
  
  reg [31:0] S1_len;
  reg [3:0] no_of_digits_out;
  wire [3:0] no_of_digits_out_w;
  
  reg [3:0] state;
  reg [3:0] nextstate = 4'd0;
  parameter [3:0] S0 = 4'd00;
  parameter [3:0] S1 = 4'd01;
  parameter [3:0] S2 = 4'd02;
  parameter [3:0] S3 = 4'd03;
  parameter [3:0] S4 = 4'd04;
  parameter [3:0] S5 = 4'd05;

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
            data3 = S1b;
            S1_len = no_of_digits_out;
            
            if(data2 > 9) begin
                nextstate = S2;
                en_ds = 1'b0;
            end            
        end
        end
        // State transition
      end

      S2: begin
        if(S1_len==3)begin
            en_ds = 1'b01;
            data_in_ds = data2;
            lut_en=0;
            if(s2_counter > 10) begin
              nextstate = S3;
              lut_count = 0;
              s2_counter= 0;
          end
                         
            if (read_ds) begin
                S2a = S1a;
                S2b = S1b;
                lut_count = lut_count +1'b1;
                
                if(lut_count == 3) begin
                    lut_en = 1;
                    lut_select = 2'b01; // 01 sqr
                    lut_address = S2a;
                    S2la = lut_data;
                    s2_counter = s2_counter + 1'b01;
               end
               
               else if(lut_count == 2) begin
                    lut_en = 1;
                    lut_select = 2'b01; // 01 sqr
                    lut_address = S2b;
                    S2lb = lut_data;
               end                                                
            end
        end
      end
      
      S3: begin
        S3b_sub = S2la; // a^2
        S3a_sub = S2lb; // b^2
       // S3_aa = b^2 + (2ab *10 ) + (a^2 *100);
        S3_aa = S3b_sub + ((32'd02 * S2a* S2b)*32'd10) + (S3a_sub * 32'd100); 
        s2_counter = s2_counter + 1'b01;
     
       if(s2_counter > 10) begin
               nextstate = S4;
               s2_counter= 0;
           end
       end
      
      S4: begin
      //to set 2nd term 3ab^2*10
      //b^2
        lut_count = lut_count +1'b1;
 
        if(lut_count == 2) begin
            lut_en = 1;
            lut_select = 2'b01; // 01 sqr
            lut_address = data3;
            S4b2 = lut_data;
            //2nd and 3rd term of b³+(3*a*b²*10)+(3+a²*b*100)+a³*100
            //(3*a*b²*10)
            S1_2n = 32'd03 * data2 * S4b2 * 32'd10; 
            //(3+a²*b*100)
            S1_3n = 32'd03 * S3_aa * data3 * 32'd100;                        
         end
         if(lut_count == 3) begin
            nextstate = S5;
            lut_count = 0;    
        end
      end
         S5: begin
         lut_count = lut_count +1'b1;
         S5a =  data2;
         en_ds = 1;
         data_in_ds = data2;
         if(read_ds) begin
            S5a1 = S1a;
            S5b1 = S1b;
         end
         // now put S5a1 and S5b1 in b³+(3*a*b²*10)+(3*a²*b*100)+a³*100
         //S5 4 terms
         //term1
          if(lut_count == 2) begin
            lut_en = 1;
            lut_select = 2'b10; // cube
            lut_address = S5b1;
            S5_bbb = lut_data;                                 
         end
         if(lut_count == 4) begin
            lut_en = 1;
            lut_select = 2'b10; // cube
            lut_address = S5a1;
            S5_aaa = lut_data;                                 
         end
         if(lut_count == 6) begin
            lut_en = 1;
            lut_select = 2'b01; // sqr
            lut_address = S5b1;
            S5_bb = lut_data;                                 
         end
         if(lut_count == 8) begin
            lut_en = 1;
            lut_select = 2'b01; // sqr
            lut_address = S5a1;
            S5_aa = lut_data;                                 
         end
         // b³+(3*a*b²*10)+(3*a²*b*100)+a³*100
         if(lut_count == 10) begin
         S5_1n = S5_bbb;
         S5_2n = 32'd03 * S5a1 * S5_bb * 32'd10;
         S5_3n = 32'd03 * S5_aa * S5b1 * 32'd100;
         S5_4n = S5_aaa * 32'd100;
         S5_n = S5_1n + S5_1n + S5_1n + S5_1n;
         
         end
         end

      default: nextstate = S1; // Initial state
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

LookupTable lut(
    .select(lut_select),
    .address(lut_address),
    .data(lut_data),
    .en(lut_en)
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
    datain = 32'd123;
    #10;    
    end
  
endmodule
