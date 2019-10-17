# Makefile for ssl_server

ifndef OPENSSL_API_COMPAT
    OPENSSL_API_COMPAT_1_1_0 = 0x10100000L
    OPENSSL_API_COMPAT_1_0_0 = 0x10000000L
    OPENSSL_VERSION_1_1_0 = "1.1"
    OPENSSL_VERSION_1_0_0 = "1.0.0"
    OPENSSL_LIB_1_1_0 = "libssl.so."$(OPENSSL_VERSION_1_1_0)
    OPENSSL_LIB_1_0_0 = "libssl.so."$(OPENSSL_VERSION_1_0_0)
    OPENSSL_DIR_USR_LIB = "/usr/lib"
    OPENSSL_DIR_LIB_X86_64 = "/lib/x86_64-linux-gnu"
  ifneq (,$(shell find $(OPENSSL_DIR_USR_LIB) -type f -name $(OPENSSL_LIB_1_1_0) 2> /dev/null))
    OPENSSL_API_COMPAT = $(OPENSSL_API_COMPAT_1_1_0)
    OPENSSL_VERSION = $(OPENSSL_VERSION_1_1_0)
    OPENSSL_LIB = $(OPENSSL_LIB_1_1_0)
    OPENSSL_DIR = $(OPENSSL_DIR_USR_LIB)
  else ifneq (,$(shell find $(OPENSSL_DIR_USR_LIB) -type f -name $(OPENSSL_LIB_1_0_0) 2> /dev/null))
    OPENSSL_API_COMPAT = $(OPENSSL_API_COMPAT_1_0_0)
    OPENSSL_VERSION = $(OPENSSL_VERSION_1_0_0)
    OPENSSL_LIB = $(OPENSSL_LIB_1_0_0)
    OPENSSL_DIR = $(OPENSSL_DIR_USR_LIB)
  else ifneq (,$(shell find $(OPENSSL_DIR_LIB_X86_64) -type f -name $(OPENSSL_LIB_1_1_0) 2> /dev/null))
    OPENSSL_API_COMPAT = $(OPENSSL_API_COMPAT_1_1_0)
    OPENSSL_VERSION = $(OPENSSL_VERSION_1_1_0)
    OPENSSL_LIB = $(OPENSSL_LIB_1_1_0)
    OPENSSL_DIR = $(OPENSSL_DIR_LIB_X86_64)
  else ifneq (,$(shell find $(OPENSSL_DIR_LIB_X86_64) -type f -name $(OPENSSL_LIB_1_0_0) 2> /dev/null))
    OPENSSL_API_COMPAT = $(OPENSSL_API_COMPAT_1_0_0)
    OPENSSL_VERSION = $(OPENSSL_VERSION_1_0_0)
    OPENSSL_LIB = $(OPENSSL_LIB_1_0_0)
    OPENSSL_DIR = $(OPENSSL_DIR_LIB_X86_64)
  else
    $(warning "OPENSSL_DIR/OPENSSL_LIB NOT found")
  endif
endif

ifndef OPENSSL_API_COMPAT
  $(error No OPENSSL installation found!)
endif

CFLAGS=-Wall
#CFLAGS=
LFLAGS=-L/usr/lib -L$(OPENSSL_DIR) -l:$(OPENSSL_LIB) -lcrypto


.PHONY: all
all: ssl_server

ssl_server: ssl_server.c Makefile
	gcc $(CFLAGS) -gdwarf-5 -DOPENSSL_API_COMPAT=$(OPENSSL_API_COMPAT) -o ssl_server ssl_server.c $(LFLAGS)

.PHONY: gencert
gencert:
	openssl req -x509 -nodes -days 365 -newkey rsa:1024 -keyout mycert.pem -out mycert.pem

.PHONY: clean
clean:
	@rm ./ssl_server
