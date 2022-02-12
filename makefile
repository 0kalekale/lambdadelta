# project: λδ(lambdadelta)
# license: GPL3
# author: 0kalekale
 
TARGET = target
SRC = src
# CFLAGS  
LDFLAGS = -lfl -ly -lm
BIN = lambdadelta

build:	prepare parser_lexer compile link

prepare:
	@mkdir -p $(TARGET)
	@mkdir -p $(TARGET)/include
	@mkdir -p $(TARGET)/src 

parser_lexer:
	@echo "YACC $(SRC)/grammar.y" 
	@yacc --defines=include/grammar.h -o $(SRC)/grammar.c $(SRC)/grammar.y
	@echo "LEX $(SRC)/scanner.l"
	@flex --outfile=$(SRC)/scanner.c $(SRC)/scanner.l

compile:
	@for i in $(SRC)/*.c; do echo CC $$i; done 
	@cd $(TARGET) && $(CC)$(CFLAGS) -I../include -c ../$(SRC)/*.c    

link:
	@echo $(TARGET)/*.o
	@cd $(TARGET) && $(CC) *.o $(LDFLAGS) -o $(BIN)
test:
	@cd tests && ./berntestel *.λδ

clean:
	@rm $(SRC)/grammar.c $(SRC)/scanner.c include/grammar.h
	@rm -rf $(TARGET)
