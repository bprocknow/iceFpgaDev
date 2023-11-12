
/*	R/W Buffer to store arbitrary data.  Parameterized by parameters that configure
	the amount of elements to store in the buffer, input write buffer sizes, and size
	of elements to store in the buffer
*/
module CommandBuffer #(
		parameter BUFFER_PKT_BITS,		// Number of bits used for each element of the buffer
		parameter NUM_BUF_ELEMS_BITS	// Number of bits elements of the buffer
	) (
		input logic i_clk,
		input logic n_btn_rst,
		input logic we,									// Write enable
		/* verilator lint_off UNUSEDSIGNAL */
		input logic [(NUM_BUF_ELEMS_BITS-1):0] waddr,
		input logic [(BUFFER_PKT_BITS-1):0] wdata,		// Write Data.  0th byte is write address
		input logic re,									// Read enable
		/* verilator lint_off UNUSEDSIGNAL */
		input logic [(NUM_BUF_ELEMS_BITS-1):0] raddr,		// Read address
		output logic [(BUFFER_PKT_BITS-1):0] rdata		// Outputted data requested by read port
	);

	localparam NUM_BUF_ELEMENTS = (1 << NUM_BUF_ELEMS_BITS) - 1;

	// Symbol ID is the write address of the message.  All messages have the symbol ID in the 0th byte

	// Buffer used to write/read to/from
	logic [(BUFFER_PKT_BITS-1):0] cmd_buffer [0:NUM_BUF_ELEMENTS];

	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin

			rdata <= {BUFFER_PKT_BITS{1'd0}};
		end else begin
			if (we) begin
				cmd_buffer[waddr] <= wdata;
			end
			if (re) begin
				rdata <= cmd_buffer[raddr];
			end
		end
	end
	

endmodule
