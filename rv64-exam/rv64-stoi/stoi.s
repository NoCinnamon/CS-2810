                .global stoi
                .text
stoi:
                # your code goes here:


                # string['c', 'c', '-c', 'c'...], each (c) char is 1byte/8bits.
                # dont forget in assembly, 0---> - ; 1----> +
                # '-c' bit== 0, BBBBBBut, if first c is -c, make it 1(+), because there maybe more '-c' down the array.
                # n is number of chars(unkown at begining)
                # *********** compare the '-'; '0'; '9'******************

                # dont do silly things, string can be whatever long as is, but each c is just 8 bits.
                # dont over thinking, this is not souduku board..... just 1 loop.


                # a0: char at string position
                # a2:n
                # a3:index
                # a4: string


                li a2, 0 # output n
                li a3, 0 # index
                li a6, 0 # -sign, remember when apply -sign before ret, change it to 1

                lb     t0, (a0)       # load first value of char to t0, then compare
                li     a5,'-'         # just load '-' to register....
                beq    t0, a5, 3f     # if first c's value == '-' go 3f

1:
                slli   a0, a0, 0    #  shift a0 to left to position, since it is 8bits, shift 0. yea, i dont need it.
                add    t0, a3, a0   # char move to index position
                lb     a4, (t0)     # current value

                li     t0, '0'
                li     t2, '9'
                blt    a4, t0, 2f     # goto 2f check if need to apply -sign before ret
                bgt    a4, t2, 2f

                li      t5, 10
                mul     a2, a2, t5
                li      t0, '0'
                sub     a4, a4, t0
                add     a2, a2, a4

                addi    a3, a3, 1

                j       1b


3:              li      a6, 1         # incase other digit is -.
                addi    a3, a3, 1     # increament index from 0 to 1 now
                j       1b            # go back to loop, start from index = 1

# cry!                  not a2, it is a6......        cry~~~~~~~~~~~~~~~~~~~~
2:              beqz    a6, 4f        # check the sign now, if a6 end up == 0, it is -, go return
                neg     a2, a2        # otherwise, qpply negtive sign before return

4:              mv      a0, a2
                ret
