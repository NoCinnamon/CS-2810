                .global naked_sets, single_pass, gather_set, clear_others
                .text

# gather_set(board, group, key) ->
#   set of pencil marks for cells identified by key
gather_set:
                # a0: board
                # a1: group
                # a2: key
                # a4: set
                # a5: index (0 ~ 8)
                # a6: bit
                # a7: elt

                # t0: 9(temp)
                # t2:board_index/group_index [temp]

                li      a5, -1
                li      a4, 0
                li      t0, 9

3:              addi    a5, a5, 1

1:              bge     a5, t0, 2f

                srl     a3, a2, a5
                andi    a6, a3, 1

                beqz    a6,    3b

                slli    t2, a5, 0 # only shift 1 bit (less tahn 8bits) , moving,0(16^0 = 1);
                add     t2, a1, t2
                lb      t2, (t2)

                slli    t2, t2, 1 # 16^1 = 16, half word
                add     t2, a0, t2 # begining index of group + index tells you how deep goes into the group(row).
                lh      t2, (t2)

                or      a4, a4, t2
                j       3b


2:              mv      a0,     a4
                ret


# clear_others(board, group, key, set) ->
#    0: nothing changed
#    1: something changed
clear_others:


                # clear_others(a0, a1, a2, a3)
                # a0: board
                # a1: group
                # a2: key
                # a3: set
                # a4: changed
                # a5: elt
                # a6: new_elt
                # a7: index


                li  a4, 0
                li  a7, 0
                mv  t0, a3
                not t3, t0  # t3: notset

1:              li      t0,  9
                bge     a7, t0, 2f

                srl     t0, a2, a7   # key>>index, store in t0
                andi    t0, t0, 1    # key>>index = t0 and 1
                bnez    t0,  3f      # if t0 and 1 !== 0, goto 3f to incrment

                slli    t1, a7, 0     # group-a1 at index-a7, shift right 0 bite.
                add     t1, a1, t1
                lb      t1, (t1)      # board_index now = t1

                slli    t1, t1, 1   # board_index shit left 1 bite
                add     t1, a0, t1  # board-a0 + board_inde-t1= elt-t1
                lh      a5, (t1)    # load half(value of board[index]

                and     a6, a5, t3  # new_elt = elt and notset- t3

                beq     a5, a6, 3f
                sh      a6, (t1)    # !!load t1(address of board[index]) to s6, use sh
                li      a4, 1       # changing happend, bit 0 turn to 1

3:              addi    a7,  a7,  1
                j       1b

2:              mv  a0, a4
                ret





# single_pass(board, group) ->
#   0: nothing change
#   1: something changed
single_pass:
                # group = group saved
                # key = 1
                # changed = 0
                # for (key; key < 511; key++) {
                # subset_size = count_bits(key)
                # candidate_set = gather_set(board, group, key)
                # candidate_values_size = count_bits(candidate_set)
                # .if subset_size == candidate_values_size:
                #     temp = clear_others(board,group, key, candidate_set)
                #     changed = changed or temp
                # return changed

                # prelude:

                addi    sp, sp, -64

                sd      ra, 56(sp)
                sd      s6, 48(sp)
                sd      s5, 40(sp)
                sd      s4, 32(sp)
                sd      s3, 24(sp)
                sd      s2, 16(sp)
                sd      s1, 8(sp)
                sd      s0, 0(sp)

                # a0 / s0: board
                # a1 / s1: group
                # s2: changed
                # s3: iter(key)

                mv s0, a0
                mv s1, a1
                li s3, 1
                li s2, 0


1:              li t0, 510 #( 512-2 = 510 )
                bgt s3, t0, 2f

                mv  a0, s3
                call count_bits # subset_size = count_bits(key)
                mv  s4, a0

                mv  a0, s0
                mv  a1, s1
                mv  a2, s3
                call gather_set  # candidate_set = gather_set(board, group, key)
                mv   s5, a0

                mv   a0, s5
                call count_bits #  candidate_values_size = count_bits(candidate_set)
                mv   s6, a0

                bne  s4, s6, 3f # .if subset_size != candidate_values_size, goto 3f

                mv  a0, s0
                mv  a1, s1
                mv  a2, s3
                mv  a3, s5
                call clear_others
                #mv  t0, a0
                or  s2, s2, a0


3:              addi  s3, s3, 1
                j       1b


2:              mv a0, s2

                ld      ra, 56(sp)
                ld      s6, 48(sp)
                ld      s5, 40(sp)
                ld      s4, 32(sp)
                ld      s3, 24(sp)
                ld      s2, 16(sp)
                ld      s1, 8(sp)
                ld      s0, 0(sp)
                addi    sp, sp, 64

                ret


# naked_sets(board, table) ->
#   0: nothing changed
#   1: something changed
naked_sets:

                # prelude:
                addi    sp, sp, -48

                sd      ra, 40(sp) # please remember your $ra(jesus fk crist!!)
                sd      s4, 32(sp)
                sd      s3, 24(sp)
                sd      s2, 16(sp)
                sd      s1, 8(sp)
                sd      s0, 0(sp)


                # a0 / s0: board
                # a1 / s1: table
                # s2: index
                # s3: changed
                # s4: 27*9 (end)


                mv s0, a0
                mv s1, a1
                li s2, 0
                li s3, 0
                li s4, 243

1:              bge  s2, s4, 2f
                add  a1, s2, s1
                mv   a0, s0
                call single_pass

                beqz   a0, 3f
                li     s3, 1

3:              addi s2, s2, 9
                j    1b

2:              mv a0, s3

                # postlude:
                ld      ra, 40(sp)  # check line 195...
                ld      s4, 32(sp)
                ld      s3, 24(sp)
                ld      s2, 16(sp)
                ld      s1, 8(sp)
                ld      s0, 0(sp)
                addi    sp, sp, 48

                ret
