
/*  Data Aggregator finds valid command packets and outputs them one byte at a time

	valid_output:  Indicates that there is a valid output_byte
*/
module DataAggregator (
	input logic i_clk,
	input logic n_btn_rst,
	input wire [30:0] i_setup,
	input wire logic i_uart_rx,
	output logic valid_output,		// Indicates that the outputted byte is valid
	output logic [31:0] output_data
	);

	localparam MAX_LEN_CMD = 7;

	typedef enum logic [(MAX_LEN_CMD-1):0] {
		WAITING_FOR_HEADER,
		CMD_BYTE,
		POS_X_LSB,
		POS_X_MSB,
		POS_Y_LSB,
		POS_Y_MSB,
		PROCESS_DATA
	} State;

	reg pwr_reset;
	wire logic rx_stb, rx_break, rx_perr, rx_ferr;
	/* verilator lint_off UNUSED */
	wire logic rx_ignored;
	logic [7:0] rx_output;		// Buffer to Rx data
	logic [31:0] buf_output;	// Buffer to hold command output

	State curr_state, next_state;

	rxuart reciever (i_clk, pwr_reset, i_setup, i_uart_rx, rx_stb, rx_output, rx_break, rx_perr, rx_ferr, rx_ignored);

	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			pwr_reset <= 1'b1;
			curr_state <= WAITING_FOR_HEADER;
			output_data <= 32'd0;
			valid_output <= 1'b1;
		end else begin

			curr_state <= next_state;
			pwr_reset <= 1'b0;
			case (curr_state)
				POS_X_LSB: begin
					buf_output[7:0] <= rx_output;
					valid_output <= 1'b0;
				end
				POS_X_MSB: begin
					buf_output[15:8] <= rx_output;
					valid_output <= 1'b0;
				end
				POS_Y_LSB: begin
					buf_output[23:16] <= rx_output;
					valid_output <= 1'b0;
				end
				POS_Y_MSB: begin
					buf_output[31:24] <= rx_output;
					valid_output <= 1'b0;
				end
				PROCESS_DATA: begin
					output_data <= buf_output;
					valid_output <= 1'b1;
				end
				default: begin
					valid_output <= 1'b0;
				end
			endcase
		end
	end

	always_comb begin
		next_state = curr_state;

		case (curr_state)
			WAITING_FOR_HEADER: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)&&(rx_output == 8'hF5)) ? CMD_BYTE : WAITING_FOR_HEADER;
			CMD_BYTE: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)&&(rx_output == 8'h03)) ? POS_X_LSB : CMD_BYTE;
			POS_X_LSB: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? POS_X_MSB : POS_X_LSB;
			POS_X_MSB: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? POS_Y_LSB : POS_X_MSB;
			POS_Y_LSB: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? POS_Y_MSB : POS_Y_LSB;
			POS_Y_MSB: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? PROCESS_DATA : POS_Y_MSB;
			PROCESS_DATA: next_state = WAITING_FOR_HEADER;
			default: next_state = WAITING_FOR_HEADER;
		endcase
	end
endmodule

