%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
int yyparse();

%}

%token TYPE

%%

equation:
    ;

%%

void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main() {
    printf("Digite uma expressão matemática: \n");
    yyparse();
    return 0;
}

