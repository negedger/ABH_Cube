module DecimalDigitGrouping (
  input [31:0] inputNumber,
  output reg [2:0] digitGroup1,
  output reg [2:0] digitGroup2,
  output reg [2:0] digitGroup3,
  output reg [2:0] digitGroup4
);
  reg [31:0] temp;
  integer count;

  always @* begin
    count = 0;
    temp = inputNumber;

    // Calculate the number of decimal digits
    while (temp != 0) begin
      temp = temp / 10;
      count = count + 1;
    end

    // Group the decimal digits as 3-bit values
    case (count)
      1: begin
        digitGroup1 = 3'b000;
        digitGroup2 = 3'b000;
        digitGroup3 = 3'b000;
        digitGroup4 = {3'b000, inputNumber[0]};
      end
      2: begin
        digitGroup1 = 3'b000;
        digitGroup2 = 3'b000;
        digitGroup3 = {3'b000, inputNumber[1]};
        digitGroup4 = {3'b000, inputNumber[0]};
      end
      3: begin
        digitGroup1 = 3'b000;
        digitGroup2 = {3'b000, inputNumber[2]};
        digitGroup3 = {3'b000, inputNumber[1]};
        digitGroup4 = {3'b000, inputNumber[0]};
      end
      default: begin
        digitGroup1 = {3'b000, inputNumber[count-3]};
        digitGroup2 = {3'b000, inputNumber[count-2]};
        digitGroup3 = {3'b000, inputNumber[count-1]};
        digitGroup4 = {inputNumber[count-4], inputNumber[count-5], inputNumber[count-6]};
      end
    endcase
  end
endmodule


module DecimalDigitGrouping_TB;
  reg [31:0] inputNumber;
  wire [2:0] digitGroup1, digitGroup2, digitGroup3, digitGroup4;

  DecimalDigitGrouping dut (
    .inputNumber(inputNumber),
    .digitGroup1(digitGroup1),
    .digitGroup2(digitGroup2),
    .digitGroup3(digitGroup3),
    .digitGroup4(digitGroup4)
  );

  initial begin
    // Testcase 1: inputNumber = 8998
    inputNumber = 32'h00002276;
    #10;
    $display("Input: %d, Digit Group 1: %b, Digit Group 2: %b, Digit Group 3: %b, Digit Group 4: %b",
             inputNumber, digitGroup1, digitGroup2, digitGroup3, digitGroup4);

    // Testcase 2: inputNumber = 123456789
    inputNumber = 32'h075BCD15;
    #10;
    $display("Input: %d, Digit Group 1: %b, Digit Group 2: %b, Digit Group 3: %b, Digit Group 4: %b",
             inputNumber, digitGroup1, digitGroup2, digitGroup3, digitGroup4);

    // Add more test cases as needed

    $finish;
  end
endmodule
