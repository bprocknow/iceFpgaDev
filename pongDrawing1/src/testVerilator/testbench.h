#ifndef TESTBENCH
#define TESTBENCH

template <class MODULE> class Testbench {
protected:
    // initialize Verilog module
    MODULE* top;
public:
	Testbench();
	~Testbench();
	virtual void reset();
	virtual void tick();
	virtual bool pollQuit();
};

#endif
