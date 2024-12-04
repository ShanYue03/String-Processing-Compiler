%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h> // Include for tolower function

#define MAX_LENGTH 1000

// Global variables
char sentence[MAX_LENGTH] = "";
char search_word[100] = "";
char new_word[100] = "";

// Function prototypes
void reverseString(char* str);
void countVowelsConsonants(char* str);
void addWordToString();
void deleteWord();
void replaceWord();

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
    ;

%%

int main() {
    int choice; // Declare 'choice'
    
    printf("Please enter a string: ");
    fgets(sentence, sizeof(sentence), stdin);
    sentence[strcspn(sentence, "\n")] = '\0'; // Remove trailing newline

    do {
        printf("\n----------------------------------------------\n");
        printf("                String Processing              \n");
        printf("----------------------------------------------\n");
        printf("0. Exit\n");
        printf("1. View stored string\n");
        printf("2. Add new word to string\n");
        printf("3. Delete word from string\n");
        printf("4. Replace word from string\n");
        printf("5. Reverse the string\n");
        printf("6. Count number of vowels and consonants\n");
        printf("Enter option: ");
        scanf("%d", &choice);
        getchar(); // Consume newline

        switch (choice) {
            case 1: yy_scan_string("view"); yyparse(); break;
            case 2: yy_scan_string("add"); yyparse(); break;
            case 3: yy_scan_string("delete"); yyparse(); break;
            case 4: yy_scan_string("replace"); yyparse(); break;
            case 5: yy_scan_string("reverse"); yyparse(); break;
            case 6: yy_scan_string("vowels_consonants"); yyparse(); break;
            case 0: printf("Exiting program. Goodbye!\n"); break;
            default: printf("Invalid option. Try again.\n"); break;
        }
    } while (choice != 0);

    return 0;
}

// Function definitions
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
    int i; // Declare loop variable outside of 'for' loop
    for (i = 0; str[i]; i++) {
        char c = tolower(str[i]);
        if (strchr("aeiou", c)) {
    vowels++;
	} else if ((c >= 'a' && c <= 'z')) {
    	consonants++;
	} else if (!isspace(c) && c != '\0') { // Count characters that are not spaces and not null terminators
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
    getchar();

    char temp[MAX_LENGTH];
    if (position == 1) { // Front
        snprintf(temp, sizeof(temp), "%.*s%s %s%s", (int)(pos - sentence), sentence, new_word, search_word, pos + strlen(search_word));
    } else if (position == 2) { // Back
        snprintf(temp, sizeof(temp), "%.*s%s %s%s", (int)(pos - sentence), sentence, search_word, new_word, pos + strlen(search_word));
    } else {
        printf("Invalid position.\n");
        return;
    }

    // Remove unnecessary spaces
    int i = 0, j = 0;
    while (temp[i]) {
        if (!(temp[i] == ' ' && temp[i + 1] == ' ')) {
            sentence[j++] = temp[i];
        }
        i++;
    }
    sentence[j] = '\0'; // Null-terminate
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
