%{
#include "y.tab.h"
#include <string.h>
#include <stdlib.h>
%}

%%
[^\n]+    { yylval.str = strdup(yytext); return STRING; }
\n        { return NEWLINE; }
%%

int yywrap() {
    return 1;
}
