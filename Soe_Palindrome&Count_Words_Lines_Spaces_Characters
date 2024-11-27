%{
#include <stdio.h>
int lc = 0, sc = 0, wc = 0, cc = 0;
int i, j, flag;

void check_palindrome(char *str, int length) {
    flag = 1; // Assume it's a palindrome
    for (i = 0, j = length - 1; i <= j; i++, j--) {
        if (str[i] != str[j]) {
            flag = 0;
            break;
        }
    }
    if (flag == 1)
        printf("Given string \"%s\" is a Palindrome\n", str);
    else
        printf("Given string \"%s\" is not a Palindrome\n", str);
}
%}

%%
[\n]          { lc++; cc += yyleng; }
[ \t]         { sc++; cc += yyleng; }
[^\t\n]+      { wc++; cc += yyleng; check_palindrome(yytext, yyleng); }
%%

int main() {
    printf("Enter the input:\n");
    yylex();
    printf("Number of words = %d\n", wc);
    printf("Number of characters = %d\n", cc);
    printf("Number of new lines = %d\n", lc);
    printf("Number of spaces = %d\n", sc);
    return 0;
}

int yywrap() {
    return 1;
}
