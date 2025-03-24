/*
HDL design 4 Instruction Memory File (IF stage)
 At this stage, the instructions used by the processor are temporarily stored in a register array called instru_mem.
 This module acts as a placeholder for instruction memory and allows the processor to fetch and execute instructions
 during operation. You should ensure that the content within the instruction memory is changeable for different
 instructions during this stage. As shown in the lab portion, I used a .txt file to store all the instructions, allowing
 for easy editing of that file. You can also explore other methods that work for you.
 The reason for this approach is that if you attempt to reconfigure the instruction memory at this stage using a
 testbench, you will need to manage too many details, which could complicate the process unnecessarily
*/
/*
00000000  12345678
00000004  ABCDEF01
....
*/
/*
The address 0x00000000 corresponds to index 0 in the memory array (instr_mem[0]).
The address 0x00000004 corresponds to index 1 in the memory array (instr_mem[1]), and so on.
*/

module instr_mem(
    input wire clk, // Clock signal
    input wire reset, // Reset signal
    input wire [31:0] addr, // Address input
    output reg [31:0] instr // Instruction output
);

    // Declare the instruction memory array with 1024 32-bit instructions
    reg [31:0] instr_mem [0:1023];

    // Read instructions from the file and store them in the instruction memory
    initial begin
        $readmemh("instr_mem.txt", instr_mem);
    end

    // Assign the instruction output based on the address input
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            instr <= 32'h0;
        end else begin
            instr <= instr_mem[addr];
        end
    end