%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>

extern char* yytext;
extern int yylex();
extern FILE *yyin;

int yyparse();
void yyerror(const char *s) {
    fprintf(stderr, "Error: %s\n", s);
}

#define MAX_LENGTH 1000

// Define global variables
int vowels = 0, consonants = 0, others = 0;

/* Function to reverse and print the string */
void reverseString(const char* str) {
    int length = strlen(str);
    int i;
    printf("\nReversed string: ");
    for (i = length - 1; i >= 0; i--) {
        putchar(str[i]);
    }
    printf("\n");
}

/* Function to count vowels, consonants, and other characters */
void countVowelsConsonants(const char* str) {
    vowels = consonants = others = 0; // Reset counters
    int i;
    for (i = 0; str[i] != '\0'; i++) {
        if ((str[i] >= 'a' && str[i] <= 'z') || (str[i] >= 'A' && str[i] <= 'Z')) {
            if (strchr("aeiouAEIOU", str[i])) {
                vowels++;
            } else {
                consonants++;
            }
        } else if (str[i] != ' ' && str[i] != '\t' && str[i] != '\n') {
            others++;
        }
    }

    printf("\nTotal vowels = %d", vowels);
    printf("\nTotal consonants = %d", consonants);
    printf("\nOther characters = %d\n", others);
}
%}

%union {
    char* str_val;
}

%token <str_val> STRING
%token REVERSE VOWELS_CONSONANTS

%%

statement_list: statement_list statement | statement;

statement: REVERSE STRING {
        printf("\nReversing the string: %s\n", $2);
        reverseString($2);
        free($2); // Free the dynamically allocated string
    }
    | VOWELS_CONSONANTS STRING {
        printf("\nFinding vowels and consonants in the string: %s\n", $2);
        countVowelsConsonants($2);
        free($2); // Free the dynamically allocated string
    }
;

%%

int main() {
    int choice;
    char input[MAX_LENGTH];
    char command[MAX_LENGTH + 20]; // Buffer for command with additional space for the operation

    do {
        printf("\n----------------------------------\n");
        printf("         String Processing\n");
        printf("----------------------------------\n");
        printf("0. Exit\n");
        printf("1. Reverse string\n");
        printf("2. Find total vowels and consonants\n");
        printf("Enter your choice: ");
        scanf("%d", &choice);
        getchar(); // Consume the newline character

        if (choice == 1 || choice == 2) {
            printf("\nEnter the input string:\n");
            fgets(input, MAX_LENGTH, stdin);

            // Remove trailing newline character
            input[strcspn(input, "\n")] = '\0';

            if (choice == 1) {
                sprintf(command, "reverse \"%s\"", input); // Build the command string
                yy_scan_string(command);
                yyparse();
            } else if (choice == 2) {
                sprintf(command, "vowels_consonants \"%s\"", input); // Build the command string
                yy_scan_string(command);
                yyparse();
            }
        } else if (choice != 0) {
            printf("\nInvalid choice. Please try again.\n");
        }

    } while (choice != 0);

    printf("\nExiting program. Goodbye!\n");
    return 0;
}
