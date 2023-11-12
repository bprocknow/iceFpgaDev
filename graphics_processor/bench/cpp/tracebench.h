
#ifndef TRACEBENCH
#define TRACEBENCH

#include "verilated_vcd_c.h"
#include "testbench.h"

class Tracebench : public Testbench {
protected:
	VerilatedVcdC* tfp;

public:
	Tracebench();
	virtual ~Tracebench();
	virtual void tick(void);
};

#endif
