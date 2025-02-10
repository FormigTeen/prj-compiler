%define parse.error verbose

%{
#include <stdio.h>
#include <stdlib.h>
#define CAN_PRINT 1

extern char *yytext;  // Declarando a variável global do lex
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
%token IF THEN END
%token COMPARISON
%token ELSE
%token WHILE


%type <str> assignment
%type <str> bank_assignment
%type <str> expr term

%%

program:
    { print_node("program"); increase_indent(); }
    /* vazio */
  | program NEWLINE
  | program statement NEWLINE { decrease_indent(); }
    ;

statement:
    { print_node("statement"); increase_indent(); }
      conditional_statement
    |  while_statement
    | bank_assignment
    | assignment
    { decrease_indent(); }
    ;

assignment:
    { print_node("assignment"); increase_indent(); }
    optional_type ID assignment_tail
    { 
      decrease_indent(); 
    }
    ;

optional_type:
      TYPE
    | /* vazio */
    ;

assignment_tail:
      ASS expr
    | OPEN_BRACKET BALANCE_VALUE CLOSE_BRACKET ASS expr
    ;

expr:
    term
    | expr OPERATOR term
    ;

term:
    BALANCE_VALUE { print_node($1); $$ = $1; }
  | ID { print_node($1); $$ = $1; }
  | ID OPEN_BRACKET expr CLOSE_BRACKET
  ;

optional_statement_list:
    NEWLINE optional_statement_list
    | statement_list
    | /* vazio */
    ;


statement_list:
      statement NEWLINE
      | statement NEWLINE statement_list
    ;


bank_assignment:
    { print_node("bank_assignment"); increase_indent(); }
    BANK ID
    { print_node($3); decrease_indent(); }
    ;

conditional_statement:
    { print_node("conditional_statement"); increase_indent(); }
    IF expr COMPARISON expr THEN NEWLINE optional_statement_list if_tail
    { decrease_indent(); }
    ;

while_statement:
    { print_node("while_statement"); increase_indent(); }
    WHILE expr COMPARISON expr THEN NEWLINE optional_statement_list END
    { decrease_indent(); }
    ;

if_tail:
      ELSE NEWLINE optional_statement_list END
    | END
    ;

%%


void yyerror(const char *s) {
    fprintf(stderr, "Erro: %s. Token inesperado: '%s'\n", s, yytext);
}

int main() {
    yyparse();
    //yylex();
    return 0;
}


