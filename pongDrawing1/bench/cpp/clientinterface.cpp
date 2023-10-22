
#include <iostream>
#include "clientinterface.h"

#define HEADER_BYTE 0xF5
#define PROG_CMD_TYPE 0x01
#define SET_SYM_MODE_CMD_TYPE 0x02

void ClientInterface::ProgramSymbol(uint8_t symId, uint16_t symHeight, uint16_t symWidth, uint8_t color_r, uint8_t color_g, uint8_t color_b) {

	uint8_t buf[9];

	buf[0] = HEADER_BYTE;
	buf[1] = PROG_CMD_TYPE;
	buf[2] = symId;
	buf[3] = symHeight & 0xFF;
	buf[4] = (symHeight >> 8) & 0xFF;
	buf[5] = symWidth & 0xFF;
	buf[6] = (symWidth >> 8) & 0xFF;
	buf[7] = (color_r & 0x0F) + ((color_g & 0x0F) << 4);
	buf[8] = (color_b & 0x0F);

	wrToServer(buf, sizeof(buf));

	return;
}

void ClientInterface::SetSymMode() {

	uint8_t buf[2];

	buf[0] = HEADER_BYTE;
	buf[1] = SET_SYM_MODE_CMD_TYPE;

	wrToServer(buf, sizeof(buf));

	return;
}
