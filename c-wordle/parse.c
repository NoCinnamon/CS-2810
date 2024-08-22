#include "wordle.h"


// *   Green: letter      correct
//            position    correct

// *   Yellow:  letter      correct
//              position    wrong

// *   Gray: letter      wrong
//           position    wrong

// letter:  holds guess

// feedback: holds color

// *   MISS : a gray letter (does not appear in solution word)

// *   [ EXACT_HIT ]: a green letter (correct letter in correct position)

// *   ( PARTIAL_HIT ): a yellow letter (correct letter in incorrect position)

//  enum feedback { MISS, EXACT_HIT, PARTIAL_HIT };
//  typedef struct {
// 	char letters[6];    // 6 chars in letters, 5 + '\n'
// 	enum feedback feedback[5]; //建立一个variable 叫 feedback 它包括 5 个enum feedback， which has {MISS, EXACT_HIT, PARTIAL_HIT};
//  } guess;

guess parse_guess(char *line) {
	guess guess; // Guess struct to store the guess and feedback
	int j = 0;
	for (int i = 0; i < 5; i++){
		bool close = false;
		if (line[j] == '[') {
			guess.feedback[i] = EXACT_HIT;
			j++;
			close = true;
		}
		else if (line[j] == '(') {
			guess.feedback[i] = PARTIAL_HIT;
			j++;
			close = true;
		}
		else {
			guess.feedback[i] = MISS;
		}
		if (line[j] >= 'a' && line[j] <= 'z') {
			guess.letters[i] = line[j];
		}
		j++;
		if (close) {
			j++;
		}
	}
	return guess;

}
