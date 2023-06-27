`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Digit_seperator(
    input clk,
    input en,
    input [31:0] datain,
    output reg read,
    output reg [3:0] no_of_digits,
    output reg [31:0] A_out,
    output reg [31:0] B_out
    );

    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] data3;
    reg [31:0] data4;
    
    reg [31:0] g1 = 32'd0;
    reg [31:0] g2 = 32'd0;
    reg [31:0] g3 = 32'd0;
    reg [31:0] g4 = 32'd0;
    reg [31:0] g5 = 32'd0;
    reg [31:0] g6 = 32'd0;
    
    reg [31:0] a = 32'd0;
    reg [31:0] b = 32'd0;
    
    reg [31:0] tempdata = 32'd0;
    
    reg [3:0] digit_counter=4'b0;

    reg [3:0] state = 4'd0;
    reg [3:0] nextstate = 4'd0;
    reg [3:0] tencount = 4'd0;
    reg [3:0] thoscount = 4'd0;
    reg [3:0] hundcount = 4'd0;
    reg [3:0] tenthoscount = 4'd0;
    reg [3:0] hunkcount = 4'd0;
    
    localparam [3:0]
        startstate = 4'd00,
        onestate = 4'd01,
        tenstate = 4'd02,
        hunstate = 4'd03,
        onekstate = 4'd04,
        tenkstate = 4'd06,
        hunkstate = 4'd07,
        endstate  = 4'd08;
    
    localparam [31:0]
        one = 32'd1,
        ten = 32'd10,
        hun = 32'd100,
        onek =32'd1000,
        tenk =32'd10000,
        hunk =32'd100000
        ;
    always @(posedge clk)
    begin
    end
    always @(posedge clk)
    begin
        state = nextstate;
    
        case(state)
            startstate: begin                    
                    data1 = datain;
                    read = 1'b0;
                    digit_counter = 4'b0;
                    
                    if(en)begin
                    if(data1 >= tenk ) begin
                        nextstate = hunkstate;
                    end 
                    else if(data1 < tenk) begin
                        nextstate = onekstate;
                    end
                    end 
                    else begin
                        nextstate = startstate;
                    end                           
                   end 
            onestate: begin
                        if(g1< 11) begin
                        a = (g6 *10000)+(g5 *1000)+(g4*100)+(g3*10)+(g2);
                        b = g1;
                        if(en) begin
                            read = 1'b1;
                            no_of_digits = digit_counter;
                            A_out = a;
                            B_out = b;
                        end                                                                       
                   end 
                   end 
            tenstate: begin
                    if(data1 >=ten) begin
                        data1 = data1 -ten;
                        tencount = tencount +1'b01;                      
                    end
                    if(data1 <ten) begin
                        g1 = data1;
                        g2 = tencount;
                        digit_counter = 4'd01;                        
                        nextstate = onestate;                        
                    end                
                    
                   end 
            hunstate: begin
                        if(data1 >= hun) begin
                            data1 = data1 -hun;
                            hundcount = hundcount + 1'b01;
                        end 
                        if(data1 < 100) begin  
                            nextstate = tenstate;
                            digit_counter = 4'd02;  
                            g3 = hundcount;                    
                        end 
                       end 
            onekstate: begin
                        if( data1 >= onek && data1 <= tenk) begin 
                        data1 = data1 -onek;
                        thoscount = thoscount + 1'b01;
                        end
                        if (data1 <onek) begin
                            nextstate = hunstate;
                            digit_counter = 4'd03;                        
                            g4 = thoscount;
                        end                
                       end 
            tenkstate: begin
                        if( data1 >= tenk ) begin 
                            data1 = data1 -tenk;   
                            tenthoscount = tenthoscount + 1'b01;
                            end 
                         if (data1 <tenk) begin
                            nextstate = onekstate;
                            digit_counter = 4'd04;                        
                            g5 = tenthoscount;
                            end 
                        end 
            hunkstate: begin
                        if( data1 >= hunk) begin 
                            data1 = data1 -hunk;   
                            hunkcount = hunkcount + 1'b01;
                            end 
                         if (data1 <hunk) begin
                            nextstate = tenkstate;
                            digit_counter = 4'd05;                        
                            g6 = hunkcount;
                            end 
                        end             
        endcase 
    end
    endmodule

module Digit_seperator_TB;

  // Inputs
  reg clk;
  reg en;
  reg [31:0] datain;

  // Outputs
  wire read;
  wire [3:0] no_of_digits;
  wire [31:0] A_out;
  wire [31:0] B_out;

  // Instantiate the module under test
  Digit_seperator dut (
    .clk(clk),
    .en(en),
    .datain(datain),
    .read(read),
    .no_of_digits(no_of_digits),
    .A_out(A_out),
    .B_out(B_out)
  );

  // Clock generation
  always begin
    clk = 1;
    #5;
    clk = 0;
    #5;
  end

  // Test stimulus
  initial begin
    // Initialize inputs
    en = 1;
    datain = 32'd7896;
    
    #100;
    en = 0;
    // Finish simulation
   end

  // end

endmodule
 