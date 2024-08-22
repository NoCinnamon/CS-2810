                .global array_sum
                .text

# int array_sum(int *array, int count, int threshold)
array_sum:
                # a0: array
                # a1: count
                # a2: threshold
                # a3: sum = 0 now
                # a4: i = 1
                # a5: elt = array[i]
                # t0: current

                li a3, 0
                li a4, 0

 1:             bge a4, a1, 2f
                slli t0,a4, 3
                add t0, a0, t0
                ld a5, (t0)
                blt a5, a2, 3f
                add a3, a3, a5
 3:             addi a4, a4, 1
                j 1b
 2:             mv a0, a3

                ret
