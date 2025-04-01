// DATA MEMORY MODULE
// This module implements data memory with read and write capabilities.
module mem_data #(
    parameter MEM_SIZE_BOTTOM = 1024,       // Size of the memory in words (default: 1024)
    parameter MEM_SIZE_TOP = 1050,       // Size of the memory in words (default: 1024)   
    parameter DATA_WIDTH = 32,       // Width of the data in bits (default: 32 bits)
    parameter ADDR_WIDTH = 32        // Address width (default: 32 bits)
)(
    input clk,                      // Clock signal
    input reset,                    // Reset signal
    input wr_en,                    // Write enable signal
    input [ADDR_WIDTH-1:0] addr,    // Address for the memory access
    input [DATA_WIDTH-1:0] din,     // Data to be written (if wr_en is asserted)
    output reg [DATA_WIDTH-1:0] dout // Data read from memory (if wr_en is not asserted)
);
    //wire [ADDR_WIDTH-1:0] addr_offset;
    //assign addr_offset = addr - 1024;
    
    // Define a memory array of size MEM_SIZE, where each word is of DATA_WIDTH
    reg [DATA_WIDTH-1:0] memory [MEM_SIZE_BOTTOM:MEM_SIZE_TOP-1];  // Memory size based on MEM_SIZE parameter
    
    // Initialize the memory to zero during reset
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            // Reset memory contents to 0
            for (i = 0; i < MEM_SIZE_BOTTOM - MEM_SIZE_TOP; i = i + 1) begin
                memory[i] <= {DATA_WIDTH{1'b0}};  // Reset to 0 for the given data width
            end
        end else if (wr_en) begin
            // Write operation (store data) - triggered at the rising clock edge
            memory[addr[ADDR_WIDTH-1:2]] <= din;  // Use address to index into memory (aligned by 4 bytes)
        end
    end

    // Read operation (load data) - this occurs when wr_en is NOT asserted
    always @(posedge clk) begin
        if (~wr_en) begin
            if ((addr >= MEM_SIZE_BOTTOM) && (addr < MEM_SIZE_TOP-1) ) begin
                dout <= memory[addr[ADDR_WIDTH-1:2]];  // Read data from memory
            end else begin
                dout <= {DATA_WIDTH{1'b0}};  // Handle invalid address by returning 0
            end
        end
    end
endmodule

