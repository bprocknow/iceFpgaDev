
/*  Data Aggregator finds valid command packets and outputs them one byte at a time

	valid_output:  Indicates that there is a valid output_byte
*/
module DataAggregator (
	input logic i_clk,
	input logic n_btn_rst,
	input wire [30:0] i_setup,
	input wire logic i_uart_rx,
	output logic valid_output,		// Indicates that the outputted byte is valid
	output logic [9:0] output_data
	);

	typedef enum logic [2:0] {
		WAITING_FOR_HEADER,
		BYTE_1,
		PROCESS_DATA
	} State;

	reg pwr_reset;
	wire logic rx_stb, rx_break, rx_perr, rx_ferr;
	/* verilator lint_off UNUSED */
	wire logic rx_ignored;
	logic [7:0] rx_output;		// Buffer to Rx data
	reg lastvalid;

	State curr_state, next_state;

	rxuart reciever (i_clk, pwr_reset, i_setup, i_uart_rx, rx_stb, rx_output, rx_break, rx_perr, rx_ferr, rx_ignored);

	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			pwr_reset <= 1'b1;
			curr_state <= WAITING_FOR_HEADER;
			output_data <= 10'd50;
			valid_output <= 1'b1;
			lastvalid <= 1'b1;
		end else if (curr_state == PROCESS_DATA) begin
			pwr_reset <= 1'b0;
			output_data[7:0] <= rx_output;
			valid_output <= 1'b1;
			curr_state <= next_state;
		end else begin
			pwr_reset <= 1'b0;
			curr_state <= next_state;
			valid_output <= 1'b0;
			lastvalid <= 1'b0;
		end
	end

	always_comb begin
		next_state = curr_state;

		case (curr_state)
			WAITING_FOR_HEADER: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)&&(rx_output == 8'hF5)) ? BYTE_1 : WAITING_FOR_HEADER;
			BYTE_1: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? PROCESS_DATA : BYTE_1;
			PROCESS_DATA: next_state = WAITING_FOR_HEADER;
			default: next_state = WAITING_FOR_HEADER;
		endcase
	end
endmodule
