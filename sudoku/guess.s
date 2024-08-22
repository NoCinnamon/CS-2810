                .global guess

                .data
msg_guess_1:    .asciz  "\nGuessing "
msg_guess_2:    .asciz  " at position ("
msg_guess_3:    .asciz  ", "
msg_guess_4:    .asciz  ")\n"
                .text

# guess(board, table, position) ->
#     0 -> success
#     1 -> failure

guess:

    addi    sp,sp,-64
    sd      ra, 56(sp)
    sd      s6, 48(sp)
    sd      s5, 40(sp)
    sd      s4, 32(sp)
    sd      s3, 24(sp)
    sd      s2, 16(sp)
    sd      s1, 8(sp)
    sd      s0, 0(sp)

    addi    sp,sp,-176      # board save on stack 2 x 81= 162
                            # 要是16的倍数，162/16 = 10.125 ～ 11 sp moves 16bites each time for RV64
                            # 11 * 16 = 176
    mv      s0,a0           # board address
    mv      s1,a1           # table
    mv      s2,a2           # position

    li      t0, 0 # index

1:  # save the board

    # load board from position
    slli    t1,t0,1
    add     t1,s0,t1
    lh      t2,(t1)

    # store it on the stack
    slli    t1,t0,1
    add     t1,sp,t1
    sh      t2,(t1)

    addi    t0,t0,1   # index++
    li      t1,81     # for i < 81 go through the board positions
    blt     t0,t1,1b  # end of save board



# main function here:
    # s5: guess (index)
    # s4: musk
    # s3: elt
    # s6: result


            li  s5, 0
4:          addi s5, s5, 1
            li  t1, 9         # for guess in range [1, 9]
            bgt s5, t1, 10f    # branch if guess > 9, goto 10f, return

            slli t0, s2, 1      # shift guess(index) to s2()
            add t0, t0, s0      # board + s2
            lh  s3, (t0)        # elt = board[position]

            li   t4, 1
            sll  s4, t4, s5     # mask = 1 << guess, shit 1 to left guess(index) number of times
            and  t2, s3, s4     # elt & mask save in t2
            beqz t2, 4b         # elt & mask == 0, goto 4b


            #. if elt & mask != 0:

            la    a0, msg_guess_1  # load address of message1 to a0.
            call  puts             # call funtion puts

            mv    a0, s5           # move position to a0,
            call  print_n          # call funtion print_n

            la    a0, msg_guess_2  # load address of message2 to a0.
            call  puts

            li    t0, 9            # col = guess(index) % 9
            rem   t1, s2, t0       # remainder stored in t1(col)

            mv    a0, t1           # mv rem to a0
            call  print_n          # call print_n

            la    a0, msg_guess_3
            call  puts

            li    t0, 9
            div   t1, s2, t0      # row = guess / 9, store in t1(row)

            mv    a0, t1           # print_n(row)
            call  print_n

            la    a0, msg_guess_4  # puts(msg_guess_4)
            call  puts


            slli t0, s2, 1
            add t0, t0, s0      # board + s2
            sh  s4, (t0)        # mask = board[position]

            mv a0, s0           # solve(board, table)
            mv a1, s1           # solve(a0, a1)
            call solve
            mv s6, a0           # store result of function solve in s6.

            bnez s6, 2f         #.if result == 0:
            li a0, 0            # return 0
            j 3f

    # restore the board
    # load from the stack
2:  li      t0, 0
5:  slli    t1, t0, 1
    add     t1, sp, t1
    lh      t2, (t1)

    # # store it on the board
    slli    t1, t0, 1
    add     t1, s0, t1
    sh      t2, (t1)

    addi    t0, t0, 1     # index++
    li      t1, 81       # for i < 81 go through the board positions
    blt     t0, t1, 5b    # end restore board
    j       4b

10:  li a0, 1
3:  addi    sp,sp,176
    ld      ra,56(sp)
    ld      s6,48(sp)
    ld      s5,40(sp)
    ld      s4,32(sp)
    ld      s3,24(sp)
    ld      s2,16(sp)
    ld      s1,8(sp)
    ld      s0,0(sp)
    addi    sp,sp, 64
    ret
