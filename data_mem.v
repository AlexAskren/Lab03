module mem_ram (
    input clk,             // Clock signal
    input reset,           // Reset signal
    input wr_en,           // Write enable signal
    input [31:0] addr,     // Address for the memory access
    input [31:0] din,      // Data to be written (if wr_en is asserted)
    output reg [31:0] dout // Data read from memory (if wr_en is not asserted)
);
    // Define a 1024-byte memory (256 words of 32-bit data)
    reg [31:0] memory [1023:0];  // Memory size from 1024 to 2047 (256 words)
    
    // Initialize the memory to zero during reset
    integer i;
    always @(*) begin
        if (reset) begin
            // Reset memory contents to 0
            for (i = 0; i < 1024; i = i + 1) begin
                memory[i] <= 32'b0;
            end
        end else if (wr_en) begin
            // Write operation (store data)
            memory[addr[11:2]] <= din;  // Use address to index into memory (aligned by 4 bytes)
        end else begin
            // Read operation (load data)
            dout <= memory[addr[11:2]];  // Address is word-aligned (assuming 4-byte word)
        end
    end
endmodule
