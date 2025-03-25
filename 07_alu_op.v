/*
For each Opcode listed on the green card, you need to first identify the ALU operation based on the values of
 Opcode, funct3, and funct7. Additionally, ensure that for I-type instructions, the ALU accesses the extended
 immediate value rather than the data from the general-purpose registers. For B-type instructions, which implicitly
 include subtraction, you need to configure these instructions to perform subtraction. For I-type load instructions
 and S-type store instructions, the ALU should be configured for addition, and similarly for the case of JALR.
 You also need to identify the control signals: Branch, MemRead, MemtoReg, ALUOP, MemWrite, ALUSrc, and
 RegWrite. Note that some of these signals can be merged with the ID module, while others still need to be connected 
 to the top-level processor.
*/
module alu_op #(
    parameter INSTR_WIDTH = 32,      // Instruction width (default 32 bits)
    parameter ALUCONTROL_WIDTH = 4,  // ALU Control signal width (default 4 bits)
    parameter ADD_OPCODE = 7'b0110011,   // R-type ADD opcode
    parameter SUB_OPCODE = 7'b0110011    // R-type SUB opcode
)(
    input wire clk,                    // Clock signal
    input wire reset,                  // Reset signal
    input wire [1:0] ALUOp,            // ALU operation type (e.g., add, subtract, etc.)
    input wire [INSTR_WIDTH-1:0] instr, // Instruction being executed (32-bit by default)
    output reg [ALUCONTROL_WIDTH-1:0] ALUControl  // ALU control output (4-bit by default)
);

    // Extract instruction fields
    wire [6:0] opcode = instr[6:0];        // 7-bit opcode (bits 6:0)
    wire [2:0] funct3 = instr[14:12];      // 3-bit funct3 (bits 14:12)
    wire [6:0] funct7 = instr[31:25];      // 7-bit funct7 (bits 31:25)

    // Sequential logic to determine ALU control on rising edge of clk
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            ALUControl <= {ALUCONTROL_WIDTH{1'b0}}; // Reset ALU control to 0
        end else begin
            // Default ALU operation (NOP)
            ALUControl <= {ALUCONTROL_WIDTH{1'b0}};
            
            // Decode R-type instructions
            case (opcode)
                ADD_OPCODE: begin // R-type instructions (ADD/SUB)
                    case (funct3)
                        3'b000: begin // ADD/SUB operation
                            if (funct7 == 7'b0000000) begin
                                ALUControl <= 4'b0010;  // ADD
                            end else if (funct7 == 7'b0100000) begin
                                ALUControl <= 4'b0110;  // SUB
                            end
                        end
                        3'b001: begin // SLL (Shift Left Logical)
                            ALUControl <= 4'b0100;  // SLL
                        end
                        3'b010: begin // SLT (Set Less Than)
                            ALUControl <= 4'b1000;  // SLT
                        end
                        3'b011: begin // SLTU (Set Less Than Unsigned)
                            ALUControl <= 4'b1001;  // SLTU
                        end
                        3'b100: begin // XOR (Exclusive OR)
                            ALUControl <= 4'b0111;  // XOR
                        end
                        3'b101: begin // SRL/SRA (Shift Right Logical/Arithmetic)
                            if (funct7 == 7'b0000000) begin
                                ALUControl <= 4'b0101;  // SRL
                            end else if (funct7 == 7'b0100000) begin
                                ALUControl <= 4'b0111;  // SRA (Arithmetic Shift Right)
                            end
                        end
                        3'b110: begin // OR (Logical OR)
                            ALUControl <= 4'b0100;  // OR
                        end
                        3'b111: begin // AND (Logical AND)
                            ALUControl <= 4'b0001;  // AND
                        end
                        default: ALUControl <= 4'b0000; // Default NOP if invalid funct3
                    endcase
                end
                SUB_OPCODE: begin // SUB operation (R-type)
                    ALUControl <= 4'b0110;  // SUB
                end
                default: begin
                    ALUControl <= 4'b0000;  // Default NOP operation
                end
            endcase
        end
    end
endmodule

    
/*
NOTES

based on AluOP and instr(30), instr(14:12) the ALU Operation is decided
*/

                