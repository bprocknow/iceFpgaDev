
#include "tracebench.h"

#define VCD_FILE "top_pong.vcd"

Tracebench::Tracebench() {

	Verilated::traceEverOn(true);
	tfp = new VerilatedVcdC;
	top->trace(tfp, 99);
	tfp->open(VCD_FILE);
}

Tracebench::~Tracebench() {
	tfp->close();
	delete tfp;
}

void Tracebench::tick() {

	// Positive edge
	top->i_clk = 1;
	top->eval();
	tfp->dump(10*tickcount);

	// Negative edge	
	top->i_clk = 0;
	top->eval();
	tfp->dump(10*tickcount + 5);
	//tfp->flush();

	tickcount++;
}

