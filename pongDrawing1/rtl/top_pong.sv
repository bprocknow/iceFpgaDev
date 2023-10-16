module top_pong #(parameter CORDW=10) (	// Coordinate Width [bits]
	input wire logic n_btn_rst,	// Reset button
	input wire logic clk_12m, 	// 12MHz clock
	input i_uart_rx,	// UART Input
	output wire logic o_uart_tx,// UART Output
	output logic dvi_clk,
	output logic dvi_hsync,
	output logic dvi_vsync,
	output logic dvi_de,
	output logic [3:0] dvi_r,
	output logic [3:0] dvi_g,
	output logic [3:0] dvi_b
	);

/* ------------------ Local Parameters --------------------- */
/* ------------------ Clocks ---------------------- */

	// Instantiate a pixel clock
	wire logic pix_clk_25_125m;
	wire logic pix_clk_lock;
	pixel_clock pixel_clk_inst (
		.clk(clk_12m),
		.rst(n_btn_rst),
		.pix_clk(pix_clk_25_125m),
		.pix_clk_lock(pix_clk_lock)
	); 

/* ----------------- Display Signals ---------------- */

	// Instantiate the display signals
	logic [15:0] sx;
	logic [15:0] sy;
	wire logic de;
	wire logic n_hsync;
	wire logic n_vsync;
	display_signal disp_signal_inst (
		.pix_clk(pix_clk_25_125m),
		.rst_pix(pix_clk_lock),	// Wait for pixel clock to be ready
		.sx(sx),
		.sy(sy),
		.de(de),
		.n_hsync(n_hsync),
		.n_vsync(n_vsync)
	);

/* ---------------- UART -------------------- */

	wire logic valid_output;
	wire logic [31:0] output_data;
	DataAggregator aggregate_inst (
		.i_clk(pix_clk_25_125m),
		.n_btn_rst(n_btn_rst),
		.i_setup(31'd60),			// Baud rate 418750bps
		.i_uart_rx(i_uart_rx),
		.valid_output(valid_output),
		.output_data(output_data)
	);

/* --------------- Render -------------------- */
	
	reg [31:0] render_pos;
	synchronizer sync_uart_render (
		.i_clk(pix_clk_25_125m),
		.n_vsync(n_vsync),
		.valid_data(valid_output),
		.uart_buf(output_data),
		.render_pos(render_pos)
	);

	wire logic [3:0] dispcolor_r, dispcolor_g, dispcolor_b;
	render render_inst (
		.de(de),
		.sx(sx),
		.sy(sy),
		.uart_buf(render_pos),
		.dispcolor_r(dispcolor_r),
		.dispcolor_g(dispcolor_g),
		.dispcolor_b(dispcolor_b)
	);

	// DVI Pmod output
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
