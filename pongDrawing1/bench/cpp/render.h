
#ifndef RENDERBENCH
#define RENDERBENCH

#include "testbench.h"

// screen dimensions
const int H_RES = 400;
const int V_RES = 300;
const int VA_BACK_PORCH = 1;		// Limit downtimes for more fps
const int HA_BACK_PORCH = 1;

typedef struct Pixel {  // for SDL texture
    uint8_t a;  // transparency
    uint8_t b;  // blue
    uint8_t g;  // green
    uint8_t r;  // red
} Pixel;


class Render {
private:
	// Keep statistics on frames
	uint64_t frame_count;
	uint64_t start_ticks;
	
    SDL_Window* sdl_window = NULL;
    SDL_Renderer* sdl_renderer = NULL;
    SDL_Texture* sdl_texture = NULL;

	Pixel screenbuffer[H_RES * V_RES];

	bool isNewFrame(Testbench& testbench);
	void updatePixel(Testbench& testbench);

public:
	Render(void);
	~Render(void);
	void renderFrame(Testbench& testbench);
	float getAveFps(void);
};
#endif

