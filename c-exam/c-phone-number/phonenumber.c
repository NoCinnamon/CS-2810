#include "phonenumber.h"
#include <stdio.h>
#include <ctype.h> 

// area code is (435),plus ' ',  rest start at line[i=6]
// second 3 number propbly is pointer pointed to address of all 3.
// prefix: middle 4, 3+ " "
// line_number: last 5, 4+ " "

void format_phone_number(char *line) {
    char area_code[4], prefix[4], line_number[5];
    int i = 0;
    while (line[i] && !isdigit(line[i])) {
        i++;
    }
    if (isdigit(line[i]) && isdigit(line[i + 1]) && isdigit(line[i + 2])) {
        area_code[0] = line[i];
        area_code[1] = line[i + 1];
        area_code[2] = line[i + 2];
        area_code[3] = '\0';  
        i += 3;
    }
    else {
        printf("Invalid input\n");
        return;
    }



    while (line[i] && !isdigit(line[i])) {
        i++;
    }

    if (isdigit(line[i]) && isdigit(line[i + 1]) && isdigit(line[i + 2])) {
        prefix[0] = line[i];
        prefix[1] = line[i + 1];
        prefix[2] = line[i + 2];
        prefix[3] = '\0'; 
        i += 3;
    }
    else {
        printf("Invalid input\n");
        return;
    }



    while (line[i] && !isdigit(line[i])) {
        i++;
    }

    if (isdigit(line[i]) && isdigit(line[i + 1]) && isdigit(line[i + 2]) && isdigit(line[i + 3])) {
        line_number[0] = line[i];
        line_number[1] = line[i + 1];
        line_number[2] = line[i + 2];
        line_number[3] = line[i + 3];
        line_number[4] = '\0';  
        i += 4;
    } 
    else {
        printf("Invalid input\n");
        return;
    }




    while (line[i] && !isdigit(line[i])) {
        i++;
    }

    if (line[i] == '\0') {
        printf("(%s) %s-%s\n", area_code, prefix, line_number);
    } 
    else {
        printf("Invalid input\n");
    }
}

// yea, you aare fine, not infint loop, just take couple seconds longer.