#ifndef TESTBENCH
#define TESTBENCH

#include "SDL2/SDL.h"
#include "Vtesttx.h"

class Testbench {
protected:
	unsigned int tickcount;

    // reference SDL keyboard state array: https://wiki.libsdl.org/SDL_GetKeyboardState
    const Uint8 *keyb_state;
public:
    // initialize Verilog module
    Vtesttx* top;

    Testbench();
    virtual ~Testbench();
    virtual void reset(void);
    virtual void tick(void);
    virtual bool pollQuit(void);
};

#endif
