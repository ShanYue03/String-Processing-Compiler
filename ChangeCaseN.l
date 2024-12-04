%{
#include <stdio.h>
#include <ctype.h>
#include "y.tab.h"  // 包含 YACC 的头文件，访问 mode 变量
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
