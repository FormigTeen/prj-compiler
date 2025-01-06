/* Definitions */

%{
    #include <stdio.h>
    #include <ctype.h>
    #include <stdlib.h>
    #include <string.h>
    #include "uthash.h"

    typedef struct Symbol {
        char key[256];     
        char type[32];     
        UT_hash_handle hh; 
    } Symbol;

    typedef struct SValue {
        char key[256];     
        int value;
        int decimal;
        UT_hash_handle hh; 
    } SValue;

    Symbol* id_table = NULL;
    SValue* value_table = NULL;

    int get_number(const char* str) {
        // Using Global yyleng

        int result = 0;
        for (int i = 0; i < yyleng; i++) {
            if (isdigit(str[i])) {
                result = result * 10 + (str[i] - '0');
            }
        }
        return result;
    }

    int get_count(const char* str) {
        const char* dot_position = strchr(str, '.');
        if (dot_position == NULL) {
            return 0;
        }
        return strlen(dot_position + 1);
    }


    Symbol* add_id(const char* key, const char* type) {
        Symbol* s;
        HASH_FIND_STR(id_table, key, s);
        if (s == NULL) {
            s = (Symbol*)malloc(sizeof(Symbol));
            if (!s) {
                //fprintf(stderr, "Error");
                exit(EXIT_FAILURE);
            }
            strcpy(s->key, key);
            strcpy(s->type, type);
            HASH_ADD_STR(id_table, key, s);
            //printf("Add: %s (%s)\n", key, type);
        } else {
            //printf("Exists: %s\n", key);
        }
        return s;
    }

    Symbol* get_id(const char* key) {
        Symbol* s;
        HASH_FIND_STR(id_table, key, s);
        return s;
    }

    Symbol* upsert_id(const char* key, const char* type) {
        Symbol* s = get_id(key);
        if (s == NULL) {
            s = add_id(key, type);
        } else {
            strcpy(s->type, type);
        }

        return s;
    }

    SValue* add_value(const char* key) {
        SValue* s;
        HASH_FIND_STR(value_table, key, s);
        if (s == NULL) {
            s = (SValue*)malloc(sizeof(SValue));
            if (!s) {
                //fprintf(stderr, "Error");
                exit(EXIT_FAILURE);
            }
            s->value = get_number(key);
            s->decimal = get_count(key);
            HASH_ADD_STR(value_table, key, s);
            //printf("Add: %s (%s)\n", key, type);
        } else {
            //printf("Exists: %s\n", key);
        }
        return s;
    }

    SValue* get_value(const char* key) {
        SValue* s;
        HASH_FIND_STR(value_table, key, s);
        return s;
    }

    SValue* upsert_value(const char* key) {
        SValue* s = get_value(key);
        if (s == NULL) {
            s = add_value(key);
        }
        return s;
    }


    void print_tag(const char *name) {
        printf("<%s>", name);
        return;
    }

    void print_tag_with_value(const char *name, const SValue *item) {
        printf("<%s>%d.%d</%s>", name, item->value, item->decimal, name);
        return;
    }

    void print_tag_with_symbol(const char *name, const Symbol *item) {
        printf("<%s>%p</%s>", name, (void*) item, name);
        return;
    }

%}


/* Expressions Alias */

/* Language Atoms */
comment          \#.*
limit           [ \t\n]
whitespace      {limit}+
letter          [a-zA-Z]
digit           [0-9]

/* Language Types */
coin            coin
bill            bill
account         account
type            ({coin}|{bill}|{account})
bank            bank\[{type}:{digit}+\]

/* Values Definition */
bill_value      {digit}+
coin_value      \.{digit}+
account_value   {bill_value}{coin_value}?
balance_value   ({account_value}|{bill_value}|{coin_value})
comparison      (==|!=|<=|>=|<|>)
operator        (\+|\-|\*|\/)
assignment      =
comma           ,
open_paren \(
close_paren \)
if_keyword    if
else_keyword  else
void            void
id              {letter}({letter}|{digit}|_)*
bank_id         {id}\[{digit}+\]
while_keyword   while
then_keyword    then
end_keyword     end
transaction_keyword     transaction
start_keyword     start
return_keyword  return

%%

{type}            { print_tag("TYPE"); }
{assignment}      { print_tag("ASS"); }
{open_paren}      { print_tag("OPEN_PAREN"); }
{close_paren}     { print_tag("CLOSE_PAREN"); }
{comma}           { print_tag("COMMA"); }
{void}            { print_tag("VOID"); }
{if_keyword}      { print_tag("IF"); }
{else_keyword}    { print_tag("ELSE"); }
{then_keyword}    { print_tag("THEN"); }
{end_keyword}     { print_tag("END"); }
{while_keyword}   { print_tag("WHILE"); }
{return_keyword}  { print_tag("RETURN"); }
{transaction_keyword}  { print_tag("TRANSACTION"); }
{start_keyword}  { print_tag("START"); }
{bank}            { print_tag("BANK"); }
{id}              { Symbol* my_id = upsert_id(yytext, "ID"); print_tag_with_symbol("ID", my_id); }
{bank_id}         { print_tag("BANK_ID"); }
{balance_value}   { SValue* my_value = upsert_value(yytext); print_tag_with_value("BALANCE", my_value); }
{comment}         ; /* Ignora comentários */
{whitespace}      ; /* Ignora espaços em branco */

%%

/* Functions */

int main(void) {
    yylex(); 
    return 0;
}