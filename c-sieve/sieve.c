#include <assert.h>
#include <stdbool.h>
#include <stdio.h>
#include <stdlib.h>

#define MAX_N 10000

void sieve(bool *array, int size){
    for (int i = 0; i < size; i++){
        array[i] = 1;  
    }
                                                                 // walk through array set each *array  = true.   

    for (int i = 2; i*i <= size; i++) {                          // start from i=2, 直到i的平方，前提是2的平方不能超过设定的range 
        if (array[i]) {                                          // since it is all bool values, if it is true,          
            for (int j = i+i; j < size; j += i) {
                array[j] = false;
            }
        }
    } 
}


