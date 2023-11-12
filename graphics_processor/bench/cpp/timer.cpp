
#include "timer.h"

void timer::startTimer() {
	startTime = std::chrono::high_resolution_clock::now();
}

long long timer::getDuration() {
	
	std::chrono::time_point<std::chrono::high_resolution_clock> currTime = std::chrono::high_resolution_clock::now();

	return std::chrono::duration_cast<std::chrono::milliseconds>(currTime - startTime).count();
}

void waitMS(int ms) {
	std::this_thread::sleep_for(std::chrono::milliseconds(500));
}
