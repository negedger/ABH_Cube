module ClockDivider (
    input wire clk,     // Input clock signal
    input wire reset,   // Reset signal
    output reg clk_out // Output divided clock signal
);

reg [15:0] counter;    // 16-bit counter to divide the clock

always @(posedge clk or posedge reset) begin
    if (reset) begin
        counter <= 0;  // Reset the counter
    end else begin
        if (counter == 16'hFFFF) begin
            counter <= 0;  // Reset the counter when it reaches its maximum value
            clk_out <= ~clk_out;  // Toggle the output clock signal to halve the frequency
        end else begin
            counter <= counter + 1;  // Increment the counter
        end
    end
end

endmodule
