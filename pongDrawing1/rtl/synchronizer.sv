
/*  Uses Double Flop Synchronization to synchronize uart and render events
*/
module synchronizer (
    input logic i_clk,
	input logic n_vsync,
	input logic valid_data,
    input logic [31:0] uart_buf, 
    output logic [31:0] render_pos
);

    reg [31:0] flop1, flop2;

    always_ff @(posedge i_clk) begin
		if (valid_data) begin
        	flop1 <= uart_buf;
		end
		if (!n_vsync) begin
			flop2 <= flop1;
		end
    end

	assign render_pos = flop2;

endmodule
