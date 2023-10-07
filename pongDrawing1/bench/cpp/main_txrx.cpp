#include <SDL2/SDL.h>
#include <iostream>
#include <verilated.h>
#include <signal.h>
#include "Vtesttxrx.h"
#include "testbench.h"
#include "tracebench.h"
#include "uartsim.h"
#include "clientuart.h"

const int uartPort = 50020;
volatile sig_atomic_t isChildSigterm = 0;

void handle_sigterm(int signum) {
	// End and cleanup the child process
	isChildSigterm = 1;
}

/* This is the simulation main loop process.  It takes input from the main loop and acts as the FPGA
*/
void sim_main_loop(void) {

	struct sigaction sa;

    // initialize frame rate
    uint64_t start_ticks = SDL_GetPerformanceCounter();
    uint64_t frame_count = 0;

	// Setup signal handler to end process
	sa.sa_handler = handle_sigterm;
	sigemptyset(&sa.sa_mask);
	sa.sa_flags = 0;
	sigaction(SIGTERM, &sa, NULL);

	Testbench *testbench = new Tracebench;
	UARTSIM *uart = new UARTSIM(uartPort);

	testbench->reset();

    printf("Simulation running\n\n");

	while(!isChildSigterm) {

		testbench->tick();

		// Port input goes to simulated i_uart_rx, simulated o_uart_tx goes to write port
		testbench->top->i_uart_rx = (*uart)(testbench->top->o_uart_tx);

		frame_count++;
	}

    // calculate frame rate
    uint64_t end_ticks = SDL_GetPerformanceCounter();
    double duration = ((double)(end_ticks-start_ticks))/SDL_GetPerformanceFrequency();
    double fps = (double)frame_count/duration;
    printf("Frames per second: %.1f\n", fps);

	delete testbench;
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

	ClientUart cUart(uartPort);

    char buf[] = "Hello World!";

	std::cout << "Writing to simulation: " << buf << std::endl;	

	cUart.wrToServer(buf, sizeof(buf));

	// Wait for simulation to generate response in port
	sleep(1);

    char buffer[100];

	cUart.rdFromServer(buffer, sizeof(buffer));
    std::cout << "Data Recieved from simulation: "<< buffer<<std::endl;

	kill(child_pid, SIGTERM);
	
    return 0;
}

