
/*  Data Aggregator decodes packets and outputs the payload data bytes, command byte

	This module knows the length of the expected messages, and decodes the message type to find the size.

	valid_output:  Indicates that there is a valid output aggregated packet
*/
module DataAggregator #(
		parameter MAX_PAYLD_PKT_BITS		// Maximum packet bits (payload only)
	) (
		input logic i_clk,
		input logic n_btn_rst,
		input logic  [30:0] i_setup,
		input logic i_uart_rx,
		output logic valid_output,		// Indicates that the outputted byte is valid
		output logic is_sym_mode,
		output logic [MAX_PAYLD_PKT_BITS-1:0] pld_packet_data	// Non-header payload data
	);

	localparam MAX_LEN_CMD = 9;			// Maximum length full input command in bytes

	// All input command bytes have a state + one to process data
	typedef enum logic [MAX_LEN_CMD+1:0] {
		WAITING_FOR_HEADER,
		CMD_BYTE,
		BYTE_1,
		BYTE_2,
		BYTE_3,
		BYTE_4,
		BYTE_5,
		BYTE_6,
		BYTE_7,
		PROCESS_DATA
	} UartState;

	reg pwr_reset;
	wire logic rx_stb, rx_break, rx_perr, rx_ferr;
	/* verilator lint_off UNUSED */
	wire logic rx_ignored;
	logic [7:0] rx_output;		// Buffer to Rx data
	logic [MAX_PAYLD_PKT_BITS-1:0] buf_output;	// Buffer to hold command output

	UartState curr_state, next_state;

	rxuart #(31'd30) reciever (i_clk, pwr_reset, i_setup, i_uart_rx, rx_stb, rx_output, rx_break, rx_perr, rx_ferr, rx_ignored);

	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			pwr_reset <= 1'b1;
			curr_state <= WAITING_FOR_HEADER;
			valid_output <= 1'b0;
			is_sym_mode <= 1'b0;
			pld_packet_data <= {(MAX_PAYLD_PKT_BITS){1'd0}};
		end else if (curr_state == CMD_BYTE) begin

			pwr_reset <= 1'b0;
			valid_output <= 1'b0;

			if (is_sym_mode == 1'b1 && rx_output == 8'h01) begin
				// Cannot process program commands in symbol mode
				curr_state <= WAITING_FOR_HEADER;
			end else if (rx_output == 8'h02) begin 
				// Move to symbology mode.  Sym mode messages are header only
				is_sym_mode <= 1'b1;
				curr_state <= WAITING_FOR_HEADER;
			end else begin
				// Valid command, move to processing packet payload
				curr_state <= next_state;
			end
		end else begin
			curr_state <= next_state;
			pwr_reset <= 1'b0;
			case (curr_state)
				BYTE_1: begin
					buf_output[7:0] <= rx_output;
				end
				BYTE_2: begin
					buf_output[15:8] <= rx_output;
				end
				BYTE_3: begin
					buf_output[23:16] <= rx_output;
				end
				BYTE_4: begin
					buf_output[31:24] <= rx_output;
				end
				BYTE_5: begin
					buf_output[39:32] <= rx_output;
				end
				BYTE_6: begin
					buf_output[47:40] <= rx_output;
				end
				BYTE_7: begin
					buf_output[55:48] <= rx_output;
				end
				PROCESS_DATA: begin
					pld_packet_data <= buf_output;
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
			WAITING_FOR_HEADER: begin
				//next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)&&(rx_output == 8'hF5)) ? CMD_BYTE : WAITING_FOR_HEADER;
				if ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)&&(rx_output == 8'hF5)) begin 
					next_state = CMD_BYTE;
				end else begin
					next_state = WAITING_FOR_HEADER;
				end
			end
			CMD_BYTE: begin
				if ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) begin
					// Verify valid command byte
					if (rx_output < 8'h04) begin
						next_state = BYTE_1;
					end else begin
						next_state = WAITING_FOR_HEADER;
					end
				end
			end
			// On error, reject message
			BYTE_1:	next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? BYTE_2 : BYTE_1;
			BYTE_2: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? BYTE_3 : BYTE_2;
			BYTE_3: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? BYTE_4 : BYTE_3;
			BYTE_4: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? BYTE_5 : BYTE_4;
			BYTE_5: begin
				// If in symbol drawing mode, this is the end of the packet -> process data
				if (is_sym_mode) begin
					next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? PROCESS_DATA : BYTE_5;
				end else begin
					next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? BYTE_6 : BYTE_5;
				end
			end
			BYTE_6: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? BYTE_7 : BYTE_6;
			BYTE_7: next_state = ((rx_stb)&&(!rx_break)&&(!rx_perr)&&(!rx_ferr)) ? PROCESS_DATA : BYTE_7;
			PROCESS_DATA: next_state = WAITING_FOR_HEADER;
			default: next_state = WAITING_FOR_HEADER;
		endcase
	end
endmodule

