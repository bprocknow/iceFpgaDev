
module sim_graphics #(parameter COORDWID=16) (
	input wire logic	i_clk,
	input wire logic [30:0]	i_setup,
	input wire logic	i_uart_rx,
	input wire logic	sim_rst,
	output logic		o_uart_tx,
	output logic [COORDWID-1:0] sdl_sx,
	output logic [COORDWID-1:0] sdl_sy,
	output logic sdl_de,
	output logic [7:0]	sdl_r,		// Ouptut 8-bit color (Only generating 4-bit color)
	output logic [7:0]	sdl_g,
	output logic [7:0]	sdl_b
	);

/* -------------- Local Parameters ---------- */

    localparam MAX_PAYLD_PKT_BITS = 8'd56;  // Maximum bits in the payload of a packet
    localparam DRAW_PAYLD_PKT_BITS = 8'd40; // Number of bits for all draw symbol cmd type data.  Doesn't include symbol ID, which is used to access teh array to retrieve the data.
    localparam NUM_SYM_SUPPTD_BITS = 8; // Number of symbols that can be drawn in one frame
	localparam BITS_PER_COLOR = 4;

	// Remove warnings
	assign o_uart_tx = 1'b0;

/* -------------- Clock generation ---------- */

/* --------------- UART ------------------------- */

	wire logic is_sym_mode;
	wire logic valid_output;
	wire logic [MAX_PAYLD_PKT_BITS-1:0] payload_data;
	DataAggregator #(MAX_PAYLD_PKT_BITS) aggregate_inst (
		.i_clk(i_clk),
		.n_btn_rst(sim_rst),
		.i_setup(i_setup),
		.i_uart_rx(i_uart_rx),
		.valid_output(valid_output),
		.is_sym_mode(is_sym_mode),
		.pld_packet_data(payload_data)
	);

/* -------------- Display Timing ----------- */

	logic [15:0] sx;
	logic [15:0] sy;
	wire logic de;
	/* verilator lint_off UNUSEDSIGNAL */
	wire logic n_vsync;
	display_signal disp_signal_inst (
		.pix_clk(i_clk),
		.rst_pix(sim_rst),
		.sx(sx),
		.sy(sy),
		.de(de),
		.n_vsync(n_vsync)
	);

/* -------------- Program/Symbol Buffer -------------- */

	wire logic [3:0] dispcolor_r, dispcolor_g, dispcolor_b;

    framebuf_manager #(
        MAX_PAYLD_PKT_BITS,
        DRAW_PAYLD_PKT_BITS,
        NUM_SYM_SUPPTD_BITS,
        BITS_PER_COLOR
    ) framebuf_manager_inst (
        .i_clk(i_clk),
        .n_btn_rst(sim_rst),
        .is_sym_mode(is_sym_mode),
        .valid_pld_packet(valid_output),
        .pld_packet_data(payload_data),
        .draw_en(de),
        .sx(sx),
        .sy(sy),
        .dispcolor_r(dispcolor_r),
		.dispcolor_g(dispcolor_g),
		.dispcolor_b(dispcolor_b)
	);

/* --------------- Output pixels ---------------- */
    always_ff @(posedge i_clk) begin
        sdl_de <= de;
        sdl_sx <= sx;
        sdl_sy <= sy;
        sdl_r <= {2{dispcolor_r}};
        sdl_g <= {2{dispcolor_g}};
        sdl_b <= {2{dispcolor_b}};
    end

endmodule
