
/* 	
	The framebuffer module inputs incoming communication packets containing commands to 
	draw symbols.  
   	Using the commands and current pixel position, the module calculates the pixel color
   	of several pixels that can be used for rendering.

	The module buffers commands into three buffers:
	1. Program Color Attribute buffer, which is indexed by the symbols ID
	2. Program Width and Height attribute buffer, also indexed by symbol ID
	3. Draw Symbol FIFO, which is used in combination with symbol attributes to find the color of the pixel

	There are SPRAM buffers that contain the entire frame, a back and front frame.  
	The back frame is generated from the communication input commands and program buffers,
	while the front buffer is used to show data on the display.  
	When a vsync occurs, the buffers flip, and the new back buffer is written to. 

	SPRAM contains two framebuffers, a front and back buffer.  
	The front buffer is used to generate the pixel values outputted to render.
	The back buffer is written to using the program dimension buffer and symbol buffer.

	There are two SPRAM buffers per framebuffer, a total of four SPRAM buffers.

	The framebuffer only stores total pixels / (MIN_PIX_SZ * MIN_PIZ_SZ) units.  Each unit 
	holds a symbol ID that can be used to access the color data for the pixels of the unit
	from the program color buffer.  SPRAM is not large enough to store the entire frame.

	The framebuffers are cleared while the front buffer is being rendered.  This is done
	by clearing the entire unit as the last pixel in the unit is being rendered.  The
	symbol ID of this pixel is already known and is used to access the program color
	buffer for the color bits.  

	The back buffer can be written to as soon as the front buffer has completely rendered the 
	image, allowing the clock cycles in porch/sync areas to be used to render to the buffer that
	has just been used to render the image. 
*/
module framebuf_manager #(
	parameter MAX_PAYLD_PKT_BITS, 
	parameter DRAW_PAYLD_PKT_BITS, 
	parameter NUM_SYM_SUPPTD_BITS,
	parameter BITS_PER_COLOR
	) (
	input logic i_clk,
	input logic n_btn_rst,
	input logic is_sym_mode,
	input logic valid_pld_packet,
	/* verilator lint_off UNUSEDSIGNAL */
	input logic [MAX_PAYLD_PKT_BITS-1:0] pld_packet_data,
	input logic draw_en,
	input logic [15:0] sx,
	input logic [15:0] sy,
	output logic [BITS_PER_COLOR-1:0] dispcolor_r,
	output logic [BITS_PER_COLOR-1:0] dispcolor_g,
	output logic [BITS_PER_COLOR-1:0] dispcolor_b
	);

	`include "display_timings.sv"

	localparam COLOR_DATA_BITS = 12;
	localparam DIMENSION_DATA_BITS = 32;
	// The entire HA_ACTIVE_PIX by VA_ACTIVE_PIX image cannot be stored in SPRAM, there is
	// not enough room.  HA_ACTIVE_PIX / MIN_PIX_SZ * VA_ACTIVE_PIX / MIN_PIX_SZ is the 
	// number of pixels actually used to render the image
	localparam MIN_PIX_SZ = 4;
	localparam HA_RENDERED_PIX = HA_ACTIVE_PIX / MIN_PIX_SZ;
	localparam VA_RENDERED_PIX = VA_ACTIVE_PIX / MIN_PIX_SZ;
	localparam SYM_FIFO_SZ_BITS = 5;

	// Get the symbol ID from the payload packet data
	wire logic [(NUM_SYM_SUPPTD_BITS-1):0] input_sym_id;
	assign input_sym_id = pld_packet_data[(NUM_SYM_SUPPTD_BITS-1):0];

	// Enable writing for the symbol buffer on symbol mode and valid input.
	logic sym_mode_we;
	logic prog_mode_we;
	assign sym_mode_we = (is_sym_mode && valid_pld_packet) ? 1'b1 : 1'b0;
	assign prog_mode_we = (!is_sym_mode && valid_pld_packet) ? 1'b1 : 1'b0;

	/* ----------- Program Buffer ------------ */

	logic prog_color_re;		// Read enable for color program buffer data
	logic prog_dimensions_re;	// Read enable for dimensions program buffer data
	logic [(NUM_SYM_SUPPTD_BITS-1):0] prog_color_raddr;
	logic [(COLOR_DATA_BITS-1):0] prog_color_rdata;
	// Use the symbol ID from the tail of the symbol FIFO to read the dimensions 
	// of the symbol from the program buffer
	// Must be 16-bits for SPRAM input.  Only NUM_SYM_SUPPTD_BITS are used.
	logic [15:0] drawsym_pkt_sym_id;
	logic [(DIMENSION_DATA_BITS-1):0] prog_dimensions_rdata;

	// Write program attribute data to a buffer that is indexed by the symbol ID
	RAM256X12 prog_buf_color_inst (
		.i_clk(i_clk),
		.we(prog_mode_we),
		// Put the color bits from the packet in the buffer
		// Symbol ID is used as the address of the data
		.waddr(input_sym_id),
		.wdata(pld_packet_data[51:40]),
		.re(is_sym_mode && prog_color_re),
		.raddr(prog_color_raddr),
		.rdata(prog_color_rdata)
	);

	// Write program attribute data to a buffer that is indexed by the symbol ID
	RAM256X32 prog_buf_dimensions_inst (
		.i_clk(i_clk),
		.we(prog_mode_we),
		// Put the color bits from the packet in the buffer
		// Symbol ID is used as the address of the data
		.waddr(input_sym_id),
		.wdata(pld_packet_data[39:8]),
		.re(is_sym_mode && prog_dimensions_re),
		.raddr(drawsym_pkt_sym_id[(NUM_SYM_SUPPTD_BITS-1):0]),
		.rdata(prog_dimensions_rdata)
	);

	/* ----------- Symbol FIFO Buffer -------- */

	logic sym_re;
	logic [(SYM_FIFO_SZ_BITS-1):0] sym_raddr_tail;
	logic [(DRAW_PAYLD_PKT_BITS-1):0] sym_rdata;		// Tail of the FIFO / Where to read the next data
	logic [(SYM_FIFO_SZ_BITS-1):0] sym_waddr_head;	// Head of the FIFO / Where to write next data
	logic [(SYM_FIFO_SZ_BITS-1):0] sym_nxthead;	// Next position of the FIFO
	logic symFifoIsFull, symFifoIsEmpty;

	assign sym_nxthead = sym_waddr_head + 1;

	// When the FIFO is full, indicate to the master device that it cannot send data
	assign symFifoIsFull = (sym_nxthead == sym_raddr_tail) ? 1'b1 : 1'b0;
	assign symFifoIsEmpty = (sym_raddr_tail == sym_waddr_head) ? 1'b1 : 1'b0;

	// Write to Symbol Buffer
	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			// Clear FIFO on reset
			sym_waddr_head <= {(SYM_FIFO_SZ_BITS){1'd0}};
		end else begin
			// Only use the FIFO when there is valid data and the system is in symbol mode
			if (sym_mode_we) begin
				// Edge case - MC doesn't respect the symFifoIsFull signal and sends data anyways
				// Over-write the current data
				if (!symFifoIsFull) begin		// Only move head on not full FIFO
					sym_waddr_head <= sym_nxthead;
				end
			end
		end
	end

	CommandBuffer #(DRAW_PAYLD_PKT_BITS, SYM_FIFO_SZ_BITS)
	sym_buf_inst (
		.i_clk(i_clk),
		.n_btn_rst(n_btn_rst),	
		.we(sym_mode_we),
		.waddr(sym_waddr_head),
		.wdata(pld_packet_data[(DRAW_PAYLD_PKT_BITS-1):0]),	// Store the entire packet in the FIFO
		.re(sym_re),
		.raddr(sym_raddr_tail),
		.rdata(sym_rdata)
	);

	/* ------------- Symbol Buffer Writes to SPRAM -------- */

	// Buffer for holding the current read data to process
	logic [DRAW_PAYLD_PKT_BITS-1:0] sym_curr_rdata;
	// For each symbol command, keep track of which pixel of the symbol is being drawn
	//  to the back buffer.  The 15th bit indicates whether to use the first or second SPRAM buf
	logic [14:0] rendersym_pix_cntr;
	logic [14:0] drawsym_pix_cntr;

	typedef enum logic [1:0] {
		WAITING_FOR_DATA,
		ASSIGN_DATA,
		PROCESSING_DATA
	} SymReadState;

	SymReadState curr_sym_r_state, next_sym_r_state;

	logic [15:0] currSymSx, currSymSy; // The current pixel value for drawing the symbol to the back framebuffer
	logic isEndSymRow, isEndSymCol, isAtEndSym;
	logic [15:0] symLeftSx;		// The left pixel value of the symbol is x-axis. Input from draw symbol command
	logic [15:0] symTopSy;		// The top pixel value of the symbol in y-axis.  Input from draw symbol command
	logic [15:0] symRightSx;	// The right pixel value of the symbol in x-axis, accounting for the edge of the display
	logic [15:0] symBottomSy;	// The bottom pixel value of the symbol in y-axis, accounting for the edge of the display

	assign drawsym_pix_cntr = currSymSx[14:0] + (currSymSy[14:0] * HA_RENDERED_PIX);

	// Read dimensions from the current symbol packet of the FIFO being processed
	assign drawsym_pkt_sym_id[15:8] = 8'h0;
	assign drawsym_pkt_sym_id[7:0] = sym_curr_rdata[7:0];

	// Stores the 15th bit of rendersym_pix_cntr / drawsym_pix_cntr to indicate 
	// whether to use the first/second SPRAM buffer
	// rendersym_pix_cntr is used for reading from the front buffer (isSecondRBuffer)
	// drawsym_pix_cntr is used for writing to the back buffer (isSecondWBuffer)
	logic isSecondWBuffer, isSecondRBuffer;
	assign isSecondWBuffer = drawsym_pix_cntr[14];
	assign isSecondRBuffer = rendersym_pix_cntr[14];

	logic weFirstBuffer, weSecondBuffer;
	always_comb begin
		weFirstBuffer = (!isSecondWBuffer && (curr_sym_r_state == PROCESSING_DATA)) ? 1'b1 : 1'b0;
		weSecondBuffer = (isSecondWBuffer && (curr_sym_r_state == PROCESSING_DATA)) ? 1'b1 : 1'b0;
	end

	// Assign the bounds of the symbol, accounting for the edge of the display
	// Not used in program mode
	assign symLeftSx = sym_curr_rdata[23:8];
	assign symTopSy = sym_curr_rdata[39:24];
	assign symRightSx = symLeftSx + prog_dimensions_rdata[31:16];
	assign symBottomSy = symTopSy + prog_dimensions_rdata[15:0];

	assign isEndSymRow = (currSymSx >= symRightSx) ? 1'b1 : 1'b0;
	assign isEndSymCol = (currSymSy >= symBottomSy) ? 1'b1 : 1'b0;
	assign isAtEndSym = (isEndSymRow && isEndSymCol);

	logic isLastPixel;
	assign isLastPixel = ((sx == (HA_ACTIVE_PIX + HA_BACK_PORCH)) && (sy == (VA_ACTIVE_PIX + VA_BACK_PORCH)));

	// Read from Symbol FIFO
	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			// Clear FIFO on reset
			sym_raddr_tail <= {(SYM_FIFO_SZ_BITS){1'd0}};
			sym_curr_rdata <= {(DRAW_PAYLD_PKT_BITS){1'd0}};
			curr_sym_r_state <= WAITING_FOR_DATA;
			// 1-based indexing so that at 16383 is the last pixel of the 14-bit SPRAM buffer
			sym_re <= 1'd0;
			currSymSx <= 16'd0;
			currSymSy <= 16'd0;
		end else begin
			if (isLastPixel) begin
				// Clear the symbol FIFO on new frames
				curr_sym_r_state <= WAITING_FOR_DATA;
				sym_raddr_tail <= sym_waddr_head;
				sym_re <= 1'b0;
			end else begin
				case (curr_sym_r_state)
					WAITING_FOR_DATA: begin
						// Wait for symbol FIFO to have a valid data packet to process
						if (!symFifoIsEmpty) begin
							// Read the current tail of the symbol FIFO buffer, 
							// the program buffer data specified by the tail symbol buffer
							// symbol ID, and move to processing state
							curr_sym_r_state <= next_sym_r_state;
							prog_dimensions_re <= 1'b1;
							sym_re <= 1'b1;
							sym_raddr_tail <= sym_raddr_tail + 1;
							sym_curr_rdata <= sym_rdata;
						end
					end
					ASSIGN_DATA: begin
						sym_re <= 1'b0;
						prog_dimensions_re <= 1'b0;
						currSymSx <= symLeftSx;
						currSymSy <= symTopSy;
						curr_sym_r_state <= next_sym_r_state;
					end
					PROCESSING_DATA: begin
						sym_re <= 1'b0;
						prog_dimensions_re <= 1'b0;

						if (isAtEndSym) begin
							curr_sym_r_state <= next_sym_r_state;
						end else if (isEndSymRow) begin
							currSymSx <= symLeftSx;
							currSymSy <= currSymSy + 16'd1;
						end else begin
							currSymSx <= currSymSx + 16'd1;
						end
					end
					// Only two state, default shouldn't happen
					default: curr_sym_r_state <= WAITING_FOR_DATA;
				endcase
			end
		end
	end
	always_comb begin
		next_sym_r_state = curr_sym_r_state;

		case (curr_sym_r_state)
			WAITING_FOR_DATA: next_sym_r_state = ASSIGN_DATA;
			ASSIGN_DATA: next_sym_r_state = PROCESSING_DATA;
			PROCESSING_DATA: next_sym_r_state = WAITING_FOR_DATA;
			default: next_sym_r_state = WAITING_FOR_DATA;
		endcase
	end

	/* -------------- Front / Back Buffer Manager -------- */

	// Keep track of which framebuffer is in the front
	logic isRndrFirstFbuf;
	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			isRndrFirstFbuf <= 1'b1;
		end	else begin
			// Swap the front and back buffer on every new frame
			if (isLastPixel) begin
				isRndrFirstFbuf <= isRndrFirstFbuf ? 1'b0 : 1'b1;
			end
		end
	end
	
	/* ---------- Retrieve color data from front buffer symbol ID data -------- */

	// Calculate the render symbol pixel counter for which pixel is being read from the front buffer
	logic [15:0] row_cntr, col_cntr;
	assign row_cntr = ((sy - VA_BACK_PORCH) / MIN_PIX_SZ);
	assign col_cntr = ((sx - HA_BACK_PORCH) / MIN_PIX_SZ);
	assign rendersym_pix_cntr = col_cntr[14:0] + ((row_cntr[14:0]) * HA_RENDERED_PIX);

	// Output symbol ID of first (f)/second (s) framebuffer, first (f)/second (s) buffer
	/* verilator lint_off UNUSEDSIGNAL */
	logic [15:0] ffb_out, fsb_out, sfb_out, ssb_out;
	always_comb begin
		if (isRndrFirstFbuf) begin
			prog_color_raddr = isSecondRBuffer ? fsb_out[(NUM_SYM_SUPPTD_BITS-1):0] : ffb_out[(NUM_SYM_SUPPTD_BITS-1):0];
		end else begin
			prog_color_raddr = isSecondRBuffer ? ssb_out[(NUM_SYM_SUPPTD_BITS-1):0] : sfb_out[(NUM_SYM_SUPPTD_BITS-1):0];
		end
	end

	/* ------- Clear current unit of front buffer ---------------- */

	logic clearCurrPixel;
	// Indicates whether the current pixel is the last of the MIN_PIX_SZ pixels for the unit
	logic isLastPixX, isLastPixY;
	assign isLastPixX = (((sx - HA_BACK_PORCH) % MIN_PIX_SZ) == (MIN_PIX_SZ - 1)) ? 1'b1 : 1'b0;
	assign isLastPixY = (((sy - VA_BACK_PORCH) % MIN_PIX_SZ) == (MIN_PIX_SZ - 1)) ? 1'b1 : 1'b0;

	always_comb begin
		if (isLastPixX && isLastPixY) begin
			clearCurrPixel = 1'b1;
		end else begin
			clearCurrPixel = 1'b0;
		end
	end

	/* ----------- Assign color from program color buffer ------- */

	// Using the current pixel symbol ID, get the symbol color from the program buffer
	localparam default_color = 4'h5;
	logic [BITS_PER_COLOR-1:0] prog_color_r;
	logic [BITS_PER_COLOR-1:0] prog_color_g;
	logic [BITS_PER_COLOR-1:0] prog_color_b;
	assign prog_color_r = prog_color_rdata[3:0];
	assign prog_color_g = prog_color_rdata[7:4];
	assign prog_color_b = prog_color_rdata[11:8];
	
	always_ff @(posedge i_clk or negedge n_btn_rst) begin
		if (!n_btn_rst) begin
			// Black screen on reset
			dispcolor_r <= {BITS_PER_COLOR{1'd0}};
			dispcolor_g <= {BITS_PER_COLOR{1'd0}};
			dispcolor_b <= {BITS_PER_COLOR{1'd0}};
			prog_color_re <= 1'b0;
		end else begin

			if (is_sym_mode && draw_en) begin
				prog_color_re <= 1'b1;
				dispcolor_r <= prog_color_r;
				dispcolor_g <= prog_color_g;
				dispcolor_b <= prog_color_b;
			end	else begin
				// Nothing to draw yet - still in program mode
				dispcolor_r <= default_color;
				dispcolor_g <= default_color;
				dispcolor_b <= default_color;
			end
		end
	end

	/* ----------- Front / Back Framebuffers -------*/

	// Indicates whether the specified back buffer is being written to
	// For example, is it writing to the first SPRAM buffer of the first framebuffer, which is 
	// currently the back buffer = isWriteFFBB
	logic isWriteFFBB, isWriteFSBB, isWriteSFBB, isWriteSSBB;
	assign isWriteFFBB = (!isRndrFirstFbuf & weFirstBuffer);
	assign isWriteFSBB = (!isRndrFirstFbuf & weSecondBuffer);
	assign isWriteSFBB = (isRndrFirstFbuf & weFirstBuffer);
	assign isWriteSSBB = (isRndrFirstFbuf & weSecondBuffer);

	// Indicates whether to clear the specified address
	// Clear occurs on the front framebuffer, after the data for the pixel unit
	// (MIN_PIX_SZ by MIN_PIX_SZ) has already been read from SPRAM.
	logic isClearFFFB, isClearFSFB, isClearSFFB, isClearSSFB;
	assign isClearFFFB = (isRndrFirstFbuf && !isSecondRBuffer && draw_en && clearCurrPixel);
	assign isClearFSFB = (isRndrFirstFbuf && isSecondRBuffer && draw_en && clearCurrPixel);
	assign isClearSFFB = (!isRndrFirstFbuf && !isSecondRBuffer && draw_en && clearCurrPixel);
	assign isClearSSFB = (!isRndrFirstFbuf && isSecondRBuffer && draw_en && clearCurrPixel);

	// ADDRESS:
	// When front buffer, read using rendersym_pix_cntr
	// When back buffer, write to drawsym_pix_cntr

	// WREN:
	// When front buffer, write only to clear the pixel unit.
	// When back buffer, select the SPRAM buffer to write to based on pixel value
	// using the data from the symbol FIFO

	/* ------- Framebuffer One ------- */

	SB_SPRAM256KA spram_fb_one_inst_one (
		.ADDRESS(isRndrFirstFbuf ? rendersym_pix_cntr[13:0] : drawsym_pix_cntr[13:0]),
		.DATAIN(isRndrFirstFbuf ? 16'd0 : drawsym_pkt_sym_id),
		.MASKWREN(4'b1111),		// Enable all nibbles for writing
		.WREN(isClearFFFB || isWriteFFBB),
		.CHIPSELECT(1'b1),
		.CLOCK(i_clk),
		.STANDBY(1'b0),			// Disble standby mode
		.SLEEP(1'b0),			// Disable sleep mode
		.POWEROFF(1'b1),		// Disable power off (Default low)
		.DATAOUT(ffb_out)
	);

	SB_SPRAM256KA spram_fb_two_inst_two (
		.ADDRESS(isRndrFirstFbuf ? rendersym_pix_cntr[13:0] : drawsym_pix_cntr[13:0]),
		.DATAIN(isRndrFirstFbuf ? 16'd0 : drawsym_pkt_sym_id),
		.MASKWREN(4'b1111),		// Enable all nibbles for writing
		.WREN(isClearFSFB || isWriteFSBB),
		.CHIPSELECT(1'b1),
		.CLOCK(i_clk),
		.STANDBY(1'b0),			// Disble standby mode
		.SLEEP(1'b0),			// Disable sleep mode
		.POWEROFF(1'b1),		// Disable power off (Default low)
		.DATAOUT(fsb_out)
	);

	/* ------- Framebuffer Two ------- */
	
	SB_SPRAM256KA spram_fb_two_inst_one (
		.ADDRESS(isRndrFirstFbuf ? drawsym_pix_cntr[13:0] : rendersym_pix_cntr[13:0]),
		.DATAIN(isRndrFirstFbuf ? drawsym_pkt_sym_id : 16'd0),
		.MASKWREN(4'b1111),		// Enable all nibbles for writing
		.WREN(isClearSFFB || isWriteSFBB),
		.CHIPSELECT(1'b1),
		.CLOCK(i_clk),
		.STANDBY(1'b0),			// Disble standby mode
		.SLEEP(1'b0),			// Disable sleep mode
		.POWEROFF(1'b1),		// Disable power off (Default low)
		.DATAOUT(sfb_out)
	);

	SB_SPRAM256KA spram_fb_one_inst_two (
		.ADDRESS(isRndrFirstFbuf ? drawsym_pix_cntr[13:0] : rendersym_pix_cntr[13:0]),
		.DATAIN(isRndrFirstFbuf ? drawsym_pkt_sym_id : 16'd0),
		.MASKWREN(4'b1111),		// Enable all nibbles for writing
		.WREN(isClearSSFB || isWriteSSBB),
		.CHIPSELECT(1'b1),
		.CLOCK(i_clk),
		.STANDBY(1'b0),			// Disble standby mode
		.SLEEP(1'b0),			// Disable sleep mode
		.POWEROFF(1'b1),		// Disable power off (Default low)
		.DATAOUT(ssb_out)
	);

endmodule
