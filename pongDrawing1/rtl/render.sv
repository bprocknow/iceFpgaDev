module render (
	input wire logic de,
	input wire logic [9:0] sx,
	input wire logic [9:0] sy,
	input wire logic [9:0] sympos,
	output wire logic [3:0] dispcolor_r,
	output wire logic [3:0] dispcolor_g,
	output wire logic [3:0] dispcolor_b
	);

	`include "display_timings.sv"

    // Drawing Logic
    localparam rectstarty = 140;
    localparam rectwidth = 200;
    localparam rectheight = 150;
    logic rectangle;
    always_comb begin
        rectangle = (sx >= (HA_BACK_PORCH + sympos)) &&
            (sx < (HA_BACK_PORCH + sympos + rectwidth)) &&
            (sy >= (VA_BACK_PORCH + rectstarty)) &&
            (sy < (VA_BACK_PORCH + rectstarty + rectheight));
    end

    // Creating pixel colors
    localparam rectcolor_r = 4'h6;
    localparam rectcolor_g = 4'h3;
    localparam rectcolor_b = 4'hf;
    localparam backcolor_r = 4'h1;
    localparam backcolor_g = 4'h4;
    localparam backcolor_b = 4'h2;
    logic [3:0] pixcolor_r, pixcolor_g, pixcolor_b;
    always_comb begin
        pixcolor_r = (rectangle) ? rectcolor_r : backcolor_r;
        pixcolor_g = (rectangle) ? rectcolor_g : backcolor_g;
        pixcolor_b = (rectangle) ? rectcolor_b : backcolor_b;
    end

    localparam black_pix = 4'h0;
    always_comb begin
        dispcolor_r = (de) ? pixcolor_r : black_pix;
        dispcolor_g = (de) ? pixcolor_g : black_pix;
        dispcolor_b = (de) ? pixcolor_b : black_pix;
    end
endmodule
