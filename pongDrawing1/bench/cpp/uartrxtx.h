#ifndef UARTTXRX
#define UARTTXRX

#include <string>
#include "uartsim.h"

class UartRxTx {
protected:
	VerilatedVcdC* tfp;
	unsigned uart_setup = 868;
	unsigned int clocks = 0;
public:	
	UARTSIM *uart;
	UartRxTx(void);
	~UartRxTx(void);
	bool isTxBusy(void);
	void uartTx(std::string msg);
	bool isRxData(void);
	void uartSimRx(Testbench* testbench);
};

#endif
