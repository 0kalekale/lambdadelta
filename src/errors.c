#include <stdio.h>
#include <stdlib.h>
#include <grammar.h>
#include <error.h>

#define RED "\033[0;31m"
#define NC "\033[0m"

int rc = 0;

void
yyerror (char *s) 
{
	fprintf(stderr, RED"Error: "NC"line %d: %s\n", yylineno, s);
	rc = 1;
}
