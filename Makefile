CFLAGS=-Wall
#CFLAGS=
LFLAGS=-L/usr/lib -lssl -lcrypto

.PHONY: all
all: ssl_server

ssl_server: ssl_server.c Makefile
	gcc $(CFLAGS) -o ssl_server ssl_server.c $(LFLAGS)

.PHONY: gencert
gencert:
	openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem

clean:
	rm ./ssl_server
