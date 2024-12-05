%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 声明全局变量 mode
int mode;

// Flex 提供的类型和函数声明
typedef void* YY_BUFFER_STATE;
extern YY_BUFFER_STATE yy_scan_string(const char *str);
extern void yy_delete_buffer(YY_BUFFER_STATE buffer);
extern int yylex();

void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}
%}

%start input

%%

input:
    mode_selection string_handling
;

mode_selection:
    {
        printf("Choose mode (1: all lowercase, 2: all uppercase, 3: swap case): ");
        if (scanf("%d", &mode) != 1) {
            fprintf(stderr, "Invalid input! Please enter a number.\n");
            while (getchar() != '\n');  // 清空缓冲区
            mode = 0;
            return 0;  // 重新提示用户输入
        }
        getchar();  // 吸收换行符
        if (mode < 1 || mode > 3) {
            printf("Invalid choice! Please enter 1, 2, or 3.\n");
            return 0;
        }
    }
;

string_handling:
    {
        char input[1024];  // 限制输入字符串长度
        printf("\nEnter a string (type 'exit' to quit): ");
        if (fgets(input, sizeof(input), stdin) == NULL) {
            fprintf(stderr, "Error reading input.\n");
            return 1;  // 正常退出
        }
        input[strcspn(input, "\n")] = '\0';  // 去掉换行符

        if (strcmp(input, "exit") == 0) {
            printf("Exiting program. Goodbye!\n");
            return 1;  // 返回非零值，退出主循环
        }
        if (strlen(input) == 0) {
            printf("Empty input! Please enter a non-empty string.\n");
            return 0;
        }

        printf("Processing input: %s\n", input);

        YY_BUFFER_STATE buffer = yy_scan_string(input);
        if (buffer == NULL) {
            fprintf(stderr, "Error: Failed to create buffer.\n");
            return 0;
        }

        yylex();

        yy_delete_buffer(buffer);

        printf("\n");
    }
;
%%
   
int main() {
    while (1) {
        int result = yyparse();
        if (result != 0) {
            break;
        }
    }
    return 0;
}
