module instr_mem(
    input wire clk,
    input wire reset,
    input wire [31:0] addr, // Byte address
    output reg [31:0] instr
);

    // 1024 x 32-bit instruction memory (4KB)
    reg [31:0] instr_mem [0:1023];

    // Load instructions from file
    initial begin
        $readmemh("instruction_rom_single_dp.txt", instr_mem);
    end

    always @(posedge clk or posedge reset) begin
        if (reset)
            instr <= 32'h0;
        else
            instr <= instr_mem[addr]; // Use bits [11:2] to address 1024 words
    end
endmodule
