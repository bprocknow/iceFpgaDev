#include <SDL2/SDL.h>
#include <iostream>
#include "testbench.h"

Testbench::Testbench() {
	top = new Vtesttxrx();

	keyb_state = SDL_GetKeyboardState(NULL);
}

Testbench::~Testbench() {
    top->final();
    delete top;
}

void Testbench::reset() {
	// There is no reset button now
	return;
}

void Testbench::tick() {
        top->i_clk = 1;
        top->eval(); 
        top->i_clk = 0;
        top->eval();
}

bool Testbench::pollQuit() {
    SDL_Event e;
    if (SDL_PollEvent(&e)) {
        if (e.type == SDL_QUIT) {
            return true;
        }
    }

	if (keyb_state[SDL_SCANCODE_Q]) return true;	// Quit if user presses 'Q'

    return false;
}

