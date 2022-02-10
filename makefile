# project: λδ(lambdadelta)
# license: GPL3
# author: 0kalekale
 
TARGET = target
SRC = src
CFLAGS = -fcommon #TODO remove this hack 
LDFLAGS = -lfl -ly -lm
BIN = lambdadelta

build:
	mkdir -p $(TARGET)
	mkdir -p $(TARGET)/include
	yacc --defines=$(TARGET)/include/grammar.h  $(SRC)/grammar.y -S $(TARGET)/grammar.c 
	flex --outfile=$(TARGET)/scanner.c $(SRC)/scanner.l  
	$(CC) $(CFLAGS) $(TARGET)/*.c  -I$(TARGET)/include $(LDFLAGS) -o $(TARGET)/$(BIN)

test:
	cd tests && ./berntestel *.λδ
clean:
	rm -rf $(TARGET)
