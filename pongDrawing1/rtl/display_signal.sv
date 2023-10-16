
module display_signal(
	input wire logic pix_clk,
	input wire logic rst_pix,
	output logic [15:0] sx,
	output logic [15:0] sy,
`ifndef SIMULATED
	output logic n_hsync,
`endif
	output logic n_vsync,
	output logic de
	);

	`include "display_timings.sv"

	always_comb begin
		de =	((sx >= HA_BACK_PORCH) && 
			(sx < (HA_BACK_PORCH + HA_ACTIVE_PIX)) &&
			(sy >= VA_BACK_PORCH) &&
			(sy < (VA_BACK_PORCH + VA_ACTIVE_PIX)));
`ifndef SIMULATED
		// Invert polarity - low voltage on sync
		n_hsync = ~(sx >=(HA_BACK_PORCH + HA_ACTIVE_PIX + HA_FRONT_PORCH) &&
			(sx < (HA_TOTAL_PIX)));
`endif
		// Invert polarity - low voltage on sync
		n_vsync = ~(sy >=(VA_BACK_PORCH + VA_ACTIVE_PIX + VA_FRONT_PORCH) &&
			(sy < (VA_TOTAL_PIX)));
	end

	always_ff @(posedge pix_clk or negedge rst_pix) begin
		if (!rst_pix) begin
			sx <= 0;
			sy <= 0;
		end else if (sx < (HA_TOTAL_PIX)) begin
			sx <= sx + 1;
		end else begin
			sx <= 0;
			sy <= (sy < VA_TOTAL_PIX) ? (sy + 1) : 0;
		end
	end
endmodule


