%{
#include <stdio.h>
#include <ctype.h>
#include <string.h>

int mode;  // 用于记录用户选择的模式
%}

%%

[a-z] {  // 处理小写字母
    if (mode == 1) {
        printf("%c", tolower(yytext[0]));  // 全部小写
    } else if (mode == 2) {
        printf("%c", toupper(yytext[0]));  // 全部大写
    } else { 
        printf("%c", toupper(yytext[0]));  // 小写变大写
    }
}

[A-Z] {  // 处理大写字母
    if (mode == 1) {
        printf("%c", tolower(yytext[0]));  // 全部小写
    } else if (mode == 2) {
        printf("%c", toupper(yytext[0]));  // 全部大写
    } else { 
        printf("%c", tolower(yytext[0]));  // 大写变小写
    }
}

[0-9] {  // 处理数字
    printf("%s", yytext);  // 数字保持不变
}

[ \t] {  // 处理空格和制表符
    printf("%s", yytext);  // 空格和制表符保持不变
}

. {  // 处理其他字符（如标点符号）
    printf("%s", yytext);  // 其他字符保持不变
}

\n {  // 处理换行符
    printf("\n");  // 换行符直接输出
}

%%

int yywrap() {
    return 1;  // 返回 1 表示词法分析结束
}

int main() {
    char input[1024];

    // 循环处理用户输入，直到用户输入 "exit"
    while (1) {
        // 每次输入字符串前都询问模式选择
        printf("Choose mode (1: all lowercase, 2: all uppercase, 3: swap case): ");
        scanf("%d", &mode);  // 读取用户选择的模式
        getchar();  // 吸收换行符

        // 检查模式是否有效
        if (mode < 1 || mode > 3) {
            printf("Invalid choice! Please enter 1, 2, or 3.\n");
            continue;
        }

        // 获取用户输入字符串
        printf("\nEnter a string (type 'exit' to quit): ");
        fgets(input, sizeof(input), stdin);  // 获取用户输入字符串

        // 去掉换行符
        input[strcspn(input, "\n")] = '\0';

        // 检查是否输入 "exit" 来退出程序
        if (strcmp(input, "exit") == 0) {
            printf("Exiting program. Goodbye!\n");
            break;
        }

        // 检查输入的字符串是否为空
        if (strlen(input) == 0) {
            printf("Empty input! Please enter a non-empty string.\n");
            continue;
        }

        // 调试输出输入的字符串
        printf("Processing input: %s\n", input);

        // 将输入加载到 Flex 的处理缓冲区
        YY_BUFFER_STATE buffer = yy_scan_string(input);
        if (buffer == NULL) {
            printf("Error scanning input string.\n");
            continue;
        }
        
        // 调用词法分析器处理输入
        yylex(); 
        
        // 清理缓冲区
        yy_delete_buffer(buffer); 

        printf("\n");  // 输出结果提示
    }

    return 0;
}
