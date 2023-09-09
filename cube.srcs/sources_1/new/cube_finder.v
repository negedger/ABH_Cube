`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module cube_finder(
  input wire clk,
  input wire dclk,
  input wire en,
  output reg lut_en,
  input wire read_ds,
  output reg en_ds,
  input wire ready,
  input wire [31:0] datain,
  input wire [9:0] lut_datain,
  input wire [31:0] A_in,
  input wire [31:0] B_in,
  input wire [3:0] no_of_digitsin,
  output reg [31:0] dataout,
  output reg [31:0] digitsep_data,
  output reg [1:0] lut_select,
  output reg [3:0] lut_address,
  output reg [31:0] len_of_data1
);

  wire en_ds_w;
 
  reg [3:0] lut_count =0;
  wire [9:0] lut_data;
  reg [9:0] s2_counter = 0;
  reg lut_c = 0;
    
  reg [31:0] data_in_ds;
  
  reg [31:0] data1;
  reg [31:0] data2;
  reg [31:0] data3;
  
  reg [31:0] S1a;
  reg [31:0] S1b;
  reg [31:0] S2a;
  reg [31:0] S2b;
  reg [31:0] S2la;
  reg [31:0] S2lb;
  reg [31:0] S1_bbb;
  
  reg [31:0] S3a_sub;
  reg [31:0] S3b_sub;
  reg [31:0] S3_aaa;
  reg [31:0] S3_aa;
  reg [31:0] S3_bbb;
  reg [31:0] S3_bb;
  
  reg [31:0] S4_1n;
  reg [31:0] S4_2n;
  reg [31:0] S4_3n;
  reg [31:0] S4_4n;
  reg [31:0] S4n;
  
  reg [31:0] S4b2;
  
  reg [31:0] S5a;
  reg [31:0] S5b;
  reg [31:0] S5aa;
  reg [31:0] S5bb;
  reg [31:0] S5_1n;
  reg [31:0] S5_2n;
  reg [31:0] S5_3n;
  reg [31:0] S5n;
  
  reg [31:0] S5_aa;
  reg [31:0] S5_aaa;
  reg [31:0] S5_bb;
  reg [31:0] S5_bbb;
  reg [31:0] S5_n;

  reg [31:0] S6_1n;
  reg [31:0] S6_2n;
  reg [31:0] S6_3n;
  reg [31:0] S6_4n;
  reg [31:0] S6n;
    
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
  parameter [3:0] S6 = 4'd06;
  parameter [3:0] S7 = 4'd07;
  parameter [3:0] S8 = 4'd08;
  parameter [3:0] S9 = 4'd09;

  always @(posedge clk) begin
  state = nextstate;
    case (state)
      S1: begin
        data1 = datain;
        
        if (en) begin
            digitsep_data = data1;
            en_ds = 1'b1;
            
        if (read_ds) begin
            data2 = A_in;
            data3 = B_in;
            S1a = data2;
            S1b = data3;
           S1_len = no_of_digitsin;
            
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
            //lut_en=0;
            if(s2_counter > 5 && S2a > 10) begin
              lut_en=0;
              S2la = S2a;
              digitsep_data = S2a;
              en_ds = 1'b1;
            end
            if(s2_counter > 9 ) begin 
              S3a_sub = A_in;
              S3b_sub = B_in;              
              nextstate = S3;              
              lut_count = 0;
              s2_counter= 0;
            end
                         
            if (read_ds) begin
                S2a = A_in;
                S2b = B_in;
                lut_count = lut_count +1'b1;
                s2_counter = s2_counter + 1'b01;
                            
                if(lut_count == 4) begin
                    lut_en = 1;
                    lut_select = 2'b01; // 01 sqr
                    lut_address = S2b;
                   // S2lb = lut_datain;
               end  
                if(lut_count == 6) begin
                    S2lb = lut_datain;
               end  
                              
               //s1b³
                 if(lut_count ==1) begin
                    lut_en = 1;
                    lut_select = 2'b10; // 01 sqr 
                    lut_address = S1b;
                  end    
                 if(lut_count == 3) begin
                    S1_bbb = lut_datain; 
                  end                                                
            end
        end
      end
      
      S3: begin
        //S2a = 1 S2b = 2
         lut_en = 0;
         lut_count = lut_count +1'b1;
         //s3a³
         if(lut_count ==1) begin
            lut_en = 1;
            lut_select = 2'b10; // 01 sqr 
            lut_address = S2a;
          end    
         if(lut_count == 3) begin
            S3_aaa = lut_datain; 
          end       
         //s3b³
         if(lut_count ==4) begin
            lut_en = 1;
            lut_select = 2'b10; // 01 sqr 
            lut_address = S2b;
          end    
         if(lut_count == 6) begin
            S3_bbb = lut_datain; 
          end                 
         //s3a²
         if(lut_count ==7) begin
            lut_en = 1;
            lut_select = 2'b01; // 01 sqr 
            lut_address = S2a;
          end    
         if(lut_count == 9) begin
            S3_aa = lut_datain; 
          end       
         //s3b²
         if(lut_count ==10) begin
            lut_en = 1;
            lut_select = 2'b01; // 01 sqr 
            lut_address = S2b;
          end    
         if(lut_count == 12) begin
            S3_bb = lut_datain; 
          end
        if(lut_count == 14) begin
               nextstate = S4;
               lut_count= 0;
           end          
       end          
       
      S4: begin
        //
        lut_count = lut_count +1'b1;
        S4_1n = S3_aaa * 32'd1000;
        S4_2n = 32'd03 * S3_aa * S2b * 32'd100;  
        S4_3n = 32'd03 * S2a * S3_bb * 32'd10; 
        S4_4n = S3_bbb;       
        S4n = S4_1n + S4_2n + S4_3n + S4_4n;    
        if(lut_count < 2) begin
          nextstate = S5;    
          lut_count= 0;
          
        end
        
       end     

         S5: begin
            S5a = S3a_sub;
            S5aa = S3_aa;
            S5b = S3b_sub;
            S5bb = S3_bb;
                    
            S5_1n = S5aa * 32'd100;
            S5_2n = 32'd02 * S5a * S5b * 32'd10;  
            S5_3n =  S3_bb; 
            S5n = S5_1n + S5_2n + S5_3n;
            
            lut_count = lut_count +1'b1;
            if(lut_count == 2) begin
                nextstate = S6;    
                lut_count= 0;
                end
            end
         
         S6:begin
            S6_1n = S4n * 32'd1000;
            S6_2n = 32'd03 * S5n * S1b * 32'd100;           
            S6_3n = 32'd03 * S1a * S2lb * 32'd10; 
            S6_4n = S1_bbb;  
            S6n = S6_1n + S6_2n + S6_3n + S6_4n;                                        
         end 

      default: nextstate = S1; // Initial state
    endcase
   // assign en_ds = en_ds_w;
    //assign no_of_digits_out = no_of_digits_out_w;
  end
   
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
