#ifndef TESTBENCH
#define TESTBENCH

template <class MODULE> class Testbench {
protected:
    // initialize Verilog module
    MODULE* top;

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
