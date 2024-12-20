%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

// 声明全局变量
char first[100] = "";  // 用于存储第一个字符串
char second[100] = ""; // 用于存储第二个字符串
char result[200] = ""; // 用于存储操作后的字符串

// 声明 yylex 和 yytext
extern int yylex();
extern char *yytext;

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

%token FIRST SECOND CONCAT APPEND_LAST EXIT

%%
commands:
    | commands command
;

command:
    FIRST { 
        strncpy(first, yytext + 6, sizeof(first) - 1); // 跳过 "first "
        first[sizeof(first) - 1] = '\0'; // 确保字符串以 null 结尾
        printf("First string set to: %s\n", first);
    }
    | SECOND {
        strncpy(second, yytext + 7, sizeof(second) - 1); // 跳过 "second "
        second[sizeof(second) - 1] = '\0'; // 确保字符串以 null 结尾
        printf("Second string set to: %s\n", second);
    }
    | CONCAT {
        if (strlen(first) > 0 && strlen(second) > 0) {
            strcpy(result, first);
            strcat(result, second);
            printf("Concatenated result: %s\n", result);
        } else {
            if (strlen(first) == 0)
                printf("First string is not set. Please use 'first <string>' to input it.\n");
            if (strlen(second) == 0)
                printf("Second string is not set. Please use 'second <string>' to input it.\n");
        }
    }
    | APPEND_LAST {
        if (strlen(first) > 0 && strlen(second) > 0) {
            char last_char = first[strlen(first) - 1];
            char temp[2] = {last_char, '\0'};
            strcpy(result, second);
            strcat(result, temp); // 拼接第一个字符串的最后一个字符到第二个字符串
            printf("Modified second string: %s\n", result);
        } else {
            if (strlen(first) == 0)
                printf("First string is not set. Please use 'first <string>' to input it.\n");
            if (strlen(second) == 0)
                printf("Second string is not set. Please use 'second <string>' to input it.\n");
        }
    }
    | EXIT {
        printf("Exiting...\n");
        exit(0);
    }
;
%%
int main() {
    printf("Commands:\n");
    printf("1. Input first string: first <your_string>\n");
    printf("2. Input second string: second <your_string>\n");
    printf("3. Concatenate strings: concat\n");
    printf("4. Append last character of first string to second string: append_last\n");
    printf("5. Exit program: exit\n");
    return yyparse();
}
