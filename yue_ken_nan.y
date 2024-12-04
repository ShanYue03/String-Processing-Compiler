%{
#include <stdio.h>
#include <stdlib.h>
#include <string.h>
#include <ctype.h>

// 用于字符串处理的全局变量
#define MAX_LENGTH 1000
char sentence[MAX_LENGTH] = "";
char first[100] = "";
char second[100] = "";
char result[200] = "";
char search_word[100] = "";
char new_word[100] = "";
int mode = 0;

// 函数声明
void reverseString(char* str);
void countVowelsConsonants(char* str);
void addWordToString();
void deleteWord();
void replaceWord();
void processMode(const char* input);

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int yylex();
%}

%union {
    char* str_val;
}

%token REVERSE VOWELS_CONSONANTS VIEW ADD_WORD DELETE_WORD REPLACE_WORD
%token <str_val> STRING
%token FIRST SECOND CONCAT APPEND_LAST EXIT

%%

// 主规则集
program:
    program command
  | /* 空规则 */
  ;

command:
      // 第一部分功能：字符串翻转和统计元音辅音
      REVERSE {
          reverseString(sentence);
          printf("Updated string: %s\n", sentence);
      }
    | VOWELS_CONSONANTS {
          countVowelsConsonants(sentence);
      }
    | VIEW {
          printf("\nStored string: %s\n", sentence);
      }
    | ADD_WORD {
          addWordToString();
          printf("Updated string: %s\n", sentence);
      }
    | DELETE_WORD {
          deleteWord();
          printf("Updated string: %s\n", sentence);
      }
    | REPLACE_WORD {
          replaceWord();
          printf("Updated string: %s\n", sentence);
      }
    // 第二部分功能：字符串连接与附加
    | FIRST STRING {
          strncpy(first, $2, sizeof(first) - 1);
          first[sizeof(first) - 1] = '\0';
          printf("First string set to: %s\n", first);
          free($2); // 释放动态内存
      }
    | SECOND STRING {
          strncpy(second, $2, sizeof(second) - 1);
          second[sizeof(second) - 1] = '\0';
          printf("Second string set to: %s\n", second);
          free($2); // 释放动态内存
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
          printf("Exiting program...\n");
          exit(0);
      }
    // 第三部分功能：大小写模式切换
    | STRING {
          processMode($1);
          free($1); // 释放动态内存
      }
    ;

%%

// 主函数
int main() {
    int choice;

    printf("Welcome to the Multi-Function String Processor!\n");
    do {
        printf("\n----------------------------------------------\n");
        printf("                Main Menu                     \n");
        printf("----------------------------------------------\n");
        printf("0. Exit\n");
        printf("1. View stored string\n");
        printf("2. Add new word to string\n");
        printf("3. Delete word from string\n");
        printf("4. Replace word in string\n");
        printf("5. Reverse the string\n");
        printf("6. Count number of vowels and consonants\n");
        printf("7. Set first string\n");
        printf("8. Set second string\n");
        printf("9. Concatenate first and second strings\n");
        printf("10. Append last character of first string to second\n");
        printf("11. Process string with case mode\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        getchar(); // 吸收换行符

        switch (choice) {
            case 1: yy_scan_string("view"); yyparse(); break;
            case 2: yy_scan_string("add"); yyparse(); break;
            case 3: yy_scan_string("delete"); yyparse(); break;
            case 4: yy_scan_string("replace"); yyparse(); break;
            case 5: yy_scan_string("reverse"); yyparse(); break;
            case 6: yy_scan_string("vowels_consonants"); yyparse(); break;
            case 7: {
                char input[100];
                printf("Enter the first string: ");
                fgets(input, sizeof(input), stdin);
                input[strcspn(input, "\n")] = '\0';
                char command[110];
                snprintf(command, sizeof(command), "first \"%s\"", input);
                yy_scan_string(command);
                yyparse();
                break;
            }
            case 8: {
                char input[100];
                printf("Enter the second string: ");
                fgets(input, sizeof(input), stdin);
                input[strcspn(input, "\n")] = '\0';
                char command[110];
                snprintf(command, sizeof(command), "second \"%s\"", input);
                yy_scan_string(command);
                yyparse();
                break;
            }
            case 9: yy_scan_string("concat"); yyparse(); break;
            case 10: yy_scan_string("append_last"); yyparse(); break;
            case 11: {
                char input[MAX_LENGTH];
                printf("Enter the string to process: ");
                fgets(input, sizeof(input), stdin);
                input[strcspn(input, "\n")] = '\0';
                char* mode_command = strdup(input);
                yy_scan_string(mode_command);
                yyparse();
                free(mode_command);
                break;
            }
            case 0: printf("Exiting program. Goodbye!\n"); break;
            default: printf("Invalid option. Try again.\n"); break;
        }
    } while (choice != 0);

    return 0;
}

// 函数定义
void reverseString(char* str) {
    int i;
    int len = strlen(str);
    char temp[MAX_LENGTH] = "";
    for (i = len - 1; i >= 0; i--) {
        strncat(temp, &str[i], 1);
    }
    strcpy(str, temp);
}

void countVowelsConsonants(char* str) {
    int vowels = 0, consonants = 0, others = 0;
    for (int i = 0; str[i]; i++) {
        char c = tolower(str[i]);
        if (strchr("aeiou", c)) {
            vowels++;
        } else if ((c >= 'a' && c <= 'z')) {
            consonants++;
        } else if (!isspace(c) && c != '\0') {
            others++;
        }
    }
    printf("\nNumber of vowels: %d\n", vowels);
    printf("Number of consonants: %d\n", consonants);
    printf("Number of other characters: %d\n", others);
}

void addWordToString() {
    printf("Enter the existing word to modify: ");
    fgets(search_word, sizeof(search_word), stdin);
    search_word[strcspn(search_word, "\n")] = '\0';

    char* pos = strstr(sentence, search_word);
    if (!pos) {
        printf("Word not found in string.\n");
        return;
    }

    printf("Enter the new word to add: ");
    fgets(new_word, sizeof(new_word), stdin);
    new_word[strcspn(new_word, "\n")] = '\0';

    printf("Where to place the new word relative to '%s'?\n", search_word);
    printf("1. Front\n2. Back\n");
    int position;
    scanf("%d", &position);
    getchar(); // Consume newline character

    char temp[MAX_LENGTH];
    if (position == 1) { // Add in front
        snprintf(temp, sizeof(temp), "%.*s%s %s%s", (int)(pos - sentence), sentence, new_word, search_word, pos + strlen(search_word));
    } else if (position == 2) { // Add after
        snprintf(temp, sizeof(temp), "%.*s%s %s%s", (int)(pos - sentence), sentence, search_word, new_word, pos + strlen(search_word));
    } else {
        printf("Invalid position.\n");
        return;
    }

    // Clean up any unnecessary spaces
    int i = 0, j = 0;
    while (temp[i]) {
        if (!(temp[i] == ' ' && temp[i + 1] == ' ')) {
            sentence[j++] = temp[i];
        }
        i++;
    }
    sentence[j] = '\0'; // Null-terminate the string
}


void deleteWord() {
    printf("Enter the word to delete: ");
    fgets(search_word, sizeof(search_word), stdin);
    search_word[strcspn(search_word, "\n")] = '\0';

    char* pos = strstr(sentence, search_word);
    if (!pos) {
        printf("Word not found in string.\n");
        return;
    }

    char temp[MAX_LENGTH];
    int prefix_length = pos - sentence;
    snprintf(temp, sizeof(temp), "%.*s%s", prefix_length, sentence, pos + strlen(search_word));
    
    // Remove extra spaces
    int i = 0, j = 0;
    while (temp[i]) {
        if (!(temp[i] == ' ' && temp[i + 1] == ' ')) {
            sentence[j++] = temp[i];
        }
        i++;
    }
    sentence[j] = '\0'; // Null-terminate
}

void replaceWord() {
    printf("Enter the word to replace: ");
    fgets(search_word, sizeof(search_word), stdin);
    search_word[strcspn(search_word, "\n")] = '\0';

    printf("Enter the new word: ");
    fgets(new_word, sizeof(new_word), stdin);
    new_word[strcspn(new_word, "\n")] = '\0';

    char* pos = strstr(sentence, search_word);
    if (!pos) {
        printf("Word not found in string.\n");
        return;
    }

    char temp[MAX_LENGTH];
    int prefix_length = pos - sentence;
    snprintf(temp, sizeof(temp), "%.*s%s%s", prefix_length, sentence, new_word, pos + strlen(search_word));
    strcpy(sentence, temp);
}

void processMode(const char* input) {
    printf("Processing string in mode %d: %s\n", mode, input);
    for (int i = 0; input[i]; i++) {
        if (mode == 1) {
            putchar(tolower(input[i]));
        } else if (mode == 2) {
            putchar(toupper(input[i]));
        } else {
            if (islower(input[i])) {
                putchar(toupper(input[i]));
            } else if (isupper(input[i])) {
                putchar(tolower(input[i]));
            } else {
                putchar(input[i]);
            }
        }
    }
    putchar('\n');
}
