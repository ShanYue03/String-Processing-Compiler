/* Definition section */
%{
#include <stdio.h>
int vowels = 0, consonants = 0, others = 0;
%}



/* Define patterns and macros (token matching) */
vowel [aeiouAEIOU]
consonant [bcdfghjklmnpqrstvwxyzBCDFGHJKLMNPQRSTVWXYZ]



/* Rule section */
%%
[ \t\n]+ ; //ignore space, tab, newline
{vowel} {vowels++;}
{consonant} {consonants++;}
[^a-zA-Z \t\n] {others++;}
%%



/* User code section */
int main()
{
	printf("Enter the input string:\n");
	yylex(); //send to rule section with the help of yylex
	printf("\nTotal vowels = %d", vowels);
	printf("\nTotal consonants = %d", consonants);
	printf("\nOther characters = %d", others);
}

int yywrap()
{
	return 1;
}