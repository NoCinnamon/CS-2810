#include "wordle.h"
#include <stdbool.h>
#include <stdlib.h>
#include "stddef.h"
#include <string.h>

//Constant values: defined in 'wordle.h'
//  `EXACT_HIT_POINTS` == 5;
// `PARTIAL_HIT_POINTS` == 1;

int score(char **word_list, char *candidate, guess *guesses, int guess_count){

    char copy[6];
    int i, j, k;

    int total_score = 0;
    // you were define 'int candidate_score = 0;' here, don't, because you are resetting it to 0 every time.
    for (i=0; word_list[i] != NULL; i++){
        strcpy(copy, word_list[i]);
        int candidate_score = 0;
        if (!is_viable_candidate(word_list[i], guesses, guess_count)){
        // above, use'!' instead of :'if (is_viable_candidate(word_list[i], guesses, guess_count) ==false)'
            continue; 
        }

        for (j=0; j<5; j++){
            if (candidate[j] == copy[j]){
                copy[j] = '_';
                candidate_score += EXACT_HIT_POINTS;
            }
        }

        for (j=0; j<5; j++){
            for (k=0; k<5; k++){
                if (candidate[j] == copy[k] && candidate[j] != copy[j]){
                    copy[k] = '_';
                    candidate_score += PARTIAL_HIT_POINTS;
                    break;
                }
            }
        }


        total_score += candidate_score;

    }
    return total_score;
}
