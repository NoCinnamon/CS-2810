                .global array_sum
                .text

# int array_sum(int *array, int count)
array_sum:      # s0: array
                # s1: length of array
                # s3: sum
                # s4: current array element

                addi    sp, sp, -48
                sd      ra, 40(sp)
                sd      s0, 32(sp)
                sd      s1, 24(sp)
                sd      s2, 16(sp)
                sd      s3, 8(sp)
                sd      s4, 0(sp)

                # load all registers
                mv      s0, a0
                mv      s1, a1
                li      s2, 0               #                 li a2, 0
                li      s3, 0               #                 li a3, 0


                # a0: array (int)
                # a1: count (int)
                # predicate
                # a2: sum = 0
                # a3: i = 0
                # a4: array[i] (elt)
                # t0: current


1:              bge     s2, s1, 2f          #  1:             bge  a3, a1, 2f
                ld      s4, 0(s0)           #                 mv a0, a4 addi a3, a3, 1

                # call function predicate
                mv      a0, s4              #                 Before calling, need to load first.
                call    predicate           #                 jal predicate

                beqz    a0, 3f              #                 beqz a0, 3f

                # add to sum
                add     s3, s3, s4          #                 add a2, a2, a4

3:              addi    s0, s0, 8
                addi    s2, s2, 1
                j       1b

2:              mv a0, s3                   #  2:             mv a0, a2

                # before ret, load the registers back (just copy & paste)
                ld      ra, 40(sp)
                ld      s0, 32(sp)
                ld      s1, 24(sp)
                ld      s2, 16(sp)
                ld      s3, 8(sp)
                ld      s4, 0(sp)
                addi    sp, sp, 48

                # return
                ret                         #                 ret
