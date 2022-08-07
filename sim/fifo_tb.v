`timescale 1ns / 1ps

// -------------------------------------------
// Testbench: fifo_tb.v
//
// Author: Benjamin Mordaunt
//
// Description:
//   Test a 4-deep FIFO.
// -------------------------------------------

module fifo_tb;
    
reg clk, nreset;

// Read port
reg read_ready;
wire read_valid;
wire [7:0] read_data;

// Write port
wire write_ready;
reg write_valid;
reg [7:0] write_data;

fifo dut (
    .i_clock(clk),
    .i_nreset(nreset),
    .i_read_ready(read_ready),
    .o_read_valid(read_valid),
    .o_read_data(read_data),
    .o_write_ready(write_ready),
    .i_write_valid(write_valid),
    .i_write_data(write_data)
);

always
begin
    clk = 1'b1;
    #1;
    
    clk = 1'b0;
    #1;
end

integer fifo_cyl;
initial
begin
    read_ready = 0;
    write_valid = 0;
    write_data = 8'b0;

    $display("Entering reset...");
    nreset = 0;
    #2;
    nreset = 1;
    #2;
    
    $display("Placing '12' on write_data...");
    write_data = 8'd12;
    #2;
    
    $display("Setting write_valid...");
    write_valid = 1;
    
    // Wait 4 clock cycles (depth of FIFO)
    for (fifo_cyl = 0; fifo_cyl < 5; fifo_cyl = fifo_cyl + 1) begin
        #2;
        $display("Cycle %d: RValid: %b, RData: %b", fifo_cyl, read_valid, read_data);
    end
end

endmodule
