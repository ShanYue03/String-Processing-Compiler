%{
#include <stdio.h>
#include <string.h>
#include <ctype.h>
#include "y.tab.h" // 包含 YACC 生成的头文件

#define MAX_LENGTH 1000

// Declare global variables
char sentence[MAX_LENGTH];
int choice;
char search_word[100];
char new_word[100];
int mode; // 共享变量，用于大小写转换
%}

%%
/* 规则组 1：与 "first" 和 "second" 等相关的规则 */
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

/* 规则组 2：处理命令如 reverse、vowels_consonants 等 */
"reverse"           { return REVERSE; }
"vowels_consonants" { return VOWELS_CONSONANTS; }
"view"              { return VIEW; }
"add"               { return ADD_WORD; }
"delete"            { return DELETE_WORD; }
"replace"           { return REPLACE_WORD; }
\"[^\"]*\"          { 
    yylval.str_val = strdup(yytext + 1); 
    yylval.str_val[strlen(yylval.str_val) - 1] = '\0'; 
    return STRING; 
}

/* 规则组 3：处理大小写转换、数字、特殊字符等 */
[a-z] {
    if (mode == 1) {
        printf("%c", tolower(yytext[0]));  // 全部小写
    } else if (mode == 2) {
        printf("%c", toupper(yytext[0]));  // 全部大写
    } else {
        printf("%c", toupper(yytext[0]));  // 小写变大写
    }
}

[A-Z] {
    if (mode == 1) {
        printf("%c", tolower(yytext[0]));  // 全部小写
    } else if (mode == 2) {
        printf("%c", toupper(yytext[0]));  // 全部大写
    } else {
        printf("%c", tolower(yytext[0]));  // 大写变小写
    }
}

[0-9] {
    printf("%s", yytext);  // 数字保持不变
}

[ \t] {
    printf("%s", yytext);  // 空格和制表符保持不变
}

. {
    printf("%s", yytext);  // 其他字符保持不变
}

\n {
    printf("\n");  // 换行符直接输出
}

/* 其他规则 */
[ \t\n]+ ; // 忽略空白符
. {
    printf("Unexpected input: %s\n", yytext); // 处理无效输入
}
%%

int yywrap() {
    return 1; // 返回 1 表示词法分析结束
}
