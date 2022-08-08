`default_nettype none

// -------------------------------------------
// Module: sync.v
//
// Author: Benjamin Mordaunt
//
// Description:
//   Synchronises an asyncronous input against
//   a clock. sync_buffer acts as a FIFO.
//   Longer FIFOs are more tolerant to crossing
//   timing domains.
// -------------------------------------------

module sync
#(
	parameter SYNC_BUF_LEN = 3
)
(
	input wire clock,
	input wire i_nrst,
	input wire i_async,
	output wire o_sync
);
	localparam SYNC_MSB = SYNC_BUF_LEN - 1;

	reg [SYNC_MSB : 0] sync_buffer;

	assign out = sync_buffer[SYNC_MSB];

	always @(posedge clock)
	begin
		sync_buffer[SYNC_MSB : 0] <= {sync_buffer[SYNC_MSB - 1 : 0], in};
	end
endmodule
