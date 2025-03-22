
module register_file (
    input wire clk,
    input wire rst,              // synchronous active-high reset
    input wire WE3,              // write enable
    input wire [4:0] A1,         // read register 1 address
    input wire [4:0] A2,         // read register 2 address
    input wire [4:0] A3,         // write register address
    input wire [31:0] WD3,       // write data
    output wire [31:0] RD1,      // read data 1
    output wire [31:0] RD2       // read data 2
);

    reg [31:0] Register [0:31];
    integer i;

    // Synchronous write and reset
    always @(posedge clk) begin
        if (rst) begin
            for (i = 0; i < 32; i = i + 1)
                Register[i] <= 32'b0;
        end
        else if (WE3 && A3 != 5'b00000) begin
            Register[A3] <= WD3; // Prevent writing to x0
        end
    end

    // Combinational reads
    assign RD1 = (rst) ? 32'b0 : Register[A1];
    assign RD2 = (rst) ? 32'b0 : Register[A2];

    // Optional: initialize some registers for debug/demo
    initial begin
        Register[5] = 32'h00000005;
        Register[6] = 32'h00000004;
    end

endmodule
