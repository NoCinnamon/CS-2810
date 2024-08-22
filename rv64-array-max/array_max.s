                .global array_max
                .text

# int array_max(int *array, int count)
array_max:
# a1: count
# a2: i
# a3: max so far
# a4: elt (element)
# t0: current

                li a2, 1
                ld a3, 0(a0)

1:              bge a2, a1, 3f
                slli t0, a2, 3
                add t0, a0, t0
                ld a4, (t0)
                ble a4, a3, 2f
                mv a3, a4
2:              addi a2, a2, 1
                j 1b

3:              mv a0, a3
                ret
