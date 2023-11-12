
#ifndef RENDERBENCH
#define RENDERBENCH

#include "Vsim_graphics.h"
#include "testbench.h"

// screen dimensions
#define H_RES 640
#define H_FRONT_PORCH 1
#define H_SYNC_WIDTH 0
#define H_BACK_PORCH 1
#define H_TOT_PIX (H_RES + H_FRONT_PORCH + H_SYNC_WIDTH + H_BACK_PORCH)

#define V_RES 480
#define V_FRONT_PORCH 0
#define V_SYNC_WIDTH 1
#define V_BACK_PORCH 1
#define V_TOT_PIX (V_RES + V_FRONT_PORCH + V_SYNC_WIDTH + V_BACK_PORCH)

//#define H_RES 640
//#define H_FRONT_PORCH 16
//#define H_SYNC_WIDTH 96
//#define H_BACK_PORCH 48
//#define H_TOT_PIX (H_RES + H_FRONT_PORCH + H_SYNC_WIDTH + H_BACK_PORCH)
//
//#define V_RES 480
//#define V_FRONT_PORCH 10
//#define V_SYNC_WIDTH 2
//#define V_BACK_PORCH 33
//#define V_TOT_PIX (V_RES + V_FRONT_PORCH + V_SYNC_WIDTH + V_BACK_PORCH)

#define MIN_PIX_SZ 4

#define H_RENDR (H_RES / MIN_PIX_SZ)
#define V_RENDR (V_RES / MIN_PIX_SZ)

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

	Pixel screenbuffer[H_TOT_PIX * V_TOT_PIX];

	bool isNewFrame(Testbench& testbench);
	void updatePixel(Testbench& testbench);

public:
	Render(void);
	~Render(void);
	void renderFrame(Testbench& testbench);
	float getAveFps(void);
};
#endif

