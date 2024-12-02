%{
#include <stdio.h>
#include <string.h>

// Store the story as a single string
char stored[500] = "Yesterday, when I went to the night market, I saw a group of people fighting over a girl! It was unbelievable.";

// Function to display the stored story
void display() {
    printf("\nStored Array:\n");
    printf("%s\n\n", stored);
}

// Function to search for a word in the stored story
void search_word(const char *word) {
    if (strstr(stored, word)) {
        printf("The word '%s' was found in the stored array.\n", word);

        // Ask user for a new word to add
        char new_word[100];
        printf("Enter a new word to add: ");
        scanf("%99s", new_word);

        // Ask whether to add the word at the front or back
        int position_choice;
        printf("Where do you want to add the word?\n");
        printf("1 - At the front of the word\n");
        printf("2 - At the back of the word\n");
        printf("Enter your choice: ");
        scanf("%d", &position_choice);

        if (position_choice == 1) {
            // Add new word at the front of the found word
            char modified_story[500];
            char *insert_pos = strstr(stored, word); // Position of the word found
            int index = insert_pos - stored;  // Index of the found word in the string

            // Copy the part before the word
            strncpy(modified_story, stored, index);
            modified_story[index] = '\0';

            // Add the new word at the front of the found word
            strcat(modified_story, new_word);
            strcat(modified_story, " ");  // Add space after the new word

            // Add the rest of the story
            strcat(modified_story, insert_pos);

            // Update the stored story
            strcpy(stored, modified_story);

        } else if (position_choice == 2) {
            // Add new word after the found word (at the back of the word)
            char modified_story[500];
            char *insert_pos = strstr(stored, word); // Position of the word found
            int index = insert_pos - stored;  // Index of the found word in the string

            // Copy the part before the word
            strncpy(modified_story, stored, index);
            modified_story[index] = '\0';

            // Add the found word (without modification) to the modified story
            strncat(modified_story, insert_pos, strlen(word));  // Copy only the word found
            strcat(modified_story, " ");  // Add space after the found word

            // Add the new word after the found word
            strcat(modified_story, new_word);
            strcat(modified_story, " ");  // Add space after the new word

            // Add the rest of the story after the found word
            strcat(modified_story, insert_pos + strlen(word));

            // Update the stored story
            strcpy(stored, modified_story);

        } else {
            printf("Invalid option. No changes made.\n");
        }

    } else {
        printf("The word '%s' was NOT found in the stored array.\n\n", word);
    }
}

// Function to delete the word from the stored story
void delete_word(const char *word) {
    char *insert_pos = strstr(stored, word);

    if (insert_pos) {
        // Position of the word found
        int index = insert_pos - stored;

        // Shift the part after the word left by the length of the word
        memmove(stored + index, stored + index + strlen(word), strlen(stored) - index - strlen(word) + 1);

        printf("The word '%s' has been removed from the stored array.\n\n", word);
    } else {
        printf("The word '%s' was NOT found in the stored array.\n\n", word);
    }
}

// Function to replace the searched word with the new word
void replace_word(const char *word, const char *new_word) {
    char *insert_pos = strstr(stored, word);

    if (insert_pos) {
        // Position of the word found
        int index = insert_pos - stored;

        // Create a temporary modified story
        char modified_story[500];
        int word_length = strlen(word);
        int new_word_length = strlen(new_word);

        // Copy part before the word
        strncpy(modified_story, stored, index);
        modified_story[index] = '\0';

        // Add the new word to the modified story
        strcat(modified_story, new_word);

        // Add the part after the word
        strcat(modified_story, insert_pos + word_length);

        // Update the stored story
        strcpy(stored, modified_story);

        printf("The word '%s' has been replaced with '%s'.\n\n", word, new_word);
    } else {
        printf("The word '%s' was NOT found in the stored array.\n\n", word);
    }
}

%}

%%

"1"        { display(); }
"2"        { 
               char word[100];
               printf("Enter a word to search: ");
               scanf("%99s", word);  // Read a word from the user
               search_word(word);
           }
"3"        { 
               char word[100];
               printf("Enter a word to delete: ");
               scanf("%99s", word);  // Read a word from the user
               delete_word(word);
           }
"4"        { 
               char word[100], new_word[100];
               printf("Enter a word to replace: ");
               scanf("%99s", word);  // Read the word to search
               printf("Enter a new word: ");
               scanf("%99s", new_word);  // Read the new word
               replace_word(word, new_word);  // Replace the word
           }
\n         { /* Ignore newline characters */ }
.          { printf("Invalid option. Please try again.\n\n"); }

%%

int yywrap() {
    return 1;
}

int main() {
    int choice;
    
    while (1) {
        printf("\nSelect an option:\n");
        printf("1 - View stored array\n");
        printf("2 - Add a word in the array\n");
        printf("3 - Delete a word from the array\n");
        printf("4 - Replace a word in the array\n");
        printf("5 - Exit\n");
        printf("Enter your choice: ");
        
        scanf("%d", &choice);  // Read the user choice
        
        // Switch based on user input
        if (choice == 1) {
            display();
        } else if (choice == 2) {
            char word[100];
            printf("Enter a word to search: ");
            scanf("%99s", word);  // Read a word from the user
            search_word(word);
        } else if (choice == 3) {
            char word[100];
            printf("Enter a word to delete: ");
            scanf("%99s", word);  // Read a word from the user
            delete_word(word);
        } else if (choice == 4) {
            char word[100], new_word[100];
            printf("Enter a word to replace: ");
            scanf("%99s", word);  // Read the word to search
            printf("Enter a new word: ");
            scanf("%99s", new_word);  // Read the new word
            replace_word(word, new_word);  // Replace the word
        } else if (choice == 5) {
            printf("Exiting program...\n\n");
            break;  // Exit the loop and terminate the program
        } else {
            printf("Invalid option. Please try again.\n\n");
        }
    }

    return 0;
}
