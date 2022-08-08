`default_nettype none

// -----------------------------------------------
// Module: crc16ccitt.v
//
// Author: Benjamin Mordaunt
//
// Description:
// 	Computes the CRC-16-CCITT of a data-word.
// 	The polynomial generator is g(x) = x16+x12+x5+1
// 	Uses a ready/valid read/write interface.
//------------------------------------------------

module crc16ccitt
(
	input wire i_clock,
	input wire i_nreset,
	input wire i_start,
	input wire i_data,
	output wire o_valid,
	output reg [15 : 0] o_r
);

localparam idle = 0;
localparam active = 1;

reg state;
reg [5 : 0] count;

always @(posedge i_clock or negedge i_nreset) begin
	if (!i_nreset) begin
		o_r <= 16'hFFFF;
		state <= idle;
		count <= 47;
	end

	case (state)
		idle: begin
			state <= (i_start) ? active : idle;
			o_r <= 16'hFFFF;
			count <= 47;
		end

		active: begin
			o_r[15 : 13] <= o_r[14 : 12];
			o_r[12] <= o_r[11] + o_r[15] + i_data;
			o_r[11 : 6] <= o_r[10 : 5];
			o_r[5] <= o_r[4] + o_r[15] + i_data;
			o_r[4 : 1] <= o_r[3 : 0];
			o_r[0] <= o_r[15] + i_data;
			count <= count - 1;
			state <= (count == 1) ? idle : active;
		end
	endcase
end

assign o_valid = (count == 0);

endmodule
