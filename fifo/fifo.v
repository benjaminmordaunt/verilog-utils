`default_nettype none

// -------------------------------------------
// Module: fifo.v
//
// Author: Benjamin Mordaunt
//
// Description:
//   A FIFO of variable depth and width.
// -------------------------------------------

module fifo
#(
	parameter FIFO_REG_WIDTH = 8,
	parameter FIFO_DEPTH = 4
)
(
	input wire i_clock,
	input wire i_nreset,
	
	// Read port
	input  wire                          i_read_ready,
	output wire                          o_read_valid,
	output wire [FIFO_REG_WIDTH - 1 : 0] o_read_data,

	// Write port
	output wire                          o_write_ready,
	input wire                           i_write_valid,
	input wire  [FIFO_REG_WIDTH - 1 : 0] i_write_data
);
	// ---------------------------------------------------
	// Routing resource between generated fifo registers
	// ---------------------------------------------------
	wire ready_route [FIFO_DEPTH : 0];
	wire valid_route [FIFO_DEPTH : 0];
	wire [FIFO_REG_WIDTH - 1 : 0] data_route [FIFO_DEPTH : 0];

	// -------------------------------
	// Generate inner FIFO registers
	// -------------------------------
	genvar fifo_reg_n;
	generate
		for (fifo_reg_n = 0; fifo_reg_n < FIFO_DEPTH; fifo_reg_n = fifo_reg_n + 1) begin
			fifo_reg #(.FIFO_REG_WIDTH(FIFO_REG_WIDTH)) inner_reg (
				.i_clock(i_clock),
				.i_nreset(i_nreset),
				.i_read_ready(ready_route[fifo_reg_n]),
				.o_read_valid(valid_route[fifo_reg_n]),
				.o_read_data(data_route[fifo_reg_n]),
				.o_write_ready(ready_route[fifo_reg_n + 1]),
				.i_write_valid(valid_route[fifo_reg_n + 1]),
				.i_write_data(data_route[fifo_reg_n + 1])
			);
		end
	endgenerate

	// Read port
	assign ready_route[0]          = i_read_ready;
	assign o_read_valid            = valid_route[0];
	assign o_read_data             = data_route[0];

	// Write port
	assign o_write_ready           = ready_route[FIFO_DEPTH];
	assign valid_route[FIFO_DEPTH] = i_write_valid;
	assign data_route[FIFO_DEPTH]  = i_write_data;
endmodule
