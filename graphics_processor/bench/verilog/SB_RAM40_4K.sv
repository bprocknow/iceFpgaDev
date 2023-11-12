
module SB_RAM40_4K (
		input logic WCLK,
		input logic WCLKE,
		input logic WE,					// Write enable
		input logic [10:0] WADDR,
		input logic [15:0] WDATA,		// Write Data.  0th byte is write address
		input logic RCLK,
		input logic RE,					// Read enable
		input logic [10:0] RADDR,		// Read address
		input logic [15:0] MASK,
		output logic [15:0] RDATA		// Outputted data requested by read port
	);

	// Symbol ID is the write address of the message.  All messages have the symbol ID in the 0th byte

	// Buffer used to write/read to/from
	logic [15:0] cmd_buffer [0:2047];

	always_ff @(posedge WCLK) begin
		if (WCLKE && WE) begin
			cmd_buffer[WADDR] <= WDATA & ~MASK;
		end
	end
	always_ff @(posedge RCLK) begin
		if (RE) begin
			RDATA <= cmd_buffer[RADDR];
		end
	end
	

endmodule
