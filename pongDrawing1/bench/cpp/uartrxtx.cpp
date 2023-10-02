#include <verilatedos.h>
#include "verilated.h"
#include "testbench.h"
#include "uartrxtx.h"

UartRxTx::UartRxTx() {
	
	const int port = 0;
	
	uart = new UARTSIM(port);
	uart->setup(uart_setup);		// Configure baud rate divisor
}

UartRxTx::~UartRxTx() {
	delete uart;	
}

bool UartRxTx::isTxBusy() {
	return false;	
}

void UartRxTx::uartTx(std::string msg) {
	return;
}

bool UartRxTx::isRxData() {
	return false;
}

void UartRxTx::uartSimRx(Testbench *testbench) {
	(*uart)(testbench->top->o_uart_tx);
}

