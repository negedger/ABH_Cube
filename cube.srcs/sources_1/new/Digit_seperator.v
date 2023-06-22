`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module Digit_seperator(
    input clk,
    input en,
    input [31:0] datain,
    output dataout
    );

    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] data3;
    reg [31:0] data4;
    
    reg [31:0] g1;
    reg [31:0] g2;
    reg [31:0] g3;
    reg [31:0] g4;
    reg [31:0] g5;
    reg [31:0] g6;
    
    reg [31:0] a;
    reg [31:0] b;
    
    reg [31:0] tempdata = 32'd0;
    
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
                            g6 = hunkcount;
                            end 
                        end             
        endcase 
    end
    endmodule


module Digit_seperator_tb;
  
  // Inputs
  reg clk;
  reg en;
  reg [31:0] datain;
  
  // Outputs
  wire dataout;
  
  // Instantiate the module under test
  Digit_seperator dut (
    .clk(clk),
    .en(en),
    .datain(datain),
    .dataout(dataout)
  );
  
  // Clock generation
  always #5 clk = ~clk;
  
  // Stimulus
  initial begin
    clk = 0;
    en = 0;
    datain = 0;
    
    // Test case 1
    en = 1;
    datain = 999865;
     
    // Test case 2
    /*en = 1;
    datain = 987654321;
    #10 en = 0;
    #10
    */
    // Add more test cases if needed
    
   // $finish;
  end
  
  // Display the output
  always @(posedge clk) begin
    $display("dataout = %d", dataout);
  end
  
endmodule

