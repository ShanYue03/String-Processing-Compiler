%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 用于存储字符串
char first[100] = "";
char second[100] = "";
char result[200] = "";
%}

%union {
    char *string;  // Lex 文件传递的字符串
}

%token <string> FIRST SECOND
%token CONCAT APPEND_LAST EXIT

%%

// 主规则
commands:
    commands command
  | /* 空规则 */
  ;

command:
    FIRST {
        strncpy(first, $1, sizeof(first) - 1);
        first[sizeof(first) - 1] = '\0';
        printf("First string set to: %s\n", first);
        free($1);  // 释放 strdup 分配的内存
    }
  | SECOND {
        strncpy(second, $1, sizeof(second) - 1);
        second[sizeof(second) - 1] = '\0';
        printf("Second string set to: %s\n", second);
        free($1);  // 释放 strdup 分配的内存
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
            strcat(result, temp);  // 拼接第一个字符串的最后一个字符到第二个字符串
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

// 错误处理函数
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

int main() {
    printf("Commands:\n");
    printf("1. Input first string: first <your_string>\n");
    printf("2. Input second string: second <your_string>\n");
    printf("3. Concatenate strings: concat\n");
    printf("4. Append last character of first string to second string: append_last\n");
    printf("5. Exit program: exit\n");
    return yyparse();
}
