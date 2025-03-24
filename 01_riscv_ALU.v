module riscv_ALU(
    input wire clk,
    input wire reset,
    input wire [4:0] ALU_ctrl,               // Supports up to 32 operations
    input wire [31:0] ALU_ina,               // Operand A
    input wire [31:0] ALU_inb,               // Operand B
    output reg [31:0] ALU_out,               // Output result
    output wire Overflow_flag,              // Overflow detection
    output wire Carry_flag,                 // Carry detection
    output wire Negative_flag,              // MSB
    output wire Zero_flag                   // All zero check
);

    wire signed [31:0] A_signed = ALU_ina;
    wire signed [31:0] B_signed = ALU_inb;
    wire [31:0] A_unsigned = ALU_ina;
    wire [31:0] B_unsigned = ALU_inb;

    wire [63:0] mult_signed   = A_signed * B_signed;
    wire [63:0] mult_unsigned = A_unsigned * B_unsigned;
    wire [63:0] mult_mix      = A_signed * B_unsigned;

    wire [31:0] add_result = ALU_ina + ALU_inb;
    wire [31:0] sub_result = ALU_ina - ALU_inb;

    always @(*) begin
        case (ALU_ctrl)
            5'b00000: ALU_out = ALU_ina + ALU_inb;                      // ADD
            5'b00001: ALU_out = ALU_ina - ALU_inb;                      // SUB
            5'b00010: ALU_out = mult_signed[31:0];                      // MUL
            5'b00011: ALU_out = mult_signed[63:32];                     // MULH
            5'b00100: ALU_out = mult_mix[63:32];                        // MULHSU
            5'b00101: ALU_out = mult_unsigned[63:32];                   // MULHU
            5'b00110: ALU_out = (B_signed == 0) ? 32'hFFFFFFFF : A_signed / B_signed; // DIV
            5'b00111: ALU_out = (B_unsigned == 0) ? 32'hFFFFFFFF : A_unsigned / B_unsigned; // DIVU
            5'b01000: ALU_out = (B_signed == 0) ? 32'hFFFFFFFF : A_signed % B_signed; // REM
            5'b01001: ALU_out = (B_unsigned == 0) ? 32'hFFFFFFFF : A_unsigned % B_unsigned; // REMU
            5'b01010: ALU_out = ALU_ina ^ ALU_inb;                      // XOR
            5'b01011: ALU_out = ALU_ina | ALU_inb;                      // OR
            5'b01100: ALU_out = ALU_ina & ALU_inb;                      // AND
            5'b01101: ALU_out = ALU_ina << ALU_inb[4:0];                // SLL
            5'b01110: ALU_out = ALU_ina >> ALU_inb[4:0];                // SRL
            5'b01111: ALU_out = A_signed >>> ALU_inb[4:0];              // SRA
            5'b10000: ALU_out = (A_signed < B_signed) ? 32'b1 : 32'b0;  // SLT
            5'b10001: ALU_out = (A_unsigned < B_unsigned) ? 32'b1 : 32'b0; // SLTU
            5'b10010: ALU_out = (ALU_ina == ALU_inb) ? 32'b1 : 32'b0;   // SEQ
            5'b10011: ALU_out = (ALU_ina != ALU_inb) ? 32'b1 : 32'b0;   // SNE
            default:  ALU_out = 32'b0;
        endcase
    end

    // Flags
    assign Zero_flag     = (ALU_out == 32'b0);
    assign Negative_flag = ALU_out[31];
    assign Carry_flag    = (ALU_ctrl == 5'b00000 || ALU_ctrl == 5'b00001) ?
                           (ALU_ina > 32'hFFFFFFFF - ALU_inb) : 1'b0;
    assign Overflow_flag = (ALU_ctrl == 5'b00000 || ALU_ctrl == 5'b00001) ?
                            ((ALU_ina[31] == ALU_inb[31]) && (ALU_out[31] != ALU_ina[31])) : 1'b0;

endmodule
