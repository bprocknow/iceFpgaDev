module top_pong #(parameter CORDW=10) (	// Coordinate Width [bits]
	input wire logic btn_rst,	// Reset button
`ifdef SIMULATED
	input wire logic pix_clk,
	output logic sdl_de,
	output logic [CORDW-1:0] sdl_sx,
	output logic [CORDW-1:0] sdl_sy,
	output logic [7:0] sdl_r,	// Output 8-bit color (Only generating 4-bit color)
	output logic [7:0] sdl_g,
	output logic [7:0] sdl_b,
	output logic o_uart_tx
`else
	input wire logic clk_12m, 	// 12MHz clock
	output logic dvi_clk,
	output logic dvi_hsync,
	output logic dvi_vsync,
	output logic dvi_de,
	output logic [3:0] dvi_r,
	output logic [3:0] dvi_g,
	output logic [3:0] dvi_b
`endif
	);

/* ------------------ Local Parameters --------------------- */
/* ------------------ Clocks ---------------------- */

`ifndef SIMULATED	// Synthesized code
	// Instantiate a pixel clock
	wire logic pix_clk;
	wire logic pix_clk_lock;
	pixel_clock pixel_clk_inst (
		.clk(clk_12m),
		.rst(btn_rst),
		.pix_clk(pix_clk),
		.pix_clk_lock(pix_clk_lock)
	); 
`endif

/* ----------------- Display Signals ---------------- */

	// Instantiate the display signals
	logic [9:0] sx;
	logic [9:0] sy;
	wire logic de;
	wire logic hsync;
	wire logic vsync;
	display_signal disp_signal_inst (
		.pix_clk(pix_clk),
`ifdef SIMULATED
		.rst_pix(btn_rst),
`else	// Synthesized Code
		.rst_pix(!pix_clk_lock),	// Wait for pixel clock to be ready
`endif
		.sx(sx),
		.sy(sy),
		.de(de),
		.hsync(hsync),
		.vsync(vsync)
	);

/* --------------- Render -------------------- */
	wire logic [3:0] dispcolor_r, dispcolor_g, dispcolor_b;
	render render_inst (
		.de(de),
		.sx(sx),
		.sy(sy),
		.dispcolor_r(dispcolor_r),
		.dispcolor_g(dispcolor_g),
		.dispcolor_b(dispcolor_b)
	);

`ifdef SIMULATED
	
	always_ff @(posedge pix_clk) begin
		sdl_de <= de;
		sdl_sx <= sx;
		sdl_sy <= sy;
		sdl_r <= {2{dispcolor_r}};
		sdl_g <= {2{dispcolor_g}};
		sdl_b <= {2{dispcolor_b}};
	end

`else				// Synthesized code
	// DVI Pmod output
	SB_IO #(
	    .PIN_TYPE(6'b010100)  // PIN_OUTPUT_REGISTERED
	) dvi_signal_io [14:0] (
	    .PACKAGE_PIN({dvi_hsync, dvi_vsync, dvi_de, dvi_r, dvi_g, dvi_b}),
	    .OUTPUT_CLK(pix_clk),
	    .D_OUT_0({hsync, vsync, de, dispcolor_r, dispcolor_g, dispcolor_b}),
	    /* verilator lint_off PINCONNECTEMPTY */
	    .D_OUT_1()
	    /* verilator lint_on PINCONNECTEMPTY */
	);
	
	// DVI Pmod clock output: 180° out of phase with other DVI signals
	SB_IO #(
	    .PIN_TYPE(6'b010000)  // PIN_OUTPUT_DDR
	) dvi_clk_io (
	    .PACKAGE_PIN(dvi_clk),
	    .OUTPUT_CLK(pix_clk),
	    .D_OUT_0(1'b0),
	    .D_OUT_1(1'b1)
	);
`endif

endmodule
