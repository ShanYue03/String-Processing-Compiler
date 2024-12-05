%{
#include <stdio.h>
#include <stdlib.h>
#include "y.tab.h" // 包含 Yacc 生成的头文件
%}

%%
^first[ \t]+[^\n]+ { return FIRST; } // 匹配 "first <string>"
^second[ \t]+[^\n]+ { return SECOND; } // 匹配 "second <string>"
^concat$ { return CONCAT; } // 匹配 "concat"
^append_last$ { return APPEND_LAST; } // 匹配 "append_last"
^exit$ { return EXIT; } // 匹配 "exit"
.|\n { /* 忽略无效输入 */ } // 忽略其他输入
%%
int yywrap() {
    return 1;
}
