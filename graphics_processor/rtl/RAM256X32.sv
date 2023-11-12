
module RAM256X32 (
	input logic i_clk,
	input logic we,
	input logic [7:0] waddr,
	input logic [31:0] wdata,
	input logic re,
	input logic [7:0] raddr,
	output logic [31:0] rdata
	);

	logic [10:0] waddr_expand, raddr_expand;
	logic [15:0] wdata_buf1, wdata_buf2;
	logic [15:0] rdata_buf1, rdata_buf2;

	assign waddr_expand = {3'b000, waddr};
	assign raddr_expand = {3'b000, raddr};

	assign wdata_buf1 = wdata[15:0];
	assign wdata_buf2 = wdata[31:16];

	assign rdata = {rdata_buf2, rdata_buf1};

	SB_RAM40_4K ram256x16_inst1 (
		.RDATA(rdata_buf1),
		.RADDR(raddr_expand),
		.RCLK(i_clk),
		.RE(re),
		.WADDR(waddr_expand),
		.WCLK(i_clk),
		.WCLKE(1'b1),
		.WDATA(wdata_buf1),
		.WE(we),
		.MASK(16'h0000)
	);

	SB_RAM40_4K ram256x16_inst2 (
		.RDATA(rdata_buf2),
		.RADDR(raddr_expand),
		.RCLK(i_clk),
		.RE(re),
		.WADDR(waddr_expand),
		.WCLK(i_clk),
		.WCLKE(1'b1),
		.WDATA(wdata_buf2),
		.WE(we),
		.MASK(16'h0000)
	);

endmodule
