`default_nettype none

// -------------------------------------------
// Module: fifo_reg.v
//
// Author: Benjamin Mordaunt
//
// Description:
//   A single register within a FIFO.
// -------------------------------------------

module fifo_reg
#(
	parameter FIFO_REG_WIDTH = 3,
    parameter CLEAR_ON_EMPTY = 1
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
	reg                          valid;
    reg [FIFO_REG_WIDTH - 1 : 0] data;

    always @(posedge i_clock or negedge i_nreset)
    begin
        if (!i_nreset)
        begin
            valid <= 0;
            data <= {FIFO_REG_WIDTH{1'b0}};
        end
        else
        begin
            if (i_write_valid && ~valid)
            begin
                data <= i_write_data;
                valid <= 1;  // We now have valid data.
            end
            else if (i_read_ready && valid)
            begin
                valid <= 0;
                if (CLEAR_ON_EMPTY)
                    data <= {FIFO_REG_WIDTH{1'b0}};
            end
        end
    end

    assign o_read_valid  = valid;
    assign o_read_data   = data;
    assign o_write_ready = ~valid;

endmodule