%{
#include "y.tab.h"
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#define MAX_LENGTH 1000

// Declare global variables
char sentence[MAX_LENGTH];
char concatenated[MAX_LENGTH];
char search_word[100];
char new_word[100];
int mode;
%}

%%
"reverse"           { return REVERSE; }
"vowels_consonants" { return VOWELS_CONSONANTS; }
"view"              { return VIEW; }
"add"               { return ADD_WORD; }
"delete"            { return DELETE_WORD; }
"replace"           { return REPLACE_WORD; }
"palindrome"        { return PALINDROME; }
"count"             { return COUNT; }
"case"              { return CHANGE_CASE; }
"concat" 	        { return CONCATENATE; }
"print_strings"     { return PRINT_STRINGS; }
"longest"           { return LONGEST_STRING; }

[a-zA-Z]+           { yylval.str_val = strdup(yytext); return WORD; }
"+"                 { return PLUS; }
\"[^\"]*\"          { yylval.str_val = strdup(yytext + 1); yylval.str_val[strlen(yylval.str_val) - 1] = '\0'; return STRING; }
[ \t]+              { return SPACE; } // Match spaces or tabs
\n                  { return NEWLINE; }
.                   { return *yytext; }

%%

int yywrap() {
    return 1;
}
