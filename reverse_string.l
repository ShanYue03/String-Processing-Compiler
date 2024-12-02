/* Definition section */
%{

#include <stdio.h>
#include <string.h>
#define MAX_LENGTH 1000

char arr[MAX_LENGTH];
int pos = 0; // Keeps track of the current position in the input array

void reverseString(const char* str); // Function prototype
%}


/* Rule section */
%%
.   { arr[pos++] = yytext[0]; } // Match any character and store it
\n  { 
        arr[pos] = '\0';       // Null-terminate the string
        reverseString(arr);    // Call function to reverse the string
        pos = 0;               // Reset position for the next input
    }
%%


/* Function to reverse and print the string */
void reverseString(const char* str) {
    int length = strlen(str);
    printf("Reversed string: ");
    int i;  // Declare outside the loop
    for (i = length - 1; i >= 0; i--) {
        putchar(str[i]);
    }
    printf("\n");
}


/* User code section */
int main() {
    printf("Enter a string to reverse :\n");
    yylex();
    return 0;
}


int yywrap() {
    return 1;
}
