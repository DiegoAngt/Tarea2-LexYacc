%{
#include "y.tab.h"
#include <stdio.h>
#include <stdlib.h>
%}

%%

"//".*           ;//Se ignoran los comentarios
"f"              { return FLOATDECL; }
"i"              { return INTDECL; }
"p"              { return PRINT; }
[a-z]            { yylval.id = yytext[0]; return ID; }
[0-9]+\.[0-9]+   { yylval.fval = atof(yytext); return FNUM; }
[0-9]+           { yylval.ival = atoi(yytext); return INUM; }
"+"              { return PLUS; }
"-"              { return MINUS; }
"*"              { return MULT; }
"/"              { return DIV; }
"="              { return EQUALS; }
[ \t\n]+         ;//Se ignoran los espacios
.                ;//Se ignora cualquier otro carácter

%%

int yywrap() {
    return 1;
}
