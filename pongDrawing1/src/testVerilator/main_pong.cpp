#include <SDL.h>
#include <iostream>
#include <verilated.h>
#include "Vtop_pong.h"
#include "testbench.h"

// screen dimensions
const int H_RES = 640;
const int V_RES = 480;
const int HA_BACK_PORCH = 48;
const int VA_BACK_PORCH = 33;

typedef struct Pixel {  // for SDL texture
    uint8_t a;  // transparency
    uint8_t b;  // blue
    uint8_t g;  // green
    uint8_t r;  // red
} Pixel;

class TestRender : public Testbench {
private:
	SDL_Window* sdl_window = NULL;
	SDL_Renderer* sdl_renderer = NULL;
	SDL_Texture* sdl_texture = NULL;

public:
	TestRender() {
    	if (SDL_Init(SDL_INIT_VIDEO) < 0) {
    	    printf("SDL init failed.\n");
			exit(1);
    	}

		sdl_window = SDL_CreateWindow("Square", SDL_WINDOWPOS_CENTERED,
		    SDL_WINDOWPOS_CENTERED, H_RES, V_RES, SDL_WINDOW_SHOWN);
		if (!sdl_window) {
		    printf("Window creation failed: %s\n", SDL_GetError());
			exit(1);
		}
		
		sdl_renderer = SDL_CreateRenderer(sdl_window, -1,
		    SDL_RENDERER_ACCELERATED | SDL_RENDERER_PRESENTVSYNC);
		if (!sdl_renderer) {
		    printf("Renderer creation failed: %s\n", SDL_GetError());
			exit(1);
		}
		
		sdl_texture = SDL_CreateTexture(sdl_renderer, SDL_PIXELFORMAT_RGBA8888,
		    SDL_TEXTUREACCESS_TARGET, H_RES, V_RES);
		if (!sdl_texture) {
		    printf("Texture creation failed: %s\n", SDL_GetError());
			exit(1);
		}
	}
	~TestRender() {
    	SDL_DestroyTexture(sdl_texture);
    	SDL_DestroyRenderer(sdl_renderer);
    	SDL_DestroyWindow(sdl_window);
    	SDL_Quit();
	}

	bool isNewFrame() {
        if (this->top->sdl_sy == V_RES && this->top->sdl_sx == 0) {
			return true;
		}

		return false;
	}

	void updatePixel (Pixel* screenbuffer) {
        if (this->top->sdl_de) {
    		Pixel* p = &screenbuffer[(this->top->sdl_sy - VA_BACK_PORCH)*H_RES + (this->top->sdl_sx - HA_BACK_PORCH)];
    		p->a = 0xFF;  // transparency
    		p->b = this->top->sdl_b;
    		p->g = this->top->sdl_g;
    		p->r = this->top->sdl_r;
		}
	}

	void renderFrame(Pixel* screenbuffer) {
    	SDL_UpdateTexture(sdl_texture, NULL, screenbuffer, H_RES*sizeof(Pixel));
    	SDL_RenderClear(sdl_renderer);
    	SDL_RenderCopy(sdl_renderer, sdl_texture, NULL, NULL);
    	SDL_RenderPresent(sdl_renderer);
	}
};

int main(int argc, char* argv[]) {
    Verilated::commandArgs(argc, argv);

    Pixel screenbuffer[H_RES*V_RES];

    printf("Simulation running. Press 'Q' in simulation window to quit.\n\n");

	TestRender renderBench;
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

