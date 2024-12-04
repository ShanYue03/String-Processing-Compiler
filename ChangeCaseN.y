%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>

// 用于存储模式的全局变量
int mode = 0;

void process_input(const char *input);
%}

%%

// 规则部分，这里只定义空规则
commands:
    /* 空规则 */
;

%%

// 用户代码部分
void process_input(const char *input) {
    // 使用 Lex 分析器处理输入字符串
    YY_BUFFER_STATE buffer = yy_scan_string(input);
    if (buffer == NULL) {
        printf("Error scanning input string.\n");
        return;
    }

    yylex();  // 调用 Lex 分析器处理输入
    yy_delete_buffer(buffer);  // 清理缓冲区
}

int main() {
    char input[1024];

    while (1) {
        // 读取模式选择
        printf("Choose mode (1: all lowercase, 2: all uppercase, 3: swap case): ");
        scanf("%d", &mode);
        getchar();  // 吸收换行符

        if (mode < 1 || mode > 3) {
            printf("Invalid choice! Please enter 1, 2, or 3.\n");
            continue;
        }

        // 获取输入字符串
        printf("\nEnter a string (type 'exit' to quit): ");
        fgets(input, sizeof(input), stdin);

        // 去掉换行符
        input[strcspn(input, "\n")] = '\0';

        if (strcmp(input, "exit") == 0) {
            printf("Exiting program. Goodbye!\n");
            break;
        }

        if (strlen(input) == 0) {
            printf("Empty input! Please enter a non-empty string.\n");
            continue;
        }

        // 调试信息
        printf("Processing input: %s\n", input);

        // 处理输入字符串
        process_input(input);

        printf("\n");
    }

    return 0;
}
