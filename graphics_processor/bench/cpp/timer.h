
#ifndef TIMER
#define TIMER

#include <thread>
#include <chrono>

class timer {
private:
	std::chrono::time_point<std::chrono::high_resolution_clock> startTime;
public:
	void startTimer(void);
	long long getDuration(void);
};

void waitMS(int ms);

#endif
