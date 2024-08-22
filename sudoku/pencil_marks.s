                .global pencil_marks, get_used, clear_used, count_bits
                .text

# count_bits(n) -> # of bits set in n (only counting bits 0-9 inclusive)
count_bits:
                # a0: "n", the number to check
                # t0: count(move it back to a0 before ret)
                # t1: index
                # t3: bit
                # t2: temp
                # t4: 9

                li  t0, 0
                li  t1, 0


1:              srl     t2, a0, t1          # shit a0 right index, store in t2
                andi    t3, t2, 1           # andi bit,temp,1
                beqz    t3, 2f              # .if bit == 0 jump to 2f

                addi    t0, t0, 1           # addi count +=1

2:              addi    t1, t1, 1           # addi index +=1
                li      t4, 9
                ble     t1, t4, 1b          # going back to while loop

                mv      a0, t0
                ret


# get_used(board, group) -> used
get_used:

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

                # s2: used. =0
                # s0: board
                # s1: group
                # s3: element
                # s4: group_index
                # s5: board_index
                # s6: count

                mv s0, a0
                mv s1, a1
                li s2, 0
                li s4, 0


1:              slli    t0, s4, 0
                add     t0, s1, s4     #  group_element_address = group + group_index
                lb      s5, (t0)       # board_index = lb (group_element_address)
                slli    t0, s5, 1      # scaled_board_index = board_index << 1
                add     t0, s0, t0     # board_element_address = board + scaled_board_index
                lh      s3, (t0)       # element = lh (board_element_address).loaed half word ,store in s3


                mv      a0, s3       # move t0 to a0 before put it to function
                call    count_bits   # function only takes a0.
                mv      s6, a0       # count = count_bits(element)

                li      t0, 1
                li      t1, 9        # tep t1 = 9
                bne     s6, t0, 2f   # if != 1, go 2f += 1
                or      s2, s2, s3   # used or element

2:              addi    s4, s4, 1      # group_index++
                blt     s4, t1, 1b     # go back to loop if group index < 9

                mv      a0, s2         # move s2 back to a0 before ret

# postlude
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


# clear_used(board, group, used)
clear_used:
               # prelude:
                addi    sp, sp, -80
                sd      ra, 72(sp)
                sd      s8, 64(sp)
                sd      s7, 56(sp)
                sd      s6, 48(sp)
                sd      s5, 40(sp)
                sd      s4, 32(sp)
                sd      s3, 24(sp)
                sd      s2, 16(sp)
                sd      s1, 8(sp)
                sd      s0, 0(sp)

                # board: a0;    a1: group;    a2: used
                # s0: board
                # s1: group
                # s3: element
                # s4: group_index
                # s5: not_used
                # s6: board_element_address
                # s7: change_made
                # s8: new_elt


                # part of the problem is remember $a and $t will be gone after function call
                # and get your loopping step right, Jesus


                mv s0, a0
                mv s1, a1
                not s5, a2      # notused = flip bits in a2(1->0; 0->1), store it into s5
                                # by the way, dont need save used.

                li s4, 0        # group_index, starting at 0
                li s7, 0        # change_made = 0


1:              slli    t0, s4, 0
                add     t0, s1, s4     #  group_element_address = group + group_index
                lb      t1, (t0)       # board_index = lb (group_element_address)
                slli    t0, t1, 1      # scaled_board_index = board_index << 1
                add     s6, s0, t0     # board_element_address = board + scaled_board_index
                lh      s3, (s6)       # element = lh (board_element_address).loaed half word ,store in s3
                                       # s3 now is VALUE of board which is baord[index]


                mv      a0, s3       # move s3 to a0 before put it to function
                call    count_bits   # function only takes a0.
                mv      t0, a0       # count = count_bits(element) no need to save count


                li      t1, 1
                beq     t0, t1, 3f    # if count = 1, go 3f, increament 1, if havent finished loop go back to 1b
                and     s8, s3, s5

                beq     s8, s3, 3f
                sh      s8, (s6)
                li      s7, 1



3:              addi    s4, s4, 1
                li      t0, 9
                bge     s4, t0, 2f
                j 1b

2:               mv      a0, s7


                # postlude:

                ld      ra, 72(sp)
                ld      s8, 64(sp)
                ld      s7, 56(sp)
                ld      s6, 48(sp)
                ld      s5, 40(sp)
                ld      s4, 32(sp)
                ld      s3, 24(sp)
                ld      s2, 16(sp)
                ld      s1, 8(sp)
                ld      s0, 0(sp)
                addi    sp, sp, 80

                ret



# pencil_marks(board, table)
pencil_marks:
                addi    sp, sp, -56
                sd      ra, 48(sp)
                sd      s5, 40(sp)
                sd      s4, 32(sp)
                sd      s3, 24(sp)
                sd      s2, 16(sp)
                sd      s1, 8(sp)
                sd      s0, 0(sp)

                # board: a0/s0
                # table: a1/s1
                # changed: s2 (sarting at 0)
                # group_start: s3  (0<= s1 <27*9)
                # s4: 27*9
                # used: a2
                # delta: t1

                mv      s0,     a0
                mv      s1,     a1

                li      s2,     0       # load 0 to changed
                li      s3,     0       # load 0 to group_start

1:              #li      t0,     243     # all groups of whole board
                #bgt     s3,     t0,     2f   # if group_start >= s4, goto 2f
                add     a1,     s3,     s1

                mv      a0,     s0
                call    get_used
                mv      s4,     a0
                mv      a0,     s0
                add     s5,     s1,     s3
                mv      a1,     s5
                mv      a2,     s4
                call    clear_used

                beqz    a0,     2f
                li      s2,     1

                #addi    s3,     s3, 9
                #j       1b



2:              li      t0,     243
                addi    s3,     s3, 9
                blt     s3,     t0, 1b
                mv      a0,     s2


                ld      ra, 48(sp)
                ld      s5, 40(sp)
                ld      s4, 32(sp)
                ld      s3, 24(sp)
                ld      s2, 16(sp)
                ld      s1, 8(sp)
                ld      s0, 0(sp)
                addi    sp, sp, 56

                ret
