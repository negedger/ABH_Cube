
`timescale 1 ns / 1 ps

module division_core(
   input wire  [31:0] i_dividend,
   input wire  [31:0] i_divisor,
   input wire         i_clk,
   output wire [31:0] result
   );
   
   localparam WORD_WIDTH  = 32;
   localparam START       = 3'd0,
              EXPONENTIAL = 3'd1,
              CHECK       = 3'd2,
              END         = 3'd3;
   
   reg [WORD_WIDTH-1:0] dividend_static = 0;
   reg [WORD_WIDTH-1:0] divisor_static  = 0;
   reg [WORD_WIDTH-1:0] result_static   = 0;
   reg [WORD_WIDTH+2:0] counter         = 0; // might need more bits storage than the WORD-WIDTH. To prevent overflow, two more bits are added.
   reg [WORD_WIDTH+2:0] total_counter   = 0;
   reg [WORD_WIDTH+2:0] total_interim   = 0;
   reg [WORD_WIDTH+2:0] interim_expo    = 0;
   reg [2:0]            current_state   = 0;
                            
   wire [WORD_WIDTH+2:0] counter_expo_next;
   wire [WORD_WIDTH+2:0] interim_expo_next;
   wire [WORD_WIDTH+2:0] total_counter_next;
   wire [WORD_WIDTH+2:0] total_interim_next;
   
   assign result             = result_static;                    
   assign interim_expo_next  = interim_expo  + interim_expo;
   assign counter_expo_next  = counter       + counter;
   assign total_counter_next = total_counter + counter;
   assign total_interim_next = total_interim + interim_expo; 
   
   always @(posedge i_clk) begin
      dividend_static <= i_dividend;
      divisor_static  <= i_divisor;
   end
   
   always @(posedge i_clk) begin
       
      //catch null-division error
      if((dividend_static == 0) || (divisor_static == 0)) begin
         result_static <= 'hBAD1DEA; //Error Message (means 'bad idea' in Hex Speak)
         
      // e.g. 11/11 = 1
      end else if(divisor_static == dividend_static) begin
         result_static <= 1;
      
      // e.g. 12/1 = 12
      end else if(divisor_static == 1) begin
         result_static <= dividend_static;
         
      // cannot calculate floating point numbers, so values smaller than 1 are always 0. E.g. 5/8 = 0.625 = 0  
      end else if(divisor_static > dividend_static)begin
         result_static <= 0;
         
      // else begin calculating the result
      end else begin
      
         case(current_state) // state machine
            
            // reset to start conditionsW
            START: begin
                interim_expo  <= divisor_static;
                total_interim <= divisor_static;
                total_counter <= 1;
                counter       <= 1;
                current_state <= EXPONENTIAL;
            end
            
            // start increasing the counter and the interim result exponentially
            EXPONENTIAL: begin
               if(dividend_static >= total_interim_next)begin  // only increase the counter and the interim result if the interimresult is smaller than the dividend
                  interim_expo  <= interim_expo_next;
                  total_interim <= total_interim_next;
                  counter       <= counter_expo_next;    
                  total_counter <= total_counter_next;
               end else begin    
                  current_state <= CHECK;
               end 
            end 
            
            // Check if we can increase the interim result
            CHECK: begin
               // if yes, reset the counter and the interim result and jump back to the exponential state.
               if(dividend_static >= total_interim + divisor_static) begin
                  counter       <= 1;
                  interim_expo  <= divisor_static;
                  current_state <= EXPONENTIAL;
               end else begin
                  current_state <= END;
               end
            end 
            
           END: begin
              result_static <= total_counter;
              current_state <= START;
           end
   
         endcase
      end
    
   end
   
endmodule


module division_core_tb;
   reg [31:0] i_dividend;
   reg [31:0] i_divisor;
   reg i_clk;
   wire [31:0] result;

   division_core dut (
      .i_dividend(i_dividend),
      .i_divisor(i_divisor),
      .i_clk(i_clk),
      .result(result)
   );

   initial begin
      i_dividend = 966; // Set dividend value
      i_divisor = 5;    // Set divisor value
      i_clk = 0;        // Initialize clock
end 
always begin
      // Apply inputs
      #5 i_clk = 1;
      #5 i_clk = 0;
//       $finish;
   end
endmodule
