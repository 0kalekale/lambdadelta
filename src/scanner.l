/*
    This program contains the tokenizer 
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
#include <math.h>
#include <grammar.h>

#include <sym.h>
%}
%option yylineno
%%

"i8"		{ ;/*return T_I8*/ }
"i16"		{ ;/*return T_I16*/ }
"i32"		{ ;/*return T_I32*/ }
"i64"		{ ;/*return T_I64*/ }

"u8"		{ ;/*return T_U8*/ }
"u16"		{ ;/*return T_U16*/ }
"u32"		{ ;/*return T_U32*/ }
"u64"

"void"	
"bool"

"return"

"True"
"False"

"if"
"else"

"var"
"const"

">"
"<"
"=="
"!="

"+"
"-"
"*"
"/"
"^"

"&&"
"||"

["].*["] 
["].["]

"\\" 
"proc"

([0-9]+|([0-9]*\.[0-9]+)([eE][-+]?[0-9]+)?) {
		yylval.dval = atof(yytext);
		return NUMBER;
	}

[ \t]	;		 

[A-Za-z][A-Za-z0-9]*	{	
		struct symtab *sp = symlook(yytext);

		yylval.symp = sp;
		return NAME;
	}

"$"	{ return 0; }

\n	|
.	return yytext[0];
%%
