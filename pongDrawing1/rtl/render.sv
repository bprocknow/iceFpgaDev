/*  Render the specified pixel color
	If not in program mode, draw a black screen
*/
module render #(PROG_PAYLD_PKT_BITS) (
	input logic de,
	input logic [15:0] sx,
	input logic [15:0] sy,
	input logic is_sym_mode,
	/* verilator lint_off UNUSED */
	input logic [PROG_PAYLD_PKT_BITS-1:0] prog_buffer,
	output logic [3:0] dispcolor_r,
	output logic [3:0] dispcolor_g,
	output logic [3:0] dispcolor_b
	);

	`include "display_timings.sv"

	wire logic [15:0] rectwidth, rectheight;
	wire logic [3:0] rectcolor_r, rectcolor_g, rectcolor_b;

	assign rectheight = prog_buffer[15:0];
	assign rectwidth = prog_buffer[31:16];
	assign rectcolor_r = prog_buffer[35:32];
	assign rectcolor_g = prog_buffer[39:36];
	assign rectcolor_b = prog_buffer[43:40];

    // Drawing Logic
	localparam sympos_x = 50;
	localparam sympos_y = 50;
    logic rectangle;
    always_comb begin
		if (is_sym_mode) begin
        	rectangle = (sx >= (HA_BACK_PORCH + sympos_x)) &&
        	    (sx < (HA_BACK_PORCH + sympos_x + rectwidth)) &&
        	    (sy >= (VA_BACK_PORCH + sympos_y)) &&
        	    (sy < (VA_BACK_PORCH + sympos_y + rectheight));
		end else begin
			// Don't draw anything
			rectangle = 1'b0;
		end
    end

    // Creating pixel colors
    localparam backcolor_r = 4'h1;
    localparam backcolor_g = 4'h4;
    localparam backcolor_b = 4'h2;

	localparam blackcolor = 4'h0;
    logic [3:0] pixcolor_r, pixcolor_g, pixcolor_b;
    always_comb begin
		if (is_sym_mode) begin
        	pixcolor_r = (rectangle) ? rectcolor_r : backcolor_r;
        	pixcolor_g = (rectangle) ? rectcolor_g : backcolor_g;
        	pixcolor_b = (rectangle) ? rectcolor_b : backcolor_b;
		end else begin
			// Draw a black screen until symbol mode
			pixcolor_r = blackcolor; 
			pixcolor_g = blackcolor;
			pixcolor_b = blackcolor;
		end
    end

    localparam black_pix = 4'h0;
    always_comb begin
        dispcolor_r = (de) ? pixcolor_r : black_pix;
        dispcolor_g = (de) ? pixcolor_g : black_pix;
        dispcolor_b = (de) ? pixcolor_b : black_pix;
    end
endmodule
