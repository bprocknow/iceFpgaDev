
/*	Inputs full packets per the ICD and buffers them in the appropriate location

*/
module CommandBuffer # (
	parameter MAX_PAYLD_PKT_BITS,
	parameter PROG_PAYLD_PKT_BITS,
	parameter NUM_SYM_SUPPTD_BITS,
	localparam CMD_TYPES = 2
	) (
	input logic i_clk,
	input logic n_btn_reset,
	input logic valid_input,		// Indicates that a new command packet is valid
	input logic is_prog_mode,
	input logic [MAX_PAYLD_PKT_BITS-1:0] payload_data,
	output logic [NUM_SYM_SUPPTD_BITS-1:0] valid_prog_idx,
	output logic [PROG_PAYLD_PKT_BITS-1:0] prog_buffer [0:NUM_SYM_SUPPTD_BITS-1]
	);

	// Supported command types have the symbol ID at index 0 of the payload data packet
	wire logic [NUM_SYM_SUPPTD_BITS-1:0] symbol_id;
	assign symbol_id = payload_data[7:0];
	
	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin

			// Invalidate the program buffer
			valid_prog_idx <= 8'h0;

		end else if (valid_input) begin
			// Add the inputted payload packet data to the cooresponding buffer

			if (is_prog_mode) begin

				// Assign symbol attribute data (not symbol ID) to the program attribute buffer at the index of the symbol ID
				prog_buffer[symbol_id] <= payload_data[PROG_PAYLD_PKT_BITS+7:8];
				valid_prog_idx[symbol_id] = 1'b1;
			end
//			end else begin
//
//			end
		end
	end
	

endmodule
