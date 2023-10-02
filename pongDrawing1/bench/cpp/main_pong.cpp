#include <SDL2/SDL.h>
#include <iostream>
#include <verilated.h>
#include "Vtesttx.h"
#include "testbench.h"
#include "tracebench.h"
//#include "render.h"
#include "uartrxtx.h"

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);

//    Pixel screenbuffer[H_RES*V_RES];

    printf("Simulation running. Press 'Q' in simulation window to quit.\n\n");

//	Render render;
	Testbench *testbench = new Tracebench;		// Add trace functionality to testbench
	UartRxTx *uart = new UartRxTx();
	
	testbench->reset();


    // initialize frame rate
    uint64_t start_ticks = SDL_GetPerformanceCounter();
    uint64_t frame_count = 0;

	int i = 0;
    // main loop
    while (i < 16*32*868) {
		i++;
        // cycle the clock
		testbench->tick();
		
		(*(uart->uart))(testbench->top->o_uart_tx);
//		uart->uartSimRx(testbench);
		
//        // update pixel if not in blanking interval
//		render.updatePixel(screenbuffer);
//
//        // update texture once per frame (in blanking)
//		if (render.isNewFrame()) {
//			render.renderFrame(screenbuffer);
//            frame_count++;
//        }

        // check for quit event
		if (testbench->pollQuit()) {
			break;
		}

    }

    // calculate frame rate
    uint64_t end_ticks = SDL_GetPerformanceCounter();
    double duration = ((double)(end_ticks-start_ticks))/SDL_GetPerformanceFrequency();
    double fps = (double)frame_count/duration;
    printf("Frames per second: %.1f\n", fps);

	delete testbench;

    return 0;
}

