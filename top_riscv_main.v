// top_single_cycle_riscv.v

// This top-level module instantiates all design components from Lab03 directory.
// Includes: ALU, Decode, PC logic, Instruction Memory, Data Memory, Control Blocks

module top_single_cycle_riscv(
    input wire clk,
    input wire reset
);

    // Wires between modules
    wire [31:0] PC, PCTarget;
    wire [31:0] Instr;

    wire [4:0] rs1, rs2, rd;
    wire [31:0] imm;
    wire [31:0] RD1, RD2;
    wire [31:0] ALU_result;

    wire [4:0] ALU_ctrl;
    wire [1:0] ALUOp;

    wire MemRead, MemWrite, RegWrite, ALUSrc, Branch, MemtoReg;

    wire [31:0] DataMemOut;
    
    
 
    
    wire Zero;

    // PC logic driven by branch_control's target output
    reg [31:0] PC_reg;
    assign PC = PC_reg;

    always @(posedge clk or posedge reset) begin
        if (reset)
            PC_reg <= 32'b0;
        else
            PC_reg <= PCTarget;
    end

    // Instruction Memory (04_instr_mem.v)
    instr_mem Instruction_Memory (
        .clk(clk),
        .reset(reset),
        .addr(PC),
        .instr(Instr)
    );

    // Instruction Decode (02_instr_decode.v)
    riscv_Inst_Decode ID (
        .clk(clk),
        .reset(reset),
        .Instr(Instr),
        .src_reg_addr0(rs1),
        .src_reg_addr1(rs2),
        .dst_reg_addr(rd),
        .immediate_value(imm),
        .MemWrite(MemWrite),
        .MemRead(MemRead),
        .ALUSrc(ALUSrc),
        .RegWrite(RegWrite),
        .Branch(Branch),
        .MemtoReg(MemtoReg),
        .ALUOp(ALUOp)
    );

    // Register File (05_register_file.v)
    register_file RF (
        .clk(clk),
        .rst(reset),
        .WE3(RegWrite),
        .WD3(MemtoReg ? DataMemOut : ALU_result),
        .A1(rs1),
        .A2(rs2),
        .A3(rd),
        .RD1(RD1),
        .RD2(RD2)
    );

    // ALU Control (07_alu_op.v)
    alu_control ALU_Control_Block (
        .clk(clk),
        .reset(reset),
        .ALUOp(ALUOp),
        .instr(Instr),
        .ALUControl(ALU_ctrl)
    );

    // ALU (01_riscv_ALU.v)
    riscv_ALU ALU (
        .clk(clk),
        .reset(reset),
        .ALU_ctrl(ALU_ctrl),
        .ALU_ina(RD1),
        .ALU_inb_reg(RD2),
        .ALU_inb_imm(imm),
        .ALUSrc(ALUSrc),
        .ALU_out(ALU_result),
        .Zero_flag(Zero),
        .Negative_flag(),
        .Carry_flag(),
        .Overflow_flag()
    );

    // Data Memory (06_data_mem.v)
    mem_data DataMem (
        .clk(clk),
        .reset(reset),
        .wr_en(MemWrite),
        .addr(ALU_result),
        .din(RD2),
        .dout(DataMemOut)
    );

    // Branch Control (08_branch_control.v)
    branch_control BranchUnit (
        .clk(clk),
        .reset(reset),
        .offset(imm),
        .PC(PC),
        .zero(Zero),
        .branch(Branch),
        .target(PCTarget)
    );

endmodule
