#include <SDL.h>
#include <iostream>
#include <verilated.h>
#include "Vtop_pong.h"
#include "testbench.h"
#include "renderbench.h"

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);

    Pixel screenbuffer[H_RES*V_RES];

    printf("Simulation running. Press 'Q' in simulation window to quit.\n\n");

	RenderBench renderBench;
	renderBench.reset();

    // initialize frame rate
    uint64_t start_ticks = SDL_GetPerformanceCounter();
    uint64_t frame_count = 0;

    // main loop
    while (1) {
        // cycle the clock
		renderBench.tick();

        // update pixel if not in blanking interval
		renderBench.updatePixel(screenbuffer);

        // update texture once per frame (in blanking)
		if (renderBench.isNewFrame()) {
            // check for quit event
			if (renderBench.pollQuit()) {
				break;
			}

			renderBench.renderFrame(screenbuffer);
            frame_count++;
        }
    }

    // calculate frame rate
    uint64_t end_ticks = SDL_GetPerformanceCounter();
    double duration = ((double)(end_ticks-start_ticks))/SDL_GetPerformanceFrequency();
    double fps = (double)frame_count/duration;
    printf("Frames per second: %.1f\n", fps);

    return 0;
}

