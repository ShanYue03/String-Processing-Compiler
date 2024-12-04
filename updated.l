%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
#define MAX_LENGTH 1000

// Declare global variables as extern
extern int vowels, consonants, others;

%}

%%

"reverse" { return REVERSE; }
"vowels_consonants" { return VOWELS_CONSONANTS; }
\"[^\"]*\"    { yylval.str_val = strdup(yytext + 1); yylval.str_val[strlen(yylval.str_val) - 1] = '\0'; return STRING; }
[ \t\n]+ ; // Ignore whitespace
. { return *yytext; }

%%

int yywrap() {
    return 1;
}
