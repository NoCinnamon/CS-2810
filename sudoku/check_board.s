                .global check_board
                .text

# check_board(board) ->
#     -1: board is unsolvable
#     0-80: position of most-constrained cell
#     81: board is solved
check_board:
            # a0/s0: board
            # most_constrained_index: s1 (81)
            # most_constrained_coun: s2  (10)
            # index: s3
            # count_bit taking a0 --> board[index], return number of marks in the cell.

            addi    sp, sp, -56
            sd      ra, 48(sp)
            sd      s5, 40(sp)
            sd      s4, 32(sp)
            sd      s3, 24(sp)
            sd      s2, 16(sp)
            sd      s1, 8(sp)
            sd      s0, 0(sp)

            mv    s0, a0

            li    s1, 81
            li    s2, 10
            li    s3, 0


1:          li    t0, 81
            bge   s3, t0, 2f

            slli  t0, s3, 1
            add   t0, s0, t0    # board at index: board[i]
            lh    a0, (t0)      # load it to a0
            call  count_bits    # call count_bits, puting a0 in.
            mv    s5, a0        # move result of count_bits a0 to s5
            beqz  s5, 3f        # if s5 == 0, go 3f

            li    t0, 1
            beq   s5, t0, 4f    # if s5 ==1, then do nothing go 4f

            bge   s5, s2, 4f    # if s5 >= s2(10), which is not.
            mv    s2, s5        # s5 < s2: then s5 become s2(most_constained_count)
            mv    s1, s3        # s3 become s1 most_constrained_index


4:          addi  s3, s3, 1     # increment index, go back to loop
            j     1b

3:          li    s1, -1        # list -1 to s1
2:          mv    a0, s1        # move s1 to a0, then postlod then ret

            ld      ra, 48(sp)
            ld      s5, 40(sp)
            ld      s4, 32(sp)
            ld      s3, 24(sp)
            ld      s2, 16(sp)
            ld      s1, 8(sp)
            ld      s0, 0(sp)
            addi    sp, sp, 56

            ret
