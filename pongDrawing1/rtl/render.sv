module render (
	input wire logic de,
	input wire logic [9:0] sx,
	input wire logic [9:0] sy,
	output wire logic [3:0] dispcolor_r,
	output wire logic [3:0] dispcolor_g,
	output wire logic [3:0] dispcolor_b
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

    // Drawing Logic
    localparam rectstartx = 240;
    localparam rectstarty = 140;
    localparam rectwidth = 200;
    localparam rectheight = 150;
    logic rectangle;
    always_comb begin
        rectangle = (sx >= (HA_BACK_PORCH + rectstartx)) &&
            (sx < (HA_BACK_PORCH + rectstartx + rectwidth)) &&
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
