#include <SDL.h>
#include "testbench.h"

template <class MODULE>
Testbench<MODULE>::Testbench() {
	top = new MODULE;
}

template <class MODULE>
Testbench<MODULE>::~Testbench() {
    top->final();
    delete top;
}

template <class MODULE>
void Testbench<MODULE>::reset() {
    top->btn_rst = 1;
    top->pix_clk = 0;
    top->eval(); 
    top->pix_clk = 1;
    top->eval(); 
    top->btn_rst = 0;
    top->pix_clk = 0;
    top->eval();
}

template <class MODULE>
void Testbench<MODULE>::tick() {
        top->pix_clk = 1;
        top->eval(); 
        top->pix_clk = 0;
        top->eval();
}

template <class MODULE>
bool Testbench<MODULE>::pollQuit() {
    SDL_Event e;
    if (SDL_PollEvent(&e)) {
        if (e.type == SDL_QUIT) {
            return true;
        }
    }
    return false;
}
