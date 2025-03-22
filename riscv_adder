// Parameterized Adder Module
module riscv_adder(
    input wire clk,
    input wire reset,
    input wire [31:0] in_a,
    input wire [31:0] in_b,
    output reg [31:0] out_y
);

    always @(posedge clk) begin
        if (reset)
            out_y <= 32'b0;
        else
            out_y <= in_a + in_b;
    end

endmodule
