%{
#include <stdio.h>
%}

%%
int              { printf("<int> "); }
return           { printf("<return> "); }
[a-zA-Z_][a-zA-Z0-9_]*  { printf("<id, %s> ", yytext); }
[0-9]+           { printf("<num, %s> ", yytext); }
"="              { printf("<=> "); }
"*"              { printf("<*> "); }
";"              { printf("<;> "); }
","              { printf("<,> "); }
"("              { printf("<(> "); }
")"              { printf("<)> "); }
"{"              { printf("<{> "); }
"}"              { printf("<}> "); }
\"[^"]*\"        { printf("<str, %s> ", yytext); }
[ \t\n]+         { /* Ignora espaços e novas linhas */ }
.                { printf("<unknown, %s> ", yytext); }
%%

int main(void) {
    yylex(); 
    return 0;
}
