#include "wordle.h"
#include <stdlib.h>
#include <stdio.h>
#include <stdlib.h>
#include <string.h>



// allocate 内存分配
// Syntax: void* malloc(size_t size);
// free()
// 5 leatter words, + "\n" = 6 bytes

// 1.  The array itself
// 2.  The number of elements in the array (its length): strlen(list)
// 3.  The maximum number of elements in the array:( cap, its capacity )
//     which is double speace of char *list; ask

char **read_word_list(char *filename) {  // open file, read, if fp(file-array) == NULL, means
    FILE *fp = fopen(filename, "r");
    if (fp == NULL) return NULL;
    int cap = 32;  // 32 bytes. (resonable number, not too big and not too small to end quickly.)
    char **list = malloc(sizeof(char *) * cap); // 分配有效内存
    char line[16];
    int count = 0;

    while (fgets(line, 16, fp) != NULL){

        if (count >= cap){
            cap *= 2;
            list = realloc(list, sizeof(char**) * cap);
        }
        if (line[5] == '\n') { //(strlen(line) == 6 && line[5] == '\n'){
            line[5] = '\0';  // review
            char* word = malloc(6 * sizeof(char));
            strcpy(word, line);
            list[count] = word;
            count ++;
        }

    }
    list[count] = NULL;
    fclose(fp);
    return list;
}
		
void free_word_list(char **list) {
	int i = 0;
	while (list[i] != NULL) {
		free(list[i]);
		i++;
	}
	free(list);
}
