#include<stdio.h>


void print_row (int spaces, int starts);

void print_diamond(int size) {
   
    for (int row = 1; row <= size; row++){
        print_row(size-row, 2* row-1);
    }
    for (int row = size -1; row >= 1; row--){
        print_row(size - row, 2*row-1);
    }
}
 
void print_row(int spaces, int stars) {
    for (int i = 0; i < spaces; i++){
        printf(" ");
    }
    for (int i = 0; i < stars; i++){
        printf("*");
    }
    printf ("\n");
}



/*
void print_diamond(int size){
    

    

    int max = size *2 -1;
    for (int r =1; r <= max; r++){   // outter most loop, start at row 1

        for(int num_space = 0; num_space <= r *2 -1; num_space++){
            printf(' ');
        }

        for (int num_star = 1; num_star <= max; num_star +=2){     // num_of_star = 1; <= size-1; num_of_star +=1
            printf("*");   
        }
        printf("\n");
    }
       
}

*/



