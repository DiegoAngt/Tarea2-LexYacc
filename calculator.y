%{
#include <stdio.h>
#include <stdlib.h>

float vars[26]; 
int declared[26];
%}

%union {
    int ival;
    float fval;
    char id;
}

%token <ival> INUM
%token <fval> FNUM
%token <id> ID
%token INTDECL FLOATDECL PRINT
%token PLUS MINUS MULT DIV EQUALS

%type <fval> expr

%left PLUS MINUS
%left MULT DIV

%%
program:
    program stmt
  | /* empty */
  ;

stmt:
    INTDECL ID           { declared[$2 - 'a'] = 1; }
  | FLOATDECL ID         { declared[$2 - 'a'] = 2; }
  | ID EQUALS expr       { vars[$1 - 'a'] = $3; }
  | PRINT ID             { printf("%.2f\n", vars[$2 - 'a']); }
  ;

expr:
    INUM                 { $$ = $1; }
  | FNUM                 { $$ = $1; }
  | ID                   { $$ = vars[$1 - 'a']; }
  | expr PLUS expr       { $$ = $1 + $3; }
  | expr MINUS expr      { $$ = $1 - $3; }
  | expr MULT expr       { $$ = $1 * $3; }
  | expr DIV expr        { $$ = $1 / $3; }
  ;
%%

extern FILE *yyin;

int main(int argc, char **argv) {
    if (argc == 2) {
        FILE *fp = fopen(argv[1], "r");
        if (!fp) {
            perror("Error opening file");
            return 1;
        }
        yyin = fp;
        yyparse();
        fclose(fp);
    } else {
        fprintf(stderr, "Usage: %s SOURCE_CODE\n", argv[0]);
        return 1;
    }
    return 0;
}

int yyerror(char *s) {
    fprintf(stderr, "Syntax Error: %s\n", s);
    return 0;
}
