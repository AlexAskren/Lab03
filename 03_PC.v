// Parameterized Program Counter Module
module pc #(
    parameter PC_WIDTH = 32  // Default PC/data width
)(
    input wire clk,
    input wire reset,
    input wire PCSrc,                          // Branch control
    input wire [PC_WIDTH-1:0] ImmExt,          // Sign-extended immediate
    output reg [PC_WIDTH-1:0] PC,              // Current PC value
    output wire [PC_WIDTH-1:0] PCPlus4,        // PC + 4
    output wire [PC_WIDTH-1:0] PCTarget        // PC + ImmExt (branch target)
);

    wire [PC_WIDTH-1:0] PCNext;

    // PC update logic
    always @(posedge clk) begin
        if (reset)
            PC <= {PC_WIDTH{1'b0}};
        else
            PC <= PCNext;
    end

    // MUX for choosing next PC value
    assign PCNext = (PCSrc) ? PCTarget : PCPlus4;

    // Adder: PC + 4 (aligned addition)
    riscv_adder #(.DATA_WIDTH(PC_WIDTH)) pcadd4 (
        .clk(clk),
        .reset(reset),
        .in_a(PC),
        .in_b({{PC_WIDTH-3{1'b0}}, 3'b100}),  // Equivalent of 32'd4
        .out_y(PCPlus4)
    );

    // Adder: PC + immediate offset
    riscv_adder #(.DATA_WIDTH(PC_WIDTH)) pcaddbranch (
        .clk(clk),
        .reset(reset),
        .in_a(PC),
        .in_b(ImmExt),
        .out_y(PCTarget)
    );

endmodule
