module DivisionExample;
  reg [8:0] dividend;
  reg [3:0] divisor;
  wire [7:0] reminder;

  assign reminder = dividend  % divisor;

  initial begin
    dividend = 9'b101000000; // 320
    divisor = 4'b1010; // 10

    $display("Dividend: %d", dividend);
    $display("Divisor: %d", divisor);
    $display("reminder: %d", reminder);
    
    $finish;
  end
endmodule
