%{
#include <stdio.h>
#include <string.h>
#include <stdlib.h>
#include <ctype.h>

#define MAX_LEN 1024  // Maximum length for concatenated string

char concatenated[MAX_LEN];  // Buffer to hold the concatenated result

// Flags and Counters
int word_count = 0;
int line_count = 0;
int space_count = 0;
int char_count = 0;
int concat_mode = 0;  // Tracks whether concatenation is in progress

// Function to check if a word is a palindrome
int is_palindrome(const char *str) {
    int len = strlen(str);
    for (int i = 0; i < len / 2; i++) {
        if (tolower(str[i]) != tolower(str[len - i - 1])) {
            return 0;  // Not a palindrome
        }
    }
    return 1;  // Is a palindrome
}
%}

%%

[a-zA-Z]+   { 
    word_count++;
    char_count += yyleng;  // Count the word length

    if (concat_mode) {
        // Concatenate only if '+' was seen before this word
        if (strlen(concatenated) + yyleng < MAX_LEN) {
            strcat(concatenated, yytext);
        } else {
            fprintf(stderr, "Buffer overflow: concatenated string is too long.\n");
            exit(1);
        }
    }

    // Check for palindrome
    if (is_palindrome(yytext)) {
        printf("Palindrome found: %s\n", yytext);
    }

    if (!concat_mode) {
        // If not in concat mode, reset the concatenated buffer
        concatenated[0] = '\0';
        strcat(concatenated, yytext);
    }
}

"+"         { 
    concat_mode = 1;  // Enable concatenation mode
    char_count++;     // Count '+' as a character
}

[ \t]       { 
    space_count++;  // Count spaces and tabs
    char_count++;   // Count space/tab as a character
}

\n          { 
    line_count++;  // Count the newline as a new line
    char_count++;  // Count the newline as a character

    if (strlen(concatenated) > 0) {
        printf("Concatenated string: %s\n", concatenated);
    }

    // Reset flags and buffer
    concatenated[0] = '\0';
    concat_mode = 0;
}

.           { 
    char_count++;  // Count any other character
}

%%

int main() {
    concatenated[0] = '\0';  // Initialize the concatenated buffer
    printf("Enter text (Ctrl+D to end):\n");
    yylex();
    printf("\n--- Statistics ---\n");
    printf("Words: %d\n", word_count);
    printf("Lines: %d\n", line_count);
    printf("Spaces: %d\n", space_count);
    printf("Characters: %d\n", char_count);
    return 0;
}

int yywrap() {
    return 1;  // End of input
}
