`timescale 1ns / 1ps

// -------------------------------------------
// Testbench: fifo_tb.v
//
// Author: Benjamin Mordaunt
//
// Description:
//   Test a 4-deep FIFO.
// -------------------------------------------

// -----------------------------------------------------
// Control FIFO depth and therefore number of iterations
// in test-bench
// -----------------------------------------------------
`define FIFO_TB_DEPTH 5

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

fifo #(
    .FIFO_DEPTH(`FIFO_TB_DEPTH)
) dut (
    .i_clock(clk),
    .i_nreset(nreset),
    .i_read_ready(read_ready),
    .o_read_valid(read_valid),
    .o_read_data(read_data),
    .o_write_ready(write_ready),
    .i_write_valid(write_valid),
    .i_write_data(write_data)
);

initial
begin
    clk = 0;
    #10 forever #10 clk = !clk;
end

integer fifo_cyl;
initial
begin
    read_ready = 0;
    write_valid = 0;
    write_data = 8'b0;

    nreset = 0;
    #10;
    nreset = 1;
    #20;
    
    write_data = 8'd12;
    #20;
    write_valid = 1;
    
    // Wait 4 clock cycles (depth of FIFO)
    for (fifo_cyl = 0; fifo_cyl < `FIFO_TB_DEPTH; fifo_cyl = fifo_cyl + 1) begin
        #20;
        $display("Cycle %d: RValid: %b, RData: %b", fifo_cyl, read_valid, read_data);
    end

    $stop;
end

// -----------------------------------------------------------------------------
// (SVA) Ensure that read_valid asserts FIFO_TB_DEPTH cycles after write_valid
// -----------------------------------------------------------------------------
assert property (@(posedge clk) write_valid |-> ##(`FIFO_TB_DEPTH) read_valid);

endmodule
