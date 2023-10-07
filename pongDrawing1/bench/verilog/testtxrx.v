module testtxrx (
	input wire i_clk,
	input wire i_uart_rx,
	output wire o_uart_tx
	);

	reg r_uart_tx;

	// Loopback UART
	initial r_uart_tx = 1'b1;
	always @(posedge i_clk)
		r_uart_tx <= i_uart_rx;
	assign o_uart_tx = r_uart_tx;
endmodule
