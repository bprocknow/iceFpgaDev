
/*  Uses Double Flop Synchronization to synchronize uart and render events
*/
module synchronizer (
    input wire logic i_clk,
	input wire logic valid_data,
    input wire logic [9:0] uart_buf, 
    output wire [9:0] render_pos
);

    reg [9:0] flop1, flop2;

    always_ff @(posedge i_clk) begin
		if (valid_data) begin
        	flop1 <= uart_buf;
        	flop2 <= flop1;
		end
    end

    assign render_pos = flop2;

endmodule
