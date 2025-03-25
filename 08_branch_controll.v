/*
The design of the branch operation requires the next PC to be determined by the flags from the ALU result. To
 find the appropriate way to obtain the comparison results for the six branch operations, a straightforward approach
 is to refer to how the ARM Cortex-M4F defines its conditional operations. This reference should help you identify
 the correct implementation.
 Note that the branch decision is determined after the execution of the ALU, so you need to ensure that the branch
 control signal is properly connected to the MUX before the PC adder, which calculates the current PC with the
 immediate value from the branch instruction.
 As a side note, the figure shown above only considers the zero flag for convenience; however, you may need other
 flags to assist with the comparison and branching process.
 */

 module branch_control(
        input wire clk,
        input wire reset,
        
        input wire [31:0] offset,
        input wire [31:0] PC,
        input wire zero,
        
        output wire target
    );

    funct3
    opcode
    
        
        