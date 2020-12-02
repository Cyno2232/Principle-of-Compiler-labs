%{
#include <stdio.h>
#include <stdlib.h>
#ifndef YYSTYPE
#define YYSTYPE double
#endif
int yylex();
extern int yyparse();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUMBER
%token ADD
%token SUB
%token MUL
%token DIV
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines  :    lines expr '\n'{ printf("%f\n", $2); }
       |    lines '\n'
       |
       ;

expr    :   expr ADD expr   { $$ = $1 + $3; }
        |   expr SUB expr   { $$ = $1 - $3; }
        |   expr MUL expr   { $$ = $1 * $3; }
        |   expr DIV expr   { $$ = $1 / $3; }
        |   '(' expr ')'    { $$ = $2; }
        |   '-' expr %prec UMINUS   { $$ = -$2; }
        |   NUMBER  { $$ = $1; }
        ;

%%

int yylex()
{
    int t;
    while(true) {
        t = getchar();
        if(t == ' ' || t == '\t' || t == '\n')
            ;
        else if(t == '+') {
            return ADD;
        }
        else if(t == '-') {
            return SUB;
        }
        else if(t == '*') {
            return MUL;
        }
        else if(t == '\') {
            return DIV;
        }
        else if(isdigit(t)) {
            yylval = 0;
            while(isdigit(t)) {
                yylval = yylval * 10 + t - '0';
                t = getchar();
            }
            ungetc(t, stdin);
            return NUMBER;
        }
        else {
            return t;
        }
    }
}