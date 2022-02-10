/*
    This program contains semantics defination of λδ and the entry point of the compiler 
    Copyright (C) 2022  0kalekale

    This program is free software: you can redistribute it and/or modify
    it under the terms of the GNU General Public License as published by
    the Free Software Foundation, either version 3 of the License, or
    (at your option) any later version.

    This program is distributed in the hope that it will be useful,
    but WITHOUT ANY WARRANTY; without even the implied warranty of
    MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
    GNU General Public License for more details.

    You should have received a copy of the GNU General Public License
    along with this program.  If not, see <https://www.gnu.org/licenses/>.
*/

%{
#include "sym.h"
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>
%}

%union {
	double dval;
	struct symtab *symp;
}
%token <symp> NAME
%token <dval> NUMBER
%left '-' '+'
%left '*' '/'
%nonassoc UMINUS

%type <dval> expression
%%
statement_list:	statement '\n'
	|	statement_list statement '\n'
	;

statement:	NAME '=' expression	{ $1->value = $3; }
	|	expression		{ printf("= %g\n", $1); }
	;

expression:	expression '+' expression { $$ = $1 + $3; }
	|	expression '-' expression { $$ = $1 - $3; }
	|	expression '*' expression { $$ = $1 * $3; }
	|	expression '/' expression
				{	if($3 == 0.0)
						yyerror("divide by zero");
					else
						$$ = $1 / $3;
				}
	|	'-' expression %prec UMINUS	{ $$ = -$2; }
	|	'(' expression ')'	{ $$ = $2; }
	|	NUMBER
	|	NAME			{ $$ = $1->value; }
	|	NAME '(' expression ')'	{
			if($1->funcptr)
				$$ = ($1->funcptr)($3);
			else {
				printf("%s not a function\n", $1->name);
				$$ = 0.0;
			}
		}
	;
%%

struct symtab *
symlook(s)
char *s;
{
	char *p;
	struct symtab *sp;
	
	for(sp = symtab; sp < &symtab[NSYMS]; sp++) {
		
		if(sp->name && !strcmp(sp->name, s))
			return sp;
		
		
		if(!sp->name) {
			sp->name = strdup(s);
			return sp;
		}
		
	}
	yyerror("Too many symbols");
	exit(1);	


addfunc(name, func)
char *name;
double (*func)();
{
	struct symtab *sp = symlook(name);
	sp->funcptr = func;
}

main()
{
	extern double sqrt(), exp(), log();

	addfunc("sqrt", sqrt);
	addfunc("exp", exp);
	addfunc("log", log);
	yyparse();
}
