module	testtx (
		// {{{
//		input wire logic btn_rst,
		input	wire		i_clk,
		output	wire		o_uart_tx
		// }}}
	);

	// Signal declarations
	// {{{
	reg	[7:0]	message	[0:15];

	reg	[27:0]	counter;
	wire tx_busy;
	reg		tx_stb;
	reg	[3:0]	tx_index;
	reg	[7:0]	tx_data;

	// Initialize the message
	// {{{
	initial begin
		message[ 0] = "H";
		message[ 1] = "e";
		message[ 2] = "l";
		message[ 3] = "l";
		message[ 4] = "o";
		message[ 5] = ",";
		message[ 6] = " ";
		message[ 7] = "W";
		message[ 8] = "o";
		message[ 9] = "r";
		message[10] = "l";
		message[11] = "d";
		message[12] = "!";
		message[13] = " ";
		message[14] = "\r";
		message[15] = "\n";
	end
	// }}}

	// Send a Hello World message to the transmitter
	// {{{
	initial	counter = 28'hffffff0;
	always @(posedge i_clk)
		counter <= counter + 1'b1;

	initial	tx_index = 4'h0;
	always @(posedge i_clk)
	if ((tx_stb)&&(!tx_busy))
		tx_index <= tx_index + 1'b1;

	always @(posedge i_clk)
		tx_data <= message[tx_index];

	initial	tx_stb = 1'b0;
	always @(posedge i_clk)
	if (&counter)
		tx_stb <= 1'b1;
	else if ((tx_stb)&&(!tx_busy)&&(tx_index==4'hf))
		tx_stb <= 1'b0;
	// }}}

	txuartlite
		#(24'd868)
		transmitter(i_clk, tx_stb, tx_data, o_uart_tx, tx_busy);
endmodule
