#ifndef TESTBENCH
#define TESTBENCH

#include "Vtop_pong.h"

class Testbench {
protected:
    // initialize Verilog module
    Vtop_pong* top;

    // reference SDL keyboard state array: https://wiki.libsdl.org/SDL_GetKeyboardState
    const Uint8 *keyb_state;
public:
    Testbench();
    ~Testbench();
    virtual void reset();
    virtual void tick();
    virtual bool pollQuit();
};

#endif
