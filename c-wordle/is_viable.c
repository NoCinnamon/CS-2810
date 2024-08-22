#include <stdbool.h>
#include "wordle.h"
#include "string.h"
#include "stddef.h"


bool is_viable_candidate(char *candidate, guess *guesses, int guess_count) {

    char copy[6];

    // loop 5 letters of guess(there are many guesses for 5letters), then make a copy
    for (int i=0; i<guess_count; i++){
        strcpy(copy, candidate);   // now you have copy of the candidate.

        for (int j=0; j<5; j++){
            // checking guesses's feedback/letters at position with copy's feedback/letter at same position
            if (guesses[i].feedback[j] == EXACT_HIT && copy[j] != guesses[i].letters[j]){

            // if those are !=, then False.
                return false;
            }
            if(guesses[i].feedback[j] == EXACT_HIT){
                copy[j] = '_';   // just '_', not "'_'".
            }
        }

        for (int j=0; j<5; j++){
             // check same position in PARTIAL_HIT:
            if (guesses[i].feedback[j] == PARTIAL_HIT && copy[j] == guesses[i].letters[j]){
                return false;
            }
        }
        for (int j=0; j<5; j++){
            // check different position in PARTIAL_HIT:
            if  (guesses[i].feedback[j] == PARTIAL_HIT){
                int k = 0;
				for (; k < 5; k++) {
					if (copy[k] == guesses[i].letters[j]){


					// Cross letters off in the copy
						copy[k] = '_';
                        break;  // dont forget this
			        }

                }
                if (k >= 5) {
                    return false;
                }
            }
        }

        for (int j=0; j<5; j++){
            // check MISS                         here: doesn't match anything
            if (guesses[i].feedback[j] == MISS){
                for (int k = 0; k < 5; k++) {
					if (copy[k] == guesses[i].letters[j]){
                        return false;
                    }
                }
            }
        }
    }
    return true;
}
