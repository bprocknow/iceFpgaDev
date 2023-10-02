
module display_signal(
	input wire logic pix_clk,
	input wire logic rst_pix,
	output logic [9:0] sx,
	output logic [9:0] sy,
	output logic de,
	output logic hsync,
	output logic vsync
	);

	// Horizonal display timing parameters
        localparam HA_ACTIVE_PIX = 640;
        localparam HA_FRONT_PORCH = 16;
        localparam HA_SYNC_WIDTH = 96;
        localparam HA_BACK_PORCH = 48;
        localparam HA_TOTAL_PIX = (HA_ACTIVE_PIX + HA_FRONT_PORCH + HA_SYNC_WIDTH + HA_BACK_PORCH);

	// Vertical display timing parameters
        localparam VA_ACTIVE_PIX = 480;
        localparam VA_FRONT_PORCH = 10;
        localparam VA_SYNC_WIDTH = 2;
        localparam VA_BACK_PORCH = 33;
        localparam VA_TOTAL_PIX = (VA_ACTIVE_PIX + VA_FRONT_PORCH + VA_SYNC_WIDTH + VA_BACK_PORCH);

	always_comb begin
		de =	((sx >= HA_BACK_PORCH) && 
			(sx < (HA_BACK_PORCH + HA_ACTIVE_PIX)) &&
			(sy >= VA_BACK_PORCH) &&
			(sy < (VA_BACK_PORCH + VA_ACTIVE_PIX)));
		// Invert polarity - low voltage on sync
		hsync = ~(sx >=(HA_BACK_PORCH + HA_ACTIVE_PIX + HA_FRONT_PORCH) &&
			(sx < (HA_TOTAL_PIX)));
		// Invert polarity - low voltage on sync
		vsync = ~(sy >=(VA_BACK_PORCH + VA_ACTIVE_PIX + VA_FRONT_PORCH) &&
			(sy < (VA_TOTAL_PIX)));
	end

	always_ff @(posedge pix_clk) begin
		if (rst_pix) begin
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


