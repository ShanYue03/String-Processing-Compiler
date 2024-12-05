%{
#include <stdio.h>
#include <ctype.h>
#include "y.tab.h"  // 包含 Yacc 头文件以支持模式变量 mode 的声明
extern int mode;
%}

%%

[a-z] {  // 处理小写字母
    if (mode == 1) {
        putchar(tolower(yytext[0]));  // 全部小写
    } else if (mode == 2) {
        putchar(toupper(yytext[0]));  // 全部大写
    } else { 
        putchar(toupper(yytext[0]));  // 小写变大写
    }
}

[A-Z] {  // 处理大写字母
    if (mode == 1) {
        putchar(tolower(yytext[0]));  // 全部小写
    } else if (mode == 2) {
        putchar(toupper(yytext[0]));  // 全部大写
    } else { 
        putchar(tolower(yytext[0]));  // 大写变小写
    }
}

[0-9] {  // 数字保持不变
    putchar(yytext[0]);
}

[ \t] {  // 空格和制表符保持不变
    putchar(yytext[0]);
}

. {  // 处理其他字符（如标点符号）
    putchar(yytext[0]);
}

\n {  // 处理换行符
    putchar('\n');
}

%%

int yywrap() {
    return 1;  // 表示词法分析结束
}
