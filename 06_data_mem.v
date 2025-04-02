module mem_data #(
    parameter DATA_WIDTH = 32,
    parameter ADDR_WIDTH = 32,
    parameter MEM_DEPTH_WORDS = 1024
)(
    input clk,
    input reset,
    input wr_en,
    input [ADDR_WIDTH-1:0] addr,
    input [DATA_WIDTH-1:0] din,
    output reg [DATA_WIDTH-1:0] dout
);

    reg [DATA_WIDTH-1:0] memory [256:511];
    wire [9:0] word_addr = addr[11:2];

    // Write or reset
    integer i;
    always @(posedge clk or posedge reset) begin
        if (reset) begin
            
            for (i = 256; i <= 511; i = i + 1)
                memory[i] <= 0;
        end else if (wr_en && word_addr >= 256 && word_addr <= 511) begin
            memory[word_addr] <= din;
        end
    end

    // Read
    always @(posedge clk) begin
        if (~wr_en && word_addr >= 256 && word_addr <= 511)
            dout <= memory[word_addr];
        else
            dout <= 0;
    end

    // Dump memory to file at end of sim (simulate 1000ns before this runs)
    initial begin
        #1000; // delay to wait for execution (adjust if needed)
        $writememh("data_mem_dump.txt", memory, 256, 511);
    end

endmodule
