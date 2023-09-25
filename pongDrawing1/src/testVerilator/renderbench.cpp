
#include "renderbench.h"

RenderBench::RenderBench() {
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

RenderBench::~RenderBench() {
    SDL_DestroyTexture(sdl_texture);
    SDL_DestroyRenderer(sdl_renderer);
    SDL_DestroyWindow(sdl_window);
    SDL_Quit();
}

bool RenderBench::isNewFrame() {
    if (this->top->sdl_sy == V_RES && this->top->sdl_sx == 0) {
        return true;
    }

    return false;
}

void RenderBench::updatePixel (Pixel* screenbuffer) {
    if (this->top->sdl_de) {
        Pixel* p = &screenbuffer[(this->top->sdl_sy - VA_BACK_PORCH) * H_RES + (this->top->sdl_sx - HA_BACK_PORCH)];
        p->a = 0xFF;  // transparency
        p->b = this->top->sdl_b;
        p->g = this->top->sdl_g;
        p->r = this->top->sdl_r;
    }
}

void RenderBench::renderFrame(Pixel* screenbuffer) {
    SDL_UpdateTexture(sdl_texture, NULL, screenbuffer, H_RES*sizeof(Pixel));
    SDL_RenderClear(sdl_renderer);
    SDL_RenderCopy(sdl_renderer, sdl_texture, NULL, NULL);
    SDL_RenderPresent(sdl_renderer);
}

