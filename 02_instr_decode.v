 /*For the ID stage design, you are expected to:
 • Instruction Decoding: You need to determine how the instruction decoder identifies the type of instruction it
 receives. Each instruction type has a specific format and opcode that you can use for this purpose.
 • Sign Extension of Immediate Values: Ensure that the immediate values extracted from the instruction are
 correctly sign-extended. This is crucial for proper operation in subsequent stages of instruction execution.

 Important Considerations:
 • Review the instruction format to identify the fields such as opcode, funct3, funct7, rs1, rs2, and rd, which are
 necessary for decoding.
 • Implement logic to handle different instruction types, including R-type, I-type, S-type, B-type, U-type, and
 J-type instructions. Note that the type of instruction can be identified by the opcode within the 32-bit
 instruction.
 • Pay attention to how immediate values are represented in the instruction and how they should be extended to
 32 bits while preserving their sign. For U-type and J-type, the lower bits are set to 0. For slli, srli, and srai,
 the higher immediate bits are set to a preset value. You need to use only the select bits for these instructions.*/



 //declaration

 /*
 opcode and instr type

 R-type: 
 opcode = 0110011

 I-type:
 opcode = 0010011
 opcode = 0000011
 opcode = 1100111

 S-type:
 opcode = 0100011

 B-type:
 opcode = 1100011

 U-type:
 opcode = 0110111
 opcode = 0010111

 J-type:
 opcode = 1101111
*/

/*
NOTES

1. The ALU control signal is derived from the funct3 and funct7 fields of the instruction.
2. The control signal is derived from the opcode field of the instruction.
3. The immediate value is extracted from the instruction based on the type of instruction and sign-extended as needed.
4. The src_reg_addr0, src_reg_addr1, and dst_reg_addr are derived from the instruction fields based on the type of instruction.
5. The immediate value for U-type and J-type instructions is set to 0 for the lower bits, and for slli, srli, and srai, the higher immediate bits are set to a preset value.
*/


module riscv_Inst_Decode(
    input clk,
    input reset,

    input [31:0] Instr, // Instruction input

    output reg [4:0] src_reg_addr0, // Source register address 0
    output reg [4:0] src_reg_addr1, // Source register address 1
    output reg [4:0] dst_reg_addr,  // Destination register address

    output reg [3:0] ALU_control,   // ALU control signal
    output reg [3:0] control_signal, // Control signal for instruction type

    output reg [31:0] immediate_value // Sign-extended immediate value
);

