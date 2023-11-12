#include <SDL2/SDL.h>
#include <iostream>
#include <time.h>
#include <verilated.h>
#include <signal.h>
#include <chrono>
#include "Vsim_graphics.h"
#include "testbench.h"
#include "tracebench.h"
#include "uartsim.h"
#include "clientinterface.h"
#include "render.h"
#include "timer.h"

const int uartPort = 50020;
const int divisor = 868;		// Uart clock divisor
volatile sig_atomic_t isChildSigterm = 0;

void handle_sigterm(int signum) {
	// End and cleanup the child process
	isChildSigterm = 1;
}

/* This is the simulation main loop process.  It takes input from the main loop and acts as the FPGA
*/
void sim_main_loop(void) {

	struct sigaction sa;

	// Setup signal handler to end process
	sa.sa_handler = handle_sigterm;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	sigaction(SIGTERM, &sa, NULL);

	Testbench testbench;
	UARTSIM *uart = new UARTSIM(uartPort);
	uart->setup(divisor);
	Render render;

	testbench.top->i_setup = divisor;
	testbench.reset();

    printf("Simulation running\n\n");

	while(!isChildSigterm) {

		testbench.tick();

		render.renderFrame(testbench);

		// Port input goes to simulated i_uart_rx, simulated o_uart_tx goes to write port
		testbench.top->i_uart_rx = (*uart)(testbench.top->o_uart_tx);

		if (testbench.pollQuit()) {
			break;
		}
	}

    printf("Average frames per second: %.1f\n", render.getAveFps());

	delete uart;

	exit(0);
}

/*  This is the main loop process.  It acts as everything external to the FPGA, feeding input and 
	processing output.  
*/
int main(int argc, char* argv[]) {

    Verilated::commandArgs(argc, argv);

	// Start the simulated FPGA process
	pid_t child_pid = fork();
	if (child_pid < 0) {
		std::cerr << "Forking process failed" << std::endl;
		exit(EXIT_FAILURE);
	}
	if (child_pid == 0) {
		// Child process
		sim_main_loop();
	}

	sleep(1);

	ClientInterface cIface(uartPort);

	std::cout << "Writing to simulation:" << std::endl;	

	sleep(1);

	cIface.ProgramSymbol(1, 10, 10, 0xF, 0x0, 0xF);

	std::cout<<"Setting symbol mode"<<std::endl;

	cIface.SetSymMode();

	timer processTimer;

	processTimer.startTimer();

	long long processDurationMs = 15000;

	int xPos = 5;

	while (processTimer.getDuration() < processDurationMs) {

		cIface.DrawSymbol(1, xPos, 10);

		xPos += 10;
		if (xPos > H_RENDR) {
			xPos = 0;
		}
	}

	kill(child_pid, SIGTERM);
	
    return 0;
}

