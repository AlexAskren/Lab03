//test bench for riscv_Inst_Decode module

/*
module riscv_Inst_Decode(
    input clk,
    input reset,

    input [31:0] Instr, // Instruction input

    output reg [4:0] src_reg_addr0, // Source register address 0
    output reg [4:0] src_reg_addr1, // Source register address 1
    output reg [4:0] dst_reg_addr, // Destination register address

    output reg [3:0] ALU_control, // ALU control signal
    output reg [3:0] control_signal, // Control signal for instruction type

    output reg [31:0] immediate_value // Sign-extended immediate value
);
*/ 

module riscv_Inst_Decode_tb;

    reg clk;
    reg reset;
    reg [31:0] Instr;

    wire [4:0] src_reg_addr0;
    wire [4:0] src_reg_addr1;
    wire [4:0] dst_reg_addr;
    wire [3:0] ALU_control;
    wire [3:0] control_signal;
    wire [31:0] immediate_value;

    // Instantiate the riscv_Inst_Decode module
    riscv_Inst_Decode uut (
        .clk(clk),
        .reset(reset),
        .Instr(Instr),
        .src_reg_addr0(src_reg_addr0),
        .src_reg_addr1(src_reg_addr1),
        .dst_reg_addr(dst_reg_addr),
        .ALU_control(ALU_control),
        .control_signal(control_signal),
        .immediate_value(immediate_value)
    );

    // Clock generation
    initial begin
        clk = 0;
        forever #5 clk = ~clk; // Toggle clock every 5 time units
    end

    // Test sequence
    initial begin
        // Initialize inputs
        reset = 1;
        Instr = 32'b0;

        // Release reset after a short period
        #10 reset = 0;

        // Test instructions
        // Test R-type instruction (e.g., ADD)
        #10 Instr = 32'b00000000000100000000000000100011; // ADD x1, x2, x3
        #10 display_values("ADD");

        // Test I-type instruction (e.g., ADDI)
        #10 Instr = 32'b00000000000100000000000000100111; // ADDI x1, x2, 1
        #10 display_values("ADDI");

        // Test Load instruction (e.g., LW)
        #10 Instr = 32'b00000000000100000000000000101011; // LW x1, 1(x2)
        #10 display_values("LW");

        // Test Store instruction (e.g., SW)
        #10 Instr = 32'b00000000000100000000000000101111; // SW x1, 1(x2)
        #10 display_values("SW");

        // Test Branch instruction (e.g., BEQ)
        #10 Instr = 32'b00000000000100000000000000110011; // BEQ x1, x2, label
        #10 display_values("BEQ");

        // Test AUIPC instruction
        #10 Instr = 32'b00000000000100000000000000110111; // AUIPC x1, offset
        #10 display_values("AUIPC");

        // Test LUI instruction
        #10 Instr = 32'b00000000000100000000000000111011; // LUI x1, immediate
        #10 display_values("LUI");

        // Test JAL instruction
        #10 Instr = 32'b00000000000100000000000000111111; // JAL x1, offset
        #10 display_values("JAL");

        // Test JALR instruction
        #10 Instr = 32'b00000000000100000000000001000011; // JALR x1, offset(x2)
        #10 display_values("JALR");

        // Test SRLI instruction
        #10 Instr = 32'b00000000000100000000000001000111; // SRLI x1, x2, 1
        #10 display_values("SRLI");

        // Test SLLI instruction
        #10 Instr = 32'b00000000000100000000000001001011; // SLLI x1, x2, 1
        #10 display_values("SLLI");

        // Test SRAI instruction
        #10 Instr = 32'b00000000000100000000000001001111; // SRAI x1, x2, 1
        #10 display_values("SRAI");

        // Test SRL instruction
        #10 Instr = 32'b00000000000100000000000001010011; // SRL x1, x2, x3
        #10 display_values("SRL");

        // Test SLL instruction
        #10 Instr = 32'b00000000000100000000000001010111; // SLL x1, x2, x3
        #10 display_values("SLL");

        // Test SRA instruction
        #10 Instr = 32'b00000000000100000000000001011011; // SRA x1, x2, x3
        #10 display_values("SRA");

        // Test XOR instruction
        #10 Instr = 32'b00000000000100000000000001011111; // XOR x1, x2, x3
        #10 display_values("XOR");

                // Test OR instruction
        #10 Instr = 32'b00000000000100000000000001100011; // OR x1, x2, x3
        #10 display_values("OR");

        // Test AND instruction
        #10 Instr = 32'b00000000000100000000000001100111; // AND x1, x2, x3
        #10 display_values("AND");

        // Test SUB instruction
        #10 Instr = 32'b00000000000100000000000001101011; // SUB x1, x2, x3
        #10 display_values("SUB");

        // Test SLLI instruction
        #10 Instr = 32'b00000000000100000000000001101111; // SLLI x1, x2, 1
        #10 display_values("SLLI");

        // Test SRLI instruction
        #10 Instr = 32'b00000000000100000000000001110011; // SRLI x1, x2, 1
        #10 display_values("SRLI");

        // Test SRAI instruction
        #10 Instr = 32'b00000000000100000000000001110111; // SRAI x1, x2, 1
        #10 display_values("SRAI");

        // Test JALR instruction
        #10 Instr = 32'b00000000000100000000000001111011; // JALR x1, offset(x2)
        #10 display_values("JALR");

        // Test JAL instruction
        #10 Instr = 32'b00000000000100000000000001111111; // JAL x1, offset
        #10 display_values("JAL");

        // Test BEQ instruction
        #10 Instr = 32'b00000000000100000000000010000011; // BEQ x1, x2, label
        #10 display_values("BEQ");

        // Test BNE instruction
        #10 Instr = 32'b00000000000100000000000010000111; // BNE x1, x2, label
        #10 display_values("BNE");

        // End simulation
        #10 $finish;
    end

    // Task to display the instruction and its decoded values
    task display_values(input [31:0] inst_name);
        begin
            $display("Instruction: %s", inst_name);
            $display("Instr: %b", Instr);
            $display("src_reg_addr0: %b, src_reg_addr1: %b, dst_reg_addr: %b", 
                     src_reg_addr0, src_reg_addr1, dst_reg_addr);
            $display("ALU_control: %b, control_signal: %b", ALU_control, control_signal);
            $display("Immediate value: %b\n", immediate_value);
        end
    endtask

endmodule

