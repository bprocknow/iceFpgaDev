#include <arpa/inet.h>
#include <unistd.h>
#include <iostream>
#include <sys/socket.h>
#include "clientuart.h"

/* Open a socket to the simulation server
*/
ClientUart::ClientUart(int uartPort) {

	struct sockaddr_in addr;
	
	addr.sin_family = AF_INET;
	addr.sin_addr.s_addr = htonl(INADDR_LOOPBACK);
	addr.sin_port = htons(uartPort);

	clientSocket = socket(AF_INET, SOCK_STREAM, 0);
	if (clientSocket < 0) {
		std::cerr << "Could not open client socket" << std::endl;
		exit(EXIT_FAILURE);
	}

	if (connect(clientSocket, (struct sockaddr*)&addr, sizeof(addr)) == -1) {
		std::cerr << "Could not connect socket to simulation" << std::endl;
		exit(EXIT_FAILURE);
	}
}

/* Clean up resources from ClientUart 
*/
ClientUart::~ClientUart() {
	close(clientSocket);
}

/* Write message to server simulation socket
*/
void ClientUart::wrToServer(char *msg, int len) {

	if (write(clientSocket, msg, len) != len) {
		std::cerr << "Error occurred while writing to the simulation" << std::endl;
	}
}

/* Read message from server simulation socket
*/
void ClientUart::rdFromServer(char *buf, int size) {

	if (read(clientSocket, buf, size) < 0) {
		std::cerr << "Error reading data from the simulation" << std::endl;
	}	
}
