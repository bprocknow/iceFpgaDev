module top_graphicsprocessor #(
	localparam BITS_PER_COLOR = 4
	) (
	input logic n_btn_rst,	// Reset button
	input logic clk_12m, 	// 12MHz clock
	input logic i_uart_rx,	// UART Input
	output logic vsync_irq,
	output logic dvi_clk,
	output logic dvi_hsync,
	output logic dvi_vsync,
	output logic dvi_de,
	output logic [BITS_PER_COLOR-1:0] dvi_r,
	output logic [BITS_PER_COLOR-1:0] dvi_g,
	output logic [BITS_PER_COLOR-1:0] dvi_b
	);

	`include "display_timings.sv"

/* ------------------ Local Parameters --------------------- */

	/* ------ Packet parameters ------- */
	localparam MAX_PAYLD_PKT_BITS = 8'd56;	// Maximum bits in the payload of a packet
	localparam DRAW_PAYLD_PKT_BITS = 8'd40;	// Number of bits for all draw symbol cmd type data.  Doesn't include symbol ID, which is used to access teh array to retrieve the data.
	localparam NUM_SYM_SUPPTD_BITS = 8;			// Number of symbols that can be drawn in one frame

/* ------------------ Clocks ---------------------- */

	// Instantiate a pixel clock
	wire logic pix_clk_25_125m;
	wire logic pix_clk_lock;
	pixel_clock pixel_clk_inst (
		.clk(clk_12m),				// Input - FPGA native clock source
		.rst(n_btn_rst),			// Input - Reset
		.pix_clk(pix_clk_25_125m),	// Output - Pixel clock with specified frequency
		.pix_clk_lock(pix_clk_lock)	// Output - Is the pixel clock locked
	); 

/* ----------------- Display Signals ---------------- */

	// Generate display signals - pixel position (sx, sy), draw enable (de), sync's
	logic [15:0] sx;
	logic [15:0] sy;
	wire logic de;
	wire logic n_hsync;
	wire logic n_vsync;
	display_signal disp_signal_inst (
		.pix_clk(pix_clk_25_125m),	// Input - pixel clock
		.rst_pix(pix_clk_lock),		// Input - Wait for pixel clock to be ready
		.sx(sx),					// Output - Pixel position x on display
		.sy(sy),					// Output - Pixel position y on display
		.de(de),					// Output - Draw enable - whether the pixel is actually being draw.  False when in sync/porch zone of display
		.n_hsync(n_hsync),			// Output - Is *not* in hsync area
		.n_vsync(n_vsync)			// Output - Is *not* in vsync area
	);

/* ------------ UART Packet Aggregation --------------- */

	// Input and buffer UART communication to create aggregated packets containing non-header data for the specified command type
	wire logic is_sym_mode;
	wire logic valid_output;
	wire logic [MAX_PAYLD_PKT_BITS-1:0] pld_packet_data; 
	DataAggregator #(MAX_PAYLD_PKT_BITS) aggregate_inst (
		.i_clk(pix_clk_25_125m),
		.n_btn_rst(n_btn_rst),
		.i_setup(31'd30),					// Input - Clock divider (baud rate = i_clk / divider)
		.i_uart_rx(i_uart_rx),				// Input - Uart input line
		.valid_output(valid_output),		// Output - Indicates valid packet output. High for one clock cycle
		.is_sym_mode(is_sym_mode),			// Output - Indicates whether the device is in symbol or program mode
		.pld_packet_data(pld_packet_data)	// Output - packet containing non-header data (payload data)
	);

/* ------------------- VSYNC IRQ ---------------------- */

	// Set interrupt when done rendering the current frame
	// Clear interrupt when it recieves a valid packet and a new frame from when the 
	// interrupt was set has occurred
	logic isNewFrame;
	always_ff @(posedge pix_clk_25_125m or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			vsync_irq <= 1'b1;
			isNewFrame <= 1'b1;
		end else if (vsync_irq) begin
			// Clear interrupt on recieving valid packet
			if (valid_output) begin
				vsync_irq <= 1'b0;
			end
		end else begin
			if (sx == 0 && sy == 0) begin
				// Save new frames, only allow interrupts after a new frame has occurred
				isNewFrame <= 1'b1;
			end else if (isNewFrame && sx >= HA_ACTIVE_PIX && sy >= VA_ACTIVE_PIX) begin
				// Set interrupt after the current frame has been rendered
				vsync_irq <= 1'b1;
				isNewFrame <= 1'b0;
			end
		end
	end

/* ------------------ Front/Back frame buffer ------------- */

	// Generate pixel color from uart messages, display signals
	wire logic [3:0] dispcolor_r, dispcolor_g, dispcolor_b;
	framebuf_manager #(
		MAX_PAYLD_PKT_BITS,
		DRAW_PAYLD_PKT_BITS,
		NUM_SYM_SUPPTD_BITS,
		BITS_PER_COLOR
	) framebuf_manager_inst (
		.i_clk(pix_clk_25_125m),
		.n_btn_rst(n_btn_rst),
		.is_sym_mode(is_sym_mode),
		.valid_pld_packet(valid_output),
		.pld_packet_data(pld_packet_data),
		.draw_en(de),
		.sx(sx),
		.sy(sy),
		.dispcolor_r(dispcolor_r),
		.dispcolor_g(dispcolor_g),
		.dispcolor_b(dispcolor_b)
	);


	// DVI Pmod output - Use render signals to draw current pixel
	SB_IO #(
	    .PIN_TYPE(6'b010100)  // PIN_OUTPUT_REGISTERED
	) dvi_signal_io [14:0] (
	    .PACKAGE_PIN({dvi_hsync, dvi_vsync, dvi_de, dvi_r, dvi_g, dvi_b}),
	    .OUTPUT_CLK(pix_clk_25_125m),
	    .D_OUT_0({n_hsync, n_vsync, de, dispcolor_r, dispcolor_g, dispcolor_b}),
	    /* verilator lint_off PINCONNECTEMPTY */
	    .D_OUT_1()
	    /* verilator lint_on PINCONNECTEMPTY */
	);
	
	// DVI Pmod clock output: 180° out of phase with other DVI signals
	SB_IO #(
	    .PIN_TYPE(6'b010000)  // PIN_OUTPUT_DDR
	) dvi_clk_io (
	    .PACKAGE_PIN(dvi_clk),
	    .OUTPUT_CLK(pix_clk_25_125m),
	    .D_OUT_0(1'b0),
	    .D_OUT_1(1'b1)
	);

endmodule