// Implementation of the instruction decoder
always @(posedge clk or posedge reset) begin
    if (reset) begin
        // Reset all outputs
        src_reg_addr0   <= 5'b0;
        src_reg_addr1   <= 5'b0;
        dst_reg_addr    <= 5'b0;
        ALU_control     <= 4'b0;
        control_signal  <= 4'b0;
        immediate_value <= 32'b0;
    end else begin
        // Decode the instruction based on opcode
        case (Instr[6:0]) // opcode field
            //-----------------------------//
            // R-type instruction
            // Funct7 | rs2 | rs1 | funct3 | rd | opcode
            //-----------------------------//
            7'b0110011: begin // R-type
                src_reg_addr0   <= Instr[19:15];  // rs1
                src_reg_addr1   <= Instr[24:20];  // rs2
                dst_reg_addr    <= Instr[11:7];   // rd
                ALU_control     <= {Instr[30], Instr[14:12]}; // funct7 + funct3
                control_signal  <= 4'b0001;  // Example control signal for R-type
                immediate_value <= 32'b0;    // No immediate value for R-type
            end

            //-----------------------------//
            // I-type instructions
            // imm[11:0] | rs1 | funct3 | rd | opcode
            //-----------------------------//
            7'b0010011: begin // I-type (Immediate)
                src_reg_addr0   <= Instr[19:15];  // rs1
                dst_reg_addr    <= Instr[11:7];   // rd
                ALU_control     <= {1'b0, Instr[14:12]}; // funct3 with preset value for slli, srli, srai
                control_signal  <= 4'b0010;  // Example control signal for I-type
                immediate_value <= {{20{Instr[31]}}, Instr[31:20]}; // Sign-extend immediate value
            end

            7'b0000011: begin // I-type (Load)
                src_reg_addr0   <= Instr[19:15];  // rs1
                dst_reg_addr    <= Instr[11:7];   // rd
                ALU_control     <= 4'b0011;  // Example ALU control for load
                control_signal  <= 4'b0100;  // Example control signal for load
                immediate_value <= {{20{Instr[31]}}, Instr[31:20]}; // Sign-extend immediate value
            end

            7'b1100111: begin // I-type (Jump and Link)
                src_reg_addr0   <= Instr[19:15];  // rs1
                dst_reg_addr    <= Instr[11:7];   // rd
                ALU_control     <= 4'b0100;  // Example ALU control for jump
                control_signal  <= 4'b1000;  // Example control signal for jump
                immediate_value <= {{20{Instr[31]}}, Instr[31:20]}; // Sign-extend immediate value
            end
            //-----------------------------//
            // S-type instruction
            // imm[11:5] | rs2 | rs1 | funct3 | imm[4:0] | opcode
            //-----------------------------//
            7'b0100011: begin // S-type (Store)
                src_reg_addr0   <= Instr[19:15];  // rs1
                src_reg_addr1   <= Instr[24:20];  // rs2
                immediate_value <= {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; // Sign-extend immediate value
                control_signal  <= 4'b0101;  // Example control signal for store
                ALU_control     <= 4'b0110;  // Example ALU control for store
                dst_reg_addr    <= 5'b0;     // No destination register for store
            end

            //-----------------------------//
            // B-type instruction
            // imm[12|10:5] | rs2 | rs1 | funct3 | imm[4:1|11] | opcode
            //-----------------------------//
            7'b1100011: begin // B-type (Branch)
                src_reg_addr0   <= Instr[19:15];  // rs1
                src_reg_addr1   <= Instr[24:20];  // rs2
                immediate_value <= {{20{Instr[31]}}, Instr[31:25], Instr[11:7]}; // Sign-extend immediate value
                control_signal  <= 4'b0111;  // Example control signal for branch
                ALU_control     <= 4'b1000;  // Example ALU control for branch
                dst_reg_addr    <= 5'b0;     // No destination register for branch
            end

            //-----------------------------//
            // U-type instruction
            // imm[31:12] | rd | opcode
            //-----------------------------//
            7'b0110111: begin // U-type (Upper Immediate)
                dst_reg_addr    <= Instr[11:7];   // rd
                immediate_value <= {Instr[31:12], 12'b0}; // Sign-extend immediate value with lower bits set to 0
                control_signal  <= 4'b1001;  // Example control signal for upper immediate
                ALU_control     <= 4'b1010;  // Example ALU control for upper immediate
                src_reg_addr0   <= 5'b0;     // No source register for upper immediate
                src_reg_addr1   <= 5'b0;     // No source register for upper immediate
            end

            7'b0010111: begin // U-type (Add Upper Immediate)
                dst_reg_addr    <= Instr[11:7];   // rd
                immediate_value <= {Instr[31:12], 12'b0}; // Sign-extend immediate value with lower bits set to 0
                control_signal  <= 4'b1011;  // Example control signal for add upper immediate
                ALU_control     <= 4'b1100;  // Example ALU control for add upper immediate
                src_reg_addr0   <= 5'b0;     // No source register for add upper immediate
                src_reg_addr1   <= 5'b0;     // No source register for add upper immediate
            end

            //-----------------------------//
            // J-type instruction
            // imm[20|10:1|11|19:12] | rd | opcode
            //-----------------------------//
            7'b1101111: begin // J-type (Jump)
                dst_reg_addr    <= Instr[11:7];   // rd
                immediate_value <= {{12{Instr[31]}}, Instr[31:12]}; // Sign-extend immediate value with lower bits set to 0
                control_signal  <= 4'b1101;  // Example control signal for jump
                ALU_control     <= 4'b1110;  // Example ALU control for jump
                src_reg_addr0   <= 5'b0;     // No source register for jump
                src_reg_addr1   <= 5'b0;     // No source register for jump
            end

            default: begin
                // Default case for unsupported opcodes
                src_reg_addr0   <= 5'b0;
                src_reg_addr1   <= 5'b0;
                dst_reg_addr    <= 5'b0;
                ALU_control     <= 4'b0;
                control_signal  <= 4'b0;
                immediate_value <= 32'b0;
            end
        endcase
    end
end
endmodule
