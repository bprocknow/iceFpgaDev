
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

/* -------------- Local Parameters ---------- */

    localparam MAX_PAYLD_PKT_BITS = 8'd56;  // Maximum bits in the payload of a packet
    localparam PROG_PAYLD_PKT_BITS = 8'd48; // Number of bits for all program cmd type attributes.  Doesn't include symbol ID, which is used to access the array to retrieve the attributes
    //localparam DRAW_PAYLD_PKT_BITS = 8'd40; // Number of bits for all draw symbol cmd type data.  Doesn't include symbol ID, which is used to access teh array to retrieve the data.
    localparam NUM_SYM_SUPPTD = 2; // Number of symbols that can be drawn in one frame

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
		.payload_data(payload_data)
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

    // The command attributes are saved and accessed by the symbol ID.  Write address is 
    // contained in the write packet in byte 0
    logic [NUM_SYM_SUPPTD-1:0] valid_prog_idx;     // Indicates if the symbol ID of the program buffer contains initialized valid data
    logic prog_re;
    logic [NUM_SYM_SUPPTD-1:0] prog_raddr;
    logic [PROG_PAYLD_PKT_BITS-1:0] prog_rdata;
    CommandBuffer #(MAX_PAYLD_PKT_BITS, PROG_PAYLD_PKT_BITS, NUM_SYM_SUPPTD)
    prog_buf_inst (
        .i_clk(i_clk),
        .n_btn_rst(sim_rst),
        .we(valid_output),              // Input - Valid input packet to process
        .wdata(payload_data),           // Input - Payload packet data to put in the buffer
        .re(prog_re),
        .raddr(prog_raddr),
        .rdata(prog_rdata),
        .valid_idx(valid_prog_idx)     // Output - Indicates whether the symbol ID index of the program buffer contains valid data
    );

    always_ff @(posedge i_clk or negedge sim_rst) begin
        if (!sim_rst) begin
            prog_re <= 1'b0;
        end
        else if (is_sym_mode) begin
            prog_re <= 1'b1;
            prog_raddr <= 2'b0;
        end
    end

/* -------------- Drawing Logic -------------- */

	//reg [31:0] render_pos;
	//synchronizer sync_uart_render (
	//	.i_clk(i_clk),
	//	.n_vsync(n_vsync),
	//	.valid_data(valid_output),
	//	.uart_buf(output_data),
	//	.render_pos(render_pos)
	//);

	wire logic [3:0] dispcolor_r, dispcolor_g, dispcolor_b;
	render #(PROG_PAYLD_PKT_BITS) render_inst (
		.de(de),
		.sx(sx),
		.sy(sy),
		.is_sym_mode(is_sym_mode),
		.prog_buffer(prog_rdata),
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
