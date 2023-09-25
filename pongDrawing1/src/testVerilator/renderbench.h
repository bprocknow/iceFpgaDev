
#ifndef RENDERBENCH
#define RENDERBENCH

#include "SDL.h"
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


class RenderBench : public Testbench {
protected:
    SDL_Window* sdl_window = NULL;
    SDL_Renderer* sdl_renderer = NULL;
    SDL_Texture* sdl_texture = NULL;

public:
	RenderBench();
	~RenderBench();
	bool isNewFrame();
	void updatePixel(Pixel *screenbuffer);
	void renderFrame(Pixel *screenbuffer);
};
#endif
