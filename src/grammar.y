/*
    This program contains semantics defination of λδ  
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
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <math.h>

#include <sym.h>
#include <error.h>

int yylex(); // define this in some header?

#define NSYMS 20
struct symtab symtab[NSYMS]; 
%}

%union {
	double dval;
	struct symtab *symp;
}

%token T_I8 T_I16 T_I32 T_I64
%token T_U8 T_U16 T_U32 T_U64
%token T_VOID T_BOOL
%token T_RETURN
%token T_TRUE T_FALSE
%token T_IF T_ELSE
%token T_VAR T_CONST
%token T_RIGHT_AB T_LEFT_AB T_EQUALCMP T_N_EQUALCMP
%token T_PLUS T_MINUS T_ASTRK T_FSLASH T_EXPONENET
%token T_BITW_OR T_BITW_AND  
%token T_STR T_CHAR
%token T_LAMBDA T_PROC	
// bison mode's broken forced indentation is getting really annoying at this point 
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

// TODO: move all these to somewhere else.
// update: nuke these, you wont be needing this for AST and the codegen  
struct symtab *
symlook(char *s) 
{
	char *p;
	struct symtab *sp;
	
	for(sp = symtab; sp < &symtab[NSYMS]; sp++) 
	{	
		if(sp->name && !strcmp(sp->name, s))
			return sp;	
		if(!sp->name) {
			sp->name = strdup(s);
			return sp;
		}
	}
	yyerror("Too many symbols");
	exit(1);	
}

int
addfunc(char* name, 
	double (*func)()) 
{
	struct symtab *sp = symlook(name);
	sp->funcptr = func;
}

int 
parse()
{
	extern double sqrt(), exp(), log();

	addfunc("sqrt", sqrt);
	addfunc("exp", exp);
	addfunc("log", log);
	yyparse();
}
