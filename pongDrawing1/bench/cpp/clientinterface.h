
#ifndef CLIENTIFACE
#define CLIENTIFACE

#include <iostream>
#include "clientuart.h"

/* Implements the FPGA interface per uartICD.txt
*/

class ClientInterface : private ClientUart {
public:
	ClientInterface(int uartPort) : ClientUart(uartPort) {}
	void ProgramSymbol(uint8_t symId, uint16_t symHeight, uint16_t symWidth, uint8_t color_r, uint8_t color_g, uint8_t color_b);
	void SetSymMode(void);
};

#endif
