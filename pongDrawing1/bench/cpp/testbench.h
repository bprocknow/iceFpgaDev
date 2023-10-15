#ifndef TESTBENCH
#define TESTBENCH

#include "SDL2/SDL.h"
#include "Vtestpong.h"

class Testbench {
protected:
	unsigned int tickcount;

    // reference SDL keyboard state array: https://wiki.libsdl.org/SDL_GetKeyboardState
    const Uint8 *keyb_state;
public:
    // initialize Verilog module
    Vtestpong* top;

    Testbench();
    virtual ~Testbench();
    virtual void reset(void);
    virtual void tick(void);
    virtual bool pollQuit(void);
};

#endif
