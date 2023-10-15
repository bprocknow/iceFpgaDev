
#include "render.h"

/* --------------------- Constructor / Destructor -------------- */

Render::Render() {

	frame_count = 0;

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

Render::~Render() {
    SDL_DestroyTexture(sdl_texture);
    SDL_DestroyRenderer(sdl_renderer);
    SDL_DestroyWindow(sdl_window);
    SDL_Quit();
}

/* ------------------- Private Functions ------------------------- */

bool Render::isNewFrame(Testbench& testbench) {
    if (testbench.top->sdl_sy == V_RES && testbench.top->sdl_sx == 0) {
        return true;
    }

    return false;
}

void Render::updatePixel (Testbench& testbench) {
    if (testbench.top->sdl_de) {
		Pixel* p = &screenbuffer[(testbench.top->sdl_sy - VA_BACK_PORCH) * H_RES + (testbench.top->sdl_sx - HA_BACK_PORCH)];
        p->a = 0xFF;  // transparency
        p->b = testbench.top->sdl_b;
        p->g = testbench.top->sdl_g;
        p->r = testbench.top->sdl_r;
    }
}

/* --------------------- Public functions ---------------------------- */

void Render::renderFrame(Testbench& testbench) {

	// Start gathering frame statistics on first render
	static bool startRender = false;
	if (!startRender) {
		startRender = true;
		start_ticks = SDL_GetPerformanceCounter();
	}
	
	updatePixel(testbench);

	
	if (isNewFrame(testbench)) {
    	SDL_UpdateTexture(sdl_texture, NULL, screenbuffer, H_RES*sizeof(Pixel));
    	SDL_RenderClear(sdl_renderer);
    	SDL_RenderCopy(sdl_renderer, sdl_texture, NULL, NULL);
    	SDL_RenderPresent(sdl_renderer);
	
		frame_count++;
	}
}

float Render::getAveFps() {
	uint64_t end_ticks = SDL_GetPerformanceCounter();
	float duration = ((float)(end_ticks - start_ticks)) / SDL_GetPerformanceFrequency();
	float fps = (float)frame_count / duration;

	return fps;
}

