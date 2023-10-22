#ifndef CLIENTUART
#define CLIENTUART

class ClientUart {
private:
	int clientSocket;
public:
	ClientUart(int uartPort);
	virtual ~ClientUart(void);
	void wrToServer(uint8_t *msg, int len);
	void rdFromServer(uint8_t *buf, int size);
};

#endif
