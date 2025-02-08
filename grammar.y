%{
#include <stdio.h>
#include <stdlib.h>

void yyerror(const char *s);
int yylex();
int yyparse();
int indent_level = 0;

void increase_indent() {
    indent_level++;
}

/* Função auxiliar para diminuir o nível de indentação (subindo um nível na árvore) */
void decrease_indent() {
    if (indent_level > 0) {
        indent_level--;
    }
}

void print_node(const char *node_name) {
    for (int i = 0; i < indent_level; i++) {
        printf("\t");
    }
    printf("%s\n", node_name);
}

%}

%union {
  char *str;
}

%token <str> TYPE    /* bill, coin, account */
%token <str> ID      /* identificadores, ex.: ten, extra_coin, repeat, my_account, my_bank */
%token <str> BALANCE_VALUE  /* valores numéricos (inteiros e decimais) */
%token NEWLINE  
%token ASS     /* sinal de atribuição "=" */
%token OPERATOR  /* operadores aritméticos, ex.: +, -, *, / */
%token BANK    /* para expressões do tipo bank[...] */
%token OPEN_BRACKET
%token CLOSE_BRACKET

%type <str> assignment
%type <str> bank_assignment
%type <str> vector_assignment

%%

program:
    { print_node("program"); increase_indent(); }
    /* vazio */
    | program statement NEWLINE
    { decrease_indent(); }
    ;

statement:
    { print_node("statement"); increase_indent(); }
    vector_assignment
    | bank_assignment
    | assignment
    { decrease_indent(); }
    ;

assignment:
    { print_node("assignment"); increase_indent(); }
    TYPE ID ASS expr
    { 
      print_node($3); 
      decrease_indent(); 
    }
    ;

expr:
    term
    | expr OPERATOR term
    ;

term:
    BALANCE_VALUE { print_node($1); }
  | ID { print_node($1); }
    ;

bank_assignment:
    { print_node("bank_assignment"); increase_indent(); }
    BANK ID
    { print_node($3); decrease_indent(); }
    ;

vector_assignment:
    { print_node("vector_assignment"); increase_indent(); }
    ID OPEN_BRACKET BALANCE_VALUE CLOSE_BRACKET ASS expr
    { 
      decrease_indent(); 
    }
    ;


%%


void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s\n", s);
}

int main() {
    yyparse();
    return 0;
}

