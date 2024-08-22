#include <stdio.h>
#include "solve.h"

// write your code here
// note that solve.h is included. Look at that file
// to see what values are already defined for you and
// what your function signatures should match. You do not
// need to copy anything from main.c or solve.h into this file.



void print_maze(char field[SIZE_Y][SIZE_X]) {
	for (int y = 0; y < SIZE_Y; y++) {
        	for (int x = 0; x < SIZE_X; x++) {
            	putchar(field[y][x]);           // printf("%c", field[y][x]);
        	}
        	putchar('\n');    					//printf("\n");
    		}
}

void solve_maze(char field[SIZE_Y][SIZE_X]){
    // (void) field;
	int changed = 1;
	while(changed){    // dont do changed = 1
		changed = 0;
		for (int y =1; y < SIZE_Y-1; y++){
			for (int x =1; x < SIZE_X -1; x++){ // not SIZE_X-2
				if (field[y][x] == '.'){
					int wall =0;
					// int change = 0;
					if (field[y-1][x] =='@'){
						wall++;
					} 
					if (field[y+1][x]=='@'){
						wall++;
					}
					if (field[y][x-1] =='@'){
						wall++;
					} 
					if (field[y][x+1]=='@'){
						wall++;
					}
					if (wall == 3){
						field[y][x] = '@';
						changed = 1;
					}
				}		
				  //return 0; dont return, it returns nothing 
			}
		}
	}
}

