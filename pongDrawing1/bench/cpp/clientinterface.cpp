
#include <iostream>
#include "clientinterface.h"
#include "render.h"

#define HEADER_BYTE 0xF5
#define PROG_CMD_TYPE 0x01
#define SET_SYM_MODE_CMD_TYPE 0x02
#define DRAW_SYM_CMD_TYPE 0x3

void ClientInterface::ProgramSymbol(uint8_t symId, uint16_t symWidth, uint16_t symHeight, uint8_t color_r, uint8_t color_g, uint8_t color_b) {

	uint8_t buf[9];

	symWidth--;
	symHeight--;

	if (symWidth > H_RENDR || symHeight > V_RENDR) {
		std::cout << "Symbol size out of range" << std::endl;
		return;
	}

	buf[0] = HEADER_BYTE;
	buf[1] = PROG_CMD_TYPE;
	buf[2] = symId + 1;
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

void ClientInterface::DrawSymbol(uint8_t symId, uint16_t symPosX, uint16_t symPosY) {

	uint8_t buf[7];

	if (symPosX > H_RENDR || symPosY > V_RENDR) {
		std::cout << "Drawing symbol out of range" << std::endl;
		return;
	}

	buf[0] = HEADER_BYTE;
	buf[1] = DRAW_SYM_CMD_TYPE;
	buf[2] = symId + 1;
	buf[3] = symPosX & 0xFF;
	buf[4] = (symPosX >> 8) & 0xFF;
	buf[5] = symPosY & 0xFF;
	buf[6] = (symPosY >> 8) & 0xFF;

	wrToServer(buf, sizeof(buf));

	return;
}
