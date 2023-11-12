
module RAM256X12 (
	input logic i_clk,
	input logic we,
	input logic [7:0] waddr,
	input logic [11:0] wdata,
	input logic re,
	input logic [7:0] raddr,
	output logic [11:0] rdata
	);

	logic [10:0] waddr_expand, raddr_expand;
	/* verilator lint_off UNUSEDSIGNAL */
	logic [15:0] wdata_expand, rdata_expand;

	assign waddr_expand = {3'b000, waddr};
	assign raddr_expand = {3'b000, raddr};

	assign wdata_expand = {4'b0000, wdata};
	assign rdata = rdata_expand[11:0];

	SB_RAM40_4K ram256x16_inst (
		.RDATA(rdata_expand),
		.RADDR(raddr_expand),
		.RCLK(i_clk),
		.RE(re),
		.WADDR(waddr_expand),
		.WCLK(i_clk),
		.WCLKE(1'b1),
		.WDATA(wdata_expand),
		.WE(we),
		.MASK(16'h0000)
	);
endmodule
