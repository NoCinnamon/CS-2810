#include <stdio.h>
#include  "compute.h" // this is prototype
// 2 array, at same index, if it is not the same, that count as 1 Hamming Distance

// check the lenth of string first, if lengt_A != length_B, return -1
// for (declaration; check condition; incrementor)
// array['a', 'b', 'c', ' ', 'c', '\0'] need to have "'\0', null terminated string chararecter" at the end.
// char* single chararector pointer


int compute(char* ham_A, char* ham_B){
    int count = 0;

    while (*ham_A && *ham_B){

        if(*ham_A != *ham_B){
            count++;
        }

        ham_A++;
        ham_B++;
    }

    if (*ham_A != *ham_B){
        return -1;
    }

    return count;
}








    // int count = 0;
    // for (;*ham_A == '\0' && *ham_B == '\0'; ham_A++, ham_B++){
    //     if (*ham_A == '\0' && *ham_B != '\0' ) {
    //         return -1;
    //     }
    //     if (*ham_A != '\0' && *ham_B == '\0'){
    //         return -1;
    //     }
    //     if (*ham_A != *ham_B) {
    //         count++;
    //     }
    // }
    // return count;



//     int count = 0;
//     if (strlen(ham_A) != strlen(ham_B)) {
//         return -1;
//     }
//     for (int index = 0; index < str(ham_A); index++) {
//         if (ham_A[index] != ham_B[index]) {
//             count++;
//         }
//     }
//     return count;
// }
