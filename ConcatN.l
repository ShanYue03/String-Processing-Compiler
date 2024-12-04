%{
#include <stdio.h>
#include <string.h>
#include "y.tab.h"  // 包含 YACC 生成的头文件
%}

%%
^first[ \t]+([^\n]+) {
    yylval.string = strdup(yytext + 6);  // 提取字符串，跳过 "first "
    return FIRST;
}

^second[ \t]+([^\n]+) {
    yylval.string = strdup(yytext + 7);  // 提取字符串，跳过 "second "
    return SECOND;
}

^concat$ {
    return CONCAT;
}

^append_last$ {
    return APPEND_LAST;
}

^exit$ {
    return EXIT;
}

[ \t\n]+ ;  // 忽略空白符
.          { printf("Unexpected input: %s\n", yytext); }  // 处理无效输入
%%
int yywrap() {
    return 1;
}
