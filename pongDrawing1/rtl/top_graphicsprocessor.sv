module top_graphicsprocessor (
	input logic n_btn_rst,	// Reset button
	input logic clk_12m, 	// 12MHz clock
	input logic i_uart_rx,	// UART Input
	output logic o_uart_tx,// UART Output
	output logic dvi_clk,
	output logic dvi_hsync,
	output logic dvi_vsync,
	output logic dvi_de,
	output logic [3:0] dvi_r,
	output logic [3:0] dvi_g,
	output logic [3:0] dvi_b
	);

/* ------------------ Local Parameters --------------------- */

	localparam MAX_PAYLD_PKT_BITS = 8'd56;	// Maximum bits in the payload of a packet
	localparam PROG_PAYLD_PKT_BITS = 8'd48;	// Number of bits for all program cmd type attributes.  Doesn't include symbol ID, which is used to access the array to retrieve the attributes
	localparam DRAW_PAYLD_PKT_BITS = 8'd40;	// Number of bits for all draw symbol cmd type data.  Doesn't include symbol ID, which is used to access teh array to retrieve the data.
	localparam NUM_SYM_SUPPTD = 2;			// Number of symbols that can be drawn in one frame

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

/* ---------------- UART -------------------- */

	// Input and buffer UART communication to create aggregated packets containing non-header data for the specified command type
	wire logic is_sym_mode;
	wire logic valid_output;
	wire logic [MAX_PAYLD_PKT_BITS-1:0] payload_data; 
	DataAggregator #(MAX_PAYLD_PKT_BITS) aggregate_inst (
		.i_clk(pix_clk_25_125m),
		.n_btn_rst(n_btn_rst),
		.i_setup(31'd60),					// Input - Clock divider (baud rate = i_clk / divider)
		.i_uart_rx(i_uart_rx),				// Input - Uart input line
		.valid_output(valid_output),		// Output - Indicates valid packet output. High for one clock cycle
		.is_sym_mode(is_sym_mode),			// Output - Indicates whether the device is in symbol or program mode
		.payload_data(payload_data)			// Output - packet containing non-header data (payload data)
	);

/* --------- Program / Symbol Buffer ------ */

	// The command attributes are saved and accessed by the symbol ID.  Write address is 
	// contained in the write packet in byte 0
	logic [NUM_SYM_SUPPTD-1:0] valid_prog_idx;		// Indicates if the symbol ID of the program buffer contains initialized valid data
	logic prog_re;
	logic [NUM_SYM_SUPPTD-1:0] prog_raddr;
	logic [PROG_PAYLD_PKT_BITS-1:0] prog_rdata;
	CommandBuffer #(MAX_PAYLD_PKT_BITS, PROG_PAYLD_PKT_BITS, NUM_SYM_SUPPTD) 
	prog_buf_inst (
		.i_clk(pix_clk_25_125m),
		.n_btn_rst(n_btn_rst),
		.we(valid_output),				// Input - Valid input packet to process
		.wdata(payload_data),			// Input - Payload packet data to put in the buffer
		.re(prog_re),					// Input - Read enable
		.raddr(prog_raddr),				// Input - Read address in buffer
		.rdata(prog_rdata),				// Output - Read data from buffer specified by address
		.valid_idx(valid_prog_idx),		// Output - Indicates whether the symbol ID index of the program buffer contains valid data
	);

	always_ff @(posedge pix_clk_25_125m or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			prog_re <= 1'b0;
		end
		else if (is_sym_mode) begin
			prog_re <= 1'b1;
			prog_raddr <= 2'b0;
		end
	end
	
/* --------------- Render -------------------- */
	
	// Synchronize UART messaging and rendering (vsync)
	//reg [31:0] render_pos;
	//synchronizer sync_uart_render (
	//	.i_clk(pix_clk_25_125m),
	//	.n_vsync(n_vsync),
	//	.valid_data(valid_output),
	//	.uart_buf(output_data),
	//	.render_pos(render_pos)
	//);

	// Generate pixel color from uart messages, display signals
	wire logic [3:0] dispcolor_r, dispcolor_g, dispcolor_b;
	render #(PROG_PAYLD_PKT_BITS) render_inst (
		.de(de),						// Input - display enable.  Indicates that the pixel positon (sx, sy) is actually being drawn
		.sx(sx),						// Input - position x on framebuffer
		.sy(sy),						// Input - position y on framebuffer
		.is_sym_mode(is_sym_mode),		// Input - Is the system in symbol mode
		.prog_buffer(prog_rdata),		// Input - Program data to draw
		.dispcolor_r(dispcolor_r),		// Output - (sx, sy) pixel color red
		.dispcolor_g(dispcolor_g),		// Output - (sx, sy) pixel color green
		.dispcolor_b(dispcolor_b)		// Output - (sx, sy) pixel color blue
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
