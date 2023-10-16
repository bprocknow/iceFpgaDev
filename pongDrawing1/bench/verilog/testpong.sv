
module testpong #(parameter COORDWID=16) (
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

	// Remove warnings
	assign o_uart_tx = 1'b0;

/* -------------- Clock generation ---------- */

/* --------------- UART ------------------------- */

	wire logic valid_output;
	wire logic [31:0] output_data;
	DataAggregator aggregate_inst (
		.i_clk(i_clk),
		.n_btn_rst(sim_rst),
		.i_setup(i_setup),
		.i_uart_rx(i_uart_rx),
		.valid_output(valid_output),
		.output_data(output_data)
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

/* -------------- Drawing Logic -------------- */

	reg [31:0] render_pos;
	synchronizer sync_uart_render (
		.i_clk(i_clk),
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
