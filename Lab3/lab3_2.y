%{
#include<stdio.h>
#include<stdlib.h>
#include<string.h>
#ifndef YYSTYPE
#define YYSTYPE char*
#endif
char idstr[50];
char numstr[50];
int yylex();
FILE* yyin;
void yyerror(const char* s);
%}

%token NUMBER
%token ID
%token ADD
%token SUB
%token MUL
%token DIV
%left ADD SUB
%left MUL DIV
%right UMINUS

%%

lines   :   lines expr '\n' { printf("%s\n", $2); }
        |   lines '\n'
        |
        ;

expr    :   expr ADD expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$, "+ "); }
        |   expr SUB expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$, "- "); }
        |   expr MUL expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$, "* "); }
        |   expr DIV expr   { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, $3); strcat($$, "/ "); }
        |   '('expr')'      { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $2); }
        |   NUMBER          { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); }
        |   ID              { $$ = (char*)malloc(50 * sizeof(char)); strcpy($$, $1); strcat($$, " "); }
        |   
        ;

%%

int yylex()
{
    int t;
    while(1) 
    {
        t = getchar();
        if (( t == ' ' || t == '\t' )) {}
        else if (( t >= '0' && t <= '9' )) 
        {
            int ti = 0;
            while (( t >= '0' && t <= '9' )) 
            {
                numstr[ti] = t;
                t = getchar();
                ti++;
            }
            numstr[ti] = '\0';
            yylval = numstr;
            ungetc(t, stdin);
            return NUMBER;
        }
        else if((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_')) 
        {
            int ti = 0;
            while((t >= 'a' && t <= 'z') || (t >= 'A' && t <= 'Z') || (t == '_') || (t >= '0' && t <= '9' )) 
            {
                idstr[ti] = t;
                ti++;
                t = getchar();
            }
            idstr[ti] = '\0';
            yylval = idstr;
            ungetc(t, stdin);
            return ID;
        }
        else if(t == '+') 
        {
            return ADD;
        }
        else if(t == '-') 
        {
            return SUB;
        }
        else if(t == '*') 
        {
            return MUL;
        }
        else if(t == '/') 
        {
            return DIV;
        }
        else 
        {
            return t;
        }
    }
}

int main(void) 
{
    yyin = stdin;
    do 
    {
        yyparse();
    } 
    while(!feof(yyin));
    return 0;
}

void yyerror(const char* s)
{
    fprintf(stderr, "Pause error: %s\n", s);
    exit(1);
}