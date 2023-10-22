
/*	R/W Buffer to store arbitrary data.  Parameterized by parameters that configure
	the amount of elements to store in the buffer, input write buffer sizes, and size
	of elements to store in the buffer

	This is a two port buffer.
*/
module CommandBuffer #(
		parameter MAX_PAYLD_PKT_BITS,	// Input packet number of bits to store
		parameter BUFFER_PKT_BITS,		// Number of bits used for each element of the buffer
		parameter NUM_SYM_SUPPTD		// Number of bits req'd to store the elements of the buffer
	) (
		input logic i_clk,
		input logic n_btn_rst,
		input logic we,										// Write enable
		/* verilator lint_off UNUSED */
		input logic [MAX_PAYLD_PKT_BITS-1:0] wdata,			// Write Data.  0th byte is write address
		input logic re,										// Read enable
		input logic [NUM_SYM_SUPPTD-1:0] raddr,		// Read address
		output logic [BUFFER_PKT_BITS-1:0] rdata,			// Outputted data requested by read port
		output logic [NUM_SYM_SUPPTD-1:0] valid_idx	// Indicates whether the index has data previously written to it
	);

	// Symbol ID is the write address of the message.  All messages have the symbol ID in the 0th byte
	/* verilator lint_off UNUSED */
	wire logic [(NUM_SYM_SUPPTD-1):0] sym_id;
	assign sym_id = wdata[(NUM_SYM_SUPPTD-1):0];

	// Buffer used to write/read to/from
	logic [(BUFFER_PKT_BITS-1):0] cmd_buffer [0:NUM_SYM_SUPPTD];

	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin

			// Invalidate all elements of the buffer
			valid_idx <= {(NUM_SYM_SUPPTD){1'd0}};

		end else begin
			if (we) begin
				// Store the incoming data at the specified position, except the symbol ID
				cmd_buffer[sym_id] <= wdata[BUFFER_PKT_BITS+7:8];
				// Assign symbol attribute data (not symbol ID) to the program attribute buffer at the index of the symbol ID
				valid_idx <= valid_idx | sym_id;
			end
			if (re) begin
				rdata <= cmd_buffer[raddr];
			end
		end
	end
	

endmodule
