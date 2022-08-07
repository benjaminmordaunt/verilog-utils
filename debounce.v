`default_nettype none

// -------------------------------------------
// Module: debounce.v
//
// Author: Benjamin Mordaunt
//
// Description:
//   Debounces a synchronous input, i_in.
//   A larger MAX_COUNT strengthens the debounce
//   at the cost of latency. A faster clock
//   may necessitate a greater MAX_COUNT.
//  
//   NOTE: Use a sync module to synchronise
//         an external async input, such as a 
//         button press. Length of sync buffer
//         adds latency to debounce.
// -------------------------------------------

module debounce
#(
	parameter MAX_COUNT = 16
)
(
	input wire clock,
	input wire i_nrst,
	input wire i_in,
	output reg o_out,
);

	localparam COUNTER_BITS = $clog2(MAX_COUNT);

	reg [COUNTER_BITS - 1 : 0] counter;

	initial
	begin
		counter = 0;
		out = 0;
	end

	always @(posedge clock or negedge i_nrst)
	begin
		counter <= 0;
		if (!i_nrst)
		begin
			counter <= 0;
			out <= 0;
		end
		else if (counter == MAX_COUNT - 1) 
		begin
			out <= in;
		end
		else if (in != out)
		begin
			counter <= counter + 1;
		end
	end

endmodule

