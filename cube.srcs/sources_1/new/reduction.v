`timescale 1ns / 1ps
//////////////////////////////////////////////////////////////////////////////////
module reduction(clk,datain,dataout);
    input clk;
    input [31:0] datain;
    output [31:0] dataout;
    
    reg [31:0] data1;
    reg [31:0] data2;
    reg [31:0] data3;
    reg [31:0] data4;
    
    reg [31:0] g1;
    reg [31:0] g2;
    reg [31:0] g3;
    reg [31:0] g4;
    reg [31:0] g5;
    
    reg [31:0] tempdata = 32'd0;
    
    reg [2:0] state = 3'b000;
    reg [3:0] tencount = 3'b000;
    reg [3:0] thoscount = 3'b000;
    reg [3:0] hundcount = 3'b000;
    reg [3:0] tenthoscount = 3'b000;
    

    parameter s0 =3'b000, s1 = 3'b001, s2 = 3'b010, s3 = 3'b100, s4 = 3'b101,s5 =3'b110 ;

    always @(posedge clk)
    begin
    if(state == s0) begin
        data1 = datain;
        tempdata =datain;
        end
        //state = state + 1'b01;
        if(state > 6)
            begin
                state = 3'b001;
            end
        case(state) 
            s0: begin
                    tencount = 3'b000; 
                    thoscount = 3'b000;
                    hundcount = 3'b000;
                    tenthoscount =3'b000;
                    g1=32'd0; g2=32'd0; g3=32'd0; g4=32'd0;
                    data1 = datain;
                    if(tempdata != datain) begin
                        state = s1;
                    end                    
                end
            s1: begin
                if(data1 > 10000) begin
                    state=s5;
                end
                if(data1 < 100) begin  
                    state = s3;  
                end
                if( data1 >= 1000 && data1 <= 10000) begin 
                    data1 = data1 -1000;
                    thoscount = thoscount + 1'b01;
                    
                    if (data1 <1000) begin
                        state = s2;
                    end
                    else begin
                        state = s1;
                    end
                end
                end
            s2: begin
                    if(data1 >= 100) begin
                        data1 = data1 -100;
                        hundcount = hundcount + 1'b01;
                    end 
                    if(data1 < 100) begin  
                        state = s3; 
                        g3 = hundcount;
                        g4 = thoscount;
                    end
                    else begin
                        state = s2;
                    end
                end
            s3: begin
                    if(data1 >=10) begin
                        data1 = data1 -10;
                        tencount = tencount +1'b01;                      
                    end
                    if(data1 <10) begin
                        g1 = data1;
                        g2 = tencount;
                        state = s4;                        
                    end                
                    else begin
                        state = s3;
                    end                   
                end
            s4: begin
                    state = 3'b000;    
                    tencount = 3'b000; 
                    thoscount = 3'b000;
                    hundcount = 3'b000;
                end
            s5: begin
                    if( data1 >= 10000) begin 
                    data1 = data1 -10000;
                    tenthoscount = tenthoscount + 1'b01;
                    
                    if (data1 <10000) begin
                        state = s1;
                        g5 = tenthoscount;
                    end
                    else begin
                        state = s5;
                    end
                end
                end
        endcase 
    end
endmodule

module tb_module();
    
    reg clk;
    reg [31:0] datain;
    wire [31:0] dataout;
    
    reduction uut(
        .clk(clk),
        .datain(datain),
        .dataout(dataout)
        );
        
     initial begin 
        clk =0;
       datain = 32'd13456;
        //#500
        //datain = 32'd1000;
        
      end
      
      always begin 
      #5 clk = ~clk;
      end
    endmodule
    