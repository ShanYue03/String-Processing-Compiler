%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_LENGTH 1000

// Global variables
char sentence[MAX_LENGTH] = "";
char concatenated[MAX_LENGTH] = "";
char search_word[100] = "";
char new_word[100] = "";

// Function prototypes
void reverseString(char* str);
void countVowelsConsonants(char* str);
void addWordToString();
void deleteWord();
void replaceWord();
void findPalindrome();
void countWordsLinesSpacesChars();
void changeCase();
void concatenateStrings();
void PrintWithLength(const char* input);
void PrintLongestWord(const char* input);
void resetBuffer();

void yyerror(const char* s) {
    fprintf(stderr, "Error: %s\n", s);
}

int yylex();
%}

%union {
    char* str_val;
}

%token REVERSE VOWELS_CONSONANTS VIEW ADD_WORD DELETE_WORD REPLACE_WORD PALINDROME COUNT CHANGE_CASE PRINT_STRINGS LONGEST_STRING
%token <str_val> WORD STRING
%token PLUS SPACE NEWLINE CHAR
%token CONCATENATE


%%

program:
    | program statement
    ;

statement:
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
    | PALINDROME {
          findPalindrome();
      }
    | COUNT {
          countWordsLinesSpacesChars();
      }
    | CHANGE_CASE {
          changeCase();
      }
    | CONCATENATE {
          concatenateStrings();
      }
	| PRINT_STRINGS {
	      PrintWithLength(sentence);
	  }
	| LONGEST_STRING{
	      PrintLongestWord(sentence);
	  }
    ;
;

%%

int main() {
    printf("Please enter a string: ");
    fgets(sentence, sizeof(sentence), stdin);
    sentence[strcspn(sentence, "\n")] = '\0';

    int choice;
    do {
        printf("\n----------------------------------------------\n");
        printf("                String Processing              \n");
        printf("----------------------------------------------\n");
        printf("0. Exit\n");
        printf("1. View stored string\n");
        printf("2. Add new word to string\n");
        printf("3. Delete word from string\n");
        printf("4. Replace word in string\n");
        printf("5. Reverse the string\n");
        printf("6. Count number of vowels and consonants\n");
        printf("7. Concatenate strings\n");
        printf("8. String case conversion\n");
        printf("9. Find palindromes\n");
        printf("10. Count words, lines, spaces, and characters\n");
		printf("11. Print string with length.\n");
		printf("12. Print longest length.\n");
        printf("Enter option: ");
        scanf("%d", &choice);
        getchar();

        switch (choice) {
            case 1: yy_scan_string("view"); yyparse(); break;
            case 2: yy_scan_string("add"); yyparse(); break;
            case 3: yy_scan_string("delete"); yyparse(); break;
            case 4: yy_scan_string("replace"); yyparse(); break;
            case 5: yy_scan_string("reverse"); yyparse(); break;
            case 6: yy_scan_string("vowels_consonants"); yyparse(); break;
            case 7: yy_scan_string("concat"); yyparse(); break;
            case 8: yy_scan_string("case"); yyparse(); break;
            case 9: yy_scan_string("palindrome"); yyparse(); break;
            case 10: yy_scan_string("count"); yyparse(); break;
			case 11: yy_scan_string("print_strings"); yyparse(); break;
			case 12: yy_scan_string("longest"); yyparse(); break;
            case 0: printf("Exiting program. Goodbye!\n"); break;
            default: printf("Invalid option. Try again.\n"); break;
        }
    } while (choice != 0);

    return 0;
}

// Function definitions
void reverseString(char* str) {
    int len = strlen(str);
    char temp[MAX_LENGTH] = "";

    int i;
    for (i = len - 1; i >= 0; i--) {
        strncat(temp, &str[i], 1);
    }
    strcpy(str, temp);
}

void countVowelsConsonants(char* str) {
    int vowels = 0, consonants = 0, others = 0;

    int i;
    for (i = 0; str[i]; i++) {
        char c = tolower(str[i]);
        if (strchr("aeiou", c)) {
            vowels++;
        } else if (isalpha(c)) {
            consonants++;
        } else if (!isspace(c) && c != '\0') {
            others++;
        }
    }
    printf("\nNumber of vowels: %d\n", vowels);
    printf("Number of consonants: %d\n", consonants);
    printf("Number of other characters: %d\n", others);
}

void findPalindrome() {
    char temp[MAX_LENGTH];
    strcpy(temp, sentence);

    char* word = strtok(temp, " \n");
    int found = 0;
    while (word != NULL) {
        int len = strlen(word);
        int is_palindrome = 1;

        int i;
        for (i = 0; i < len / 2; i++) {
            if (tolower(word[i]) != tolower(word[len - i - 1])) {
                is_palindrome = 0;
                break;
            }
        }
        if (is_palindrome) {
            printf("Palindrome found: %s\n", word);
            found = 1;
        }
        word = strtok(NULL, " \n");
    }
    if (!found) {
        printf("No palindromes found.\n");
    }
}

void countWordsLinesSpacesChars() {
    int words = 0, lines = 1, spaces = 0, chars = 0;
    int in_word = 0;

    int i;
    for (i = 0; sentence[i]; i++) {
        chars++;
        if (sentence[i] == '\n') {
            lines++;
        }
        if (isspace(sentence[i])) {
            spaces++;
            in_word = 0;
        } else if (!in_word) {
            words++;
            in_word = 1;
        }
    }

    printf("\nWords: %d\n", words);
    printf("Lines: %d\n", lines);
    printf("Spaces: %d\n", spaces);
    printf("Characters: %d\n", chars);
}

void changeCase() {
    int mode;
    printf("Choose mode (1: all lowercase, 2: all uppercase, 3: swap case): ");
    scanf("%d", &mode);
    getchar();

    int i;
    for (i = 0; sentence[i]; i++) {
        if (mode == 1) {
            sentence[i] = tolower(sentence[i]);
        } else if (mode == 2) {
            sentence[i] = toupper(sentence[i]);
        } else {
            if (isupper(sentence[i])) {
                sentence[i] = tolower(sentence[i]);
            } else if (islower(sentence[i])) {
                sentence[i] = toupper(sentence[i]);
            }
        }
    }
    printf("Updated string: %s\n", sentence);
}

void concatenateStrings() {
    char input[MAX_LENGTH];
    concatenated[0] = '\0'; // Reset concatenated buffer

    printf("Enter the string you wish to concatenate: ");
    fgets(input, sizeof(input), stdin);
    input[strcspn(input, "\n")] = '\0'; // Remove trailing newline

    // Remove spaces and concatenate words
    int i, j = 0;
    for (i = 0; input[i] != '\0'; i++) {
        if (!isspace(input[i])) {
            concatenated[j++] = input[i];
        }
    }
    concatenated[j] = '\0'; // Null-terminate the string

    printf("Concatenated string: %s\n", concatenated);
}

void resetBuffer() {
    concatenated[0] = '\0';
}

void addWordToString() {
    printf("Enter the existing word to modify: ");
    fgets(search_word, sizeof(search_word), stdin);
    search_word[strcspn(search_word, "\n")] = '\0';

    printf("Enter the new word to add: ");
    fgets(new_word, sizeof(new_word), stdin);
    new_word[strcspn(new_word, "\n")] = '\0';

    printf("Where to place the new word relative to '%s'?\n", search_word);
    printf("1. Front\n2. Back\n");
    int position;
    scanf("%d", &position);
    getchar();

    char* pos = strstr(sentence, search_word);
    if (!pos) {
        printf("Word not found in string.\n");
        return;
    }

    char temp[MAX_LENGTH];
    if (position == 1) {
        snprintf(temp, sizeof(temp), "%.*s%s %s%s", (int)(pos - sentence), sentence, new_word, search_word, pos + strlen(search_word));
    } else {
        snprintf(temp, sizeof(temp), "%.*s%s %s%s", (int)(pos - sentence), sentence, search_word, new_word, pos + strlen(search_word));
    }
    strcpy(sentence, temp);
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
    snprintf(temp, sizeof(temp), "%.*s%s", (int)(pos - sentence), sentence, pos + strlen(search_word));
    // Remove extra space
    char* end_space = strstr(temp, "  ");
    if (end_space) {
        memmove(end_space, end_space + 1, strlen(end_space));
    }
    strcpy(sentence, temp);
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
    snprintf(temp, sizeof(temp), "%.*s%s%s", (int)(pos - sentence), sentence, new_word, pos + strlen(search_word));
    strcpy(sentence, temp);
}

void PrintWithLength(const char* input) {
    int MAX_WORDS = 100;
	int MAX_WORD_LENGTH = 100;
    char words[MAX_WORDS][MAX_WORD_LENGTH];
    int count = 0;

    // Temporary copy of input to tokenize
    char temp[strlen(input) + 1];
    strcpy(temp, input);

    // Tokenize the string using space as a delimiter
    char* token = strtok(temp, " ");
    while (token != NULL && count < MAX_WORDS) {
        strncpy(words[count], token, MAX_WORD_LENGTH - 1);
        words[count][MAX_WORD_LENGTH - 1] = '\0';
        count++;
        token = strtok(NULL, " ");
    }

    // Print each word and its length
    printf("Split words and their lengths:\n");
	int i=0;
    for (i = 0; i < count; i++) {
        printf("Word: '%s', Length: %lu\n", words[i], strlen(words[i]));
    }
}

void PrintLongestWord(const char* input) {
    char temp[strlen(input) + 1];
    strcpy(temp, input);

    char* token = strtok(temp, " ");
    char* longest_word = NULL;
    int max_length = 0;

    while (token != NULL) {
        int length = strlen(token);
        if (length > max_length) {
            max_length = length;
            longest_word = token;
        }
        token = strtok(NULL, " ");
    }

    if (longest_word) {
        printf("Longest word: '%s', Length: %d\n", longest_word, max_length);
    } else {
        printf("No words found.\n");
    }
}