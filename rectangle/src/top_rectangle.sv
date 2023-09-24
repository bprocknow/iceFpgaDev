module top_rectangle #(parameter COORDWID=10) (
`ifdef SIMULATED
	input wire logic pix_clk,	// Testbench/Verilator clock input
	input wire logic pix_clk_lock,
	input wire logic sim_rst,
	output logic [COORDWID-1:0] sdl_sx,
	output logic [COORDWID-1:0] sdl_sy,
	output logic sdl_de,
	output logic [7:0] sdl_r,	// Output 8-bit color (Only generating 4-bit color)
	output logic [7:0] sdl_g,
	output logic [7:0] sdl_b
`else // !SIMULATED
	input wire logic clk_12m, 	// 12MHz clock
	input wire logic btn_rst,	// Reset button
	output logic dvi_clk,
	output logic dvi_hsync,
	output logic dvi_vsync,
	output logic dvi_de,
	output logic [3:0] dvi_r,
	output logic [3:0] dvi_g,
	output logic [3:0] dvi_b
`endif
	);

	// Horizonal display timing parameters
        localparam HA_ACTIVE_PIX = 640;
        localparam HA_FRONT_PORCH = 16;
        localparam HA_SYNC_WIDTH = 96;
        localparam HA_BACK_PORCH = 48;
        localparam HA_TOTAL_PIX = (HA_ACTIVE_PIX + HA_FRONT_PORCH + HA_SYNC_WIDTH + HA_BACK_PORCH);

	// Vertical display timing parameters
        localparam VA_ACTIVE_PIX = 480;
        localparam VA_FRONT_PORCH = 10;
        localparam VA_SYNC_WIDTH = 2;
        localparam VA_BACK_PORCH = 33;
        localparam VA_TOTAL_PIX = (VA_ACTIVE_PIX + VA_FRONT_PORCH + VA_SYNC_WIDTH + VA_BACK_PORCH);

`ifndef SIMULATED
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

	// Instantiate the display signals
	logic [9:0] sx;
	logic [9:0] sy;
	wire logic de;
	wire logic hsync;
	wire logic vsync;
	display_signal disp_signal_inst (
		.pix_clk(pix_clk),
`ifdef SIMULATED
		.rst_pix(sim_rst),
`else
		.rst_pix(!pix_clk_lock),	// Wait for pixel clock to be ready
`endif
		.sx(sx),
		.sy(sy),
		.de(de),
		.hsync(hsync),
		.vsync(vsync)
	);

	// Drawing Logic
	localparam rectstartx = 240;
	localparam rectstarty = 140;
	localparam rectwidth = 200;
	localparam rectheight = 150;
	logic rectangle;
	always_comb begin
		rectangle = (sx >= (HA_BACK_PORCH + rectstartx)) &&
			(sx < (HA_BACK_PORCH + rectstartx + rectwidth)) &&
			(sy >= (VA_BACK_PORCH + rectstarty)) &&
			(sy < (VA_BACK_PORCH + rectstarty + rectheight));
	end

	// Creating pixel colors
	localparam rectcolor_r = 4'h6;
	localparam rectcolor_g = 4'h3;
	localparam rectcolor_b = 4'hf;
	localparam backcolor_r = 4'h1;
	localparam backcolor_g = 4'h4;
	localparam backcolor_b = 4'h2;
	logic [3:0] pixcolor_r, pixcolor_g, pixcolor_b;
	always_comb begin
		pixcolor_r = (rectangle) ? rectcolor_r : backcolor_r;
		pixcolor_g = (rectangle) ? rectcolor_g : backcolor_g;
		pixcolor_b = (rectangle) ? rectcolor_b : backcolor_b;
	end

`ifdef SIMULATED 	// Don't use vsync
	always_ff @(posedge pix_clk) begin
		sdl_sx <= sx;
		sdl_sy <= sy;
		sdl_de <= de;
		sdl_r <= {2{pixcolor_r}};	// Send 8-bits per color
		sdl_g <= {2{pixcolor_g}};
		sdl_b <= {2{pixcolor_b}};
	end

`else 		// Build when synthesizing
	localparam black_pix = 4'h0;
	logic [3:0] dispcolor_r, dispcolor_g, dispcolor_b;
	always_comb begin 
		dispcolor_r = (de) ? pixcolor_r : black_pix;
		dispcolor_g = (de) ? pixcolor_g : black_pix;
		dispcolor_b = (de) ? pixcolor_b : black_pix;
	end

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
