module pc (
    input wire clk,
    input wire reset,
    input wire PCSrc,
    input wire [31:0] ImmExt,
    output reg [31:0] PC,
    output wire [31:0] PCPlus4,
    output wire [31:0] PCTarget
);

    wire [31:0] PCNext;

    // PC update
    always @(posedge clk) begin
        if (reset)
            PC <= 32'b0;
        else
            PC <= PCNext;
    end

    // Next PC decision
    assign PCNext = (PCSrc) ? PCTarget : PCPlus4;

    // Instantiate the adders
    riscv_adder pcadd4 (
        .clk(clk),
        .reset(reset),
        .in_a(PC),
        .in_b(32'd4),
        .out_y(PCPlus4)
    );

    riscv_adder pcaddbranch (
        .clk(clk),
        .reset(reset),
        .in_a(PC),
        .in_b(ImmExt),
        .out_y(PCTarget)
    );

endmodule
