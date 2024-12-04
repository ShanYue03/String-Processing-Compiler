%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

char *longest = NULL;
int max_length = 0;

void update_longest(const char *str);
%}

%union {
    char *str;
}

%token <str> STRING
%token NEWLINE

%%
input:
    | input line
    ;

line:
    STRING NEWLINE {
        int len = strlen($1);
        printf("Length: %d\n", len);
        update_longest($1);
        free($1);
    }
    | NEWLINE
    ;

%%
void update_longest(const char *str) {
    int len = strlen(str);
    if (len > max_length) {
        max_length = len;
        free(longest);
        longest = strdup(str);
    }
}

int main() {
    printf("Enter strings:\n");
    yyparse();
    printf("\nLongest string is : \"%s\" (Length: %d)\n", longest, max_length);
	free(longest);
    return 0;
}

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
