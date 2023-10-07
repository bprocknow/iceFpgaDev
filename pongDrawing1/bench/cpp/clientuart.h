#ifndef CLIENTUART
#define CLIENTUART

class ClientUart {
private:
	int clientSocket;
public:
	ClientUart(int uartPort);
	~ClientUart(void);
	void wrToServer(char *msg, int len);
	void rdFromServer(char *buf, int size);
};

#endif
