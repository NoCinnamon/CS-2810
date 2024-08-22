#include <stdio.h>
#include <ctype.h>


// alphabetical order
// lower-case
// dont forget the new line '\n'

// tolower() 
// tolower_l() function takes unsigned char/ value of EOF;

// "", .  "" dont need to worry ',.', tolower will taking care of it.


void letters_used(char *line) {
    int letters[26] = {0}; 
    int i, k;
    for (i = 0; line[i] != '\0'; i++) {

        if (isalpha(line[i])){                  // if it is letter:
            char lo_case = tolower(line[i]);    // make it lower case.
            
            
            // this is - Acci value, 'a' - 'a' = 0; false
            //                       'b' - 'a' = 1; true
            //                       'c' -'a'  = 1
            // 如果遇到重复的字母 就变成0， false。
            k = lo_case - 'a';              
            letters[k] = 1;
        }
    }


    for (int i = 0; i < 26; i++) {
        if (letters[i]) {
            char letter = 'a' + i;
            printf("%c", letter);
        }
    }
    printf("\n");
}



// Common Format Specifiers:
// %d: Integer
// %f: Floating-point number
// %c: Character
// %s: String
