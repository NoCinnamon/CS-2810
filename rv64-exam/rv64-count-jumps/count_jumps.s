                .global count_jumps
                .text

count_jumps:
            # a0:  array
            # a1: size
            # a2: index(move it to position) add.. load
            # a3: array[index]
            # a6: count



                li      a6, 0           # count

                li      t0, 1                            
                sub     t1, a1, t0      # t1 = size - 1

                mv      a2, t1          

1:              slli    t0, a2, 3
                add     t1, a0, t0      # find address
                ld      a3, (t1)        # a3 = load array[i] 
                add     a2, a2, a3      # index = index + array[i]
                addi    a6, a6, 1       # increment count

                bge     a2, a1, 3f      # if index >= size: goto 3f
                bltz    a2, 3f          # if index < 0: goto 3f
                j       1b              

3:              mv      a0, a6          # move count into a0
                ret                     # return count






