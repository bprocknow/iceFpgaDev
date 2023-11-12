
IceFpgaDev is a project to create a small fpga graphics processor with a UART interface

					---- Rectangle Project ----

The rectangle project renders a rectangle in the middle of the display.  It colors the rest
of the display a specified color.

					---- Graphics Processor Project ----

The graphics processor project uses commands specified in the uart interface control document
(uartICD.txt) to display symbols on the display.  The FPGA has two modes, program and symbol 
mode.  Program mode allows commands to specify attributes about symbols, and does not render
anything.  These symbols are indexed with a symbol ID.  The system can then be moved into symbol
mode, which allows the user to render these symbols using their symbol ID at a specific 
position on the display.  When rendering the symbols in symbol mode, the symbol attributes will
be used to draw the symbol.

Up to 127 symbols can be drawn at a time on a frame.  After each frame has finished, the FPGA 
will send an interrupt back to the controller to indicate that it can begin sending the next
frame symbol messages.  

 					---- High-Level Overview of Graphics Processor----

The FPGA operates with inputs from a uart pin.  The FPGA uses a caching system to process 
commands from UART.  The first layer processes the UART pin signals into bytes.  
The second layer uses the bytes and creates packets based on the command type.  
The third layer uses three buffers to store the commands for future use.  

The three buffers of the third layer of the caching system stores data from the inputted packets.
There is a buffer that holds the color data of the symbol, a buffer for the dimension data 
of the symbol and a FIFO buffer that holds inputted symbol drawing commands, which 
contain the symbol position.

The color and dimension data buffers are indexed by the symbol ID.  The symbol FIFO is filled
as packets come in.  When the symbol FIFO contains data, it is processed as quickly as possible
to be used to render to the display.  The symbol ID from the symbol FIFO is used to access the 
two program buffers (color, dimension data) in order to correctly draw it on the display.

The actual rendering of symbols on the display works with a front and back framebuffer, which is 
the last layer of caching.  The framebuffers stores the symbol ID instead of pixel color data. 
The symbol ID takes up less bits in the framebuffer, and can be used to access the color 
programming buffer to get the 12-bit color of the pixel.  

As symbol drawing packets are pulled from the symbol FIFO, the position of the symbol, along 
with the dimension of the symbol from the dimension programming buffer, are used to set the 
back buffer to the symbol ID currently being drawn.  When the back and front buffer swap the 
symbol ID contained in the framebuffer is used to read the color data from the color 
programming buffer and render the symbol.  

The frame is cleared while the front buffer is being displayed.  This is done by storing the 
symbol ID of the current pixel being rendered, then clearing the pixel region from the 
framebuffer while drawing the frame.

					---- Dependencies ----

To build this project, install the dependencies yosys, nextpnr, icestorm tools.  To build the 
simulated FPGA (testbench), install Verilator and SDL.
