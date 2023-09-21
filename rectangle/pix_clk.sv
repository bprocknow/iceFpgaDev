
module pixel_clock(
	input wire logic clk,	// 12 MHz clock
	input wire logic rst,	// Reset line
	output logic pix_clk, 	// 25.125 MHz clock
	output logic pix_clk_lock,	// Pixel clock locked signal
	);

	localparam FEEDBACK_PATH="SIMPLE";
	localparam DIVR=4'b000;
	localparam DIVF=7'b1000010;
	localparam DIVQ=3'b101;
	localparam FILTER_RANGE=3'b001;

	logic sb_lock;
	SB_PLL40_PAD #(
		.FEEDBACK_PATH(FEEDBACK_PATH),
		.DIVR(DIVR),
		.DIVF(DIVF),
		.DIVQ(DIVQ),
		.FILTER_RANGE(FILTER_RANGE)
	) SB_PLL40_PAD_inst (
		.PACKAGEPIN(clk),
		.PLLOUTGLOBAL(pix_clk),
		.LOCK(sb_lock),
		.RESETB(rst),
	);

	logic lock_signal;
	always_comb begin
		lock_signal <= sb_lock;
		pix_clk_lock <= lock_signal;
	end
endmodule

		
