Guess and check
===============

In this final step you will implement a last resort “guess and
check” solver. Implement the function `guess` in the file `guess.s`.

    guess(board, table, position) ->
        0 -> success
        1 -> failure

In the last few steps the solving process has been driven by the
function `solve` defined in `solve.s`. This function is supplied for
you, and it has the following interface:

    solve(board, table) ->
        0: solved successfully
        1: board was unsolvable

`solve` works by calculating naked sets until there are no more
changes, then it checks the status of the board using `check_board`
from the previous step. It returns if the board is either solved or
unsolvable, but calls `guess` otherwise.

`guess` works by trying out every possible solution value for a
single unsolved cell (the one whose index is given by the `position`
parameter), and calling `solve` on the result to see if the guess
leads to a solution.

These two functions are *mutually recursive*, because `solve` calls
`guess`, and `guess` calls `solve`. You do not need to do anything
special to make recursion work, becuase the normal function calling
conventions already make it possible. Each new instance of a
function allocates its own private stack frame, so you will end up
with a stack structured like this:

        | top of stack          |
        +-----------------------+
        | stack frame for solve |
        | ...                   |
        +-----------------------+
        | stack frame for guess |
        | ...                   |
        +-----------------------+
        | stack frame for solve |
        | ...                   |
        +-----------------------+
        | stack frame for guess |
        | ...                   |
    sp->+-----------------------+

`solve` modifies the board as it works, so when a guess proves to be
incorrect, you need a way of restoring the board to its state prior
to the guess. The simplest way is to make a complete backup copy of
the board (on your stack frame) before making the guess, and then if
the guess is incorrect use the backup to restore the board to its
exact state before the guess and then make another guess.

Here are a few details:

Start like a normal non-leaf function with a function prelude that
sets up the stack frame and saves the s-registers you will need to
use.

Then, grab another chunk of stack space, this time big enough to
hold a complete copy of the board. The board is 81×2 = 162 bytes in
size, but the stack size must always be a multiple of 16 so round it
up to 176 bytes. The stack frame now has this structure:

        | caller's stack frame  |
        +-----------------------+
        | saved ra register     |
        +-----------------------+
        | saved sn register     |
        +-----------------------+
        | ...                   |
        +-----------------------+
        | saved s1 register     |
        +-----------------------+
        | saved s0 register     |
        +-----------------------+
        | 176 bytes for board   |
    sp->+-----------------------+

At the end of the function, you should add 176 to the stack pointer
to free up the board space, then do a normal function prelude where
you restore saved registers, move the stack pointer back to its
starting position, and then return.

Within the function, the sp register points to the backup board
location, and you can just use sp directly (no need to copy it to a
different register).

Overall, the structure of this function should look like:

*   Copy all 81 elements of the board to the backup board

        for i = 0; i < 81; i++
            temp = board[i]
            backup[i] = temp

*   Load the element from the board at `position`

        elt = board[position]

*   for guess in range [1, 9]:

    *   Check if the guess is viable (if the corresponding bit is
        set in the element)

            shifted = elt >> guess
            bit = shifted & 1
            if bit != 0

    *   If so, print a message (see below), store that as a solved
        value to `position` on the original board (not the backup)
        and call `solve`

            puts(msg_guess_1)
            print_n(guess)
            puts(msg_guess_2)
            col = position % 9
            print_n(col)
            puts(msg_guess_3)
            row = position / 9
            print_n(row)
            puts(msg_guess_4)

            board[position] = 1 << guess
            result = solve(board, table)

    *   If `solve` reports the board as solved, return 0

            if result == 0:
                return 0

    *   Otherwise, copy all 81 elements from the backup to the
        original board to restore it to the pre-guess state

            for i = 0; i < 81; i++
                temp = backup[i]
                board[i] = temp

*   No solution was found after trying all possible guesses, so
    return 1

        return 1

Make sure that all return paths clean up the stack properly (adding
176 to sp first to free up the backup board space, then proceeding
with a normal funciton postlude).

`_start`, `read_board`, and `solve` all print messages to the screen
as the solving process progresses. In this step you will also print
a message each time you make a guess. The message should be of the
form:

    Guessing 3 at position (5, 6)

The text parts of the message are at the top of `guess.s`:

```
                .data
msg_guess_1:    .asciz  "\nGuessing "
msg_guess_2:    .asciz  " at position ("
msg_guess_3:    .asciz  ", "
msg_guess_4:    .asciz  ")\n"
```

You can also use the following helper functions to print:

*   `puts(string)`: given the address of a null-terminated string in
    memory, print it to the screen (this is defined in
    `lib/print.s`).
*   `print_n(n)`: given a number, convert it to a string and print
    it to the screen (also defined in `lib/print.s`).

When you are about to make a guess, print the `msg_guess_1` string
by loading its address into `a0` and then calling `puts`:

    la      a0, msg_guess_1
    call    puts

Then call `print_n` with the guess value itself, then use `puts` to
print `msg_guess_2`. To print an integer, put it in `a0` and call
`print_n`, e.g.:

    li      a0, 12345
    call    print_n

At this point you need to convert a board index value, a value in
the range [0,81), into X and Y coordinates:

*   Take the remainder from dividing index by 9 and print it using
    `print_n`
*   Use `puts` to print `msg_guess_3`
*   Divide index by 9 (which will discard the remainder) and print
    the result using `print_n`.
*   Print the final `msg_guess_4` string using `puts`.

The instructions `div` and `rem` compute the integer quotient and
remainder, respectively.


Additional tests
----------------

This step adds 10 new test boards. These were drawn from this list
of 20 known hard-to-solve boards:

* https://github.com/attractivechaos/plb/blob/master/sudoku/sudoku.txt

The tests include the 10 on this list with the shortest output (when
tested on our solver) to keep the problem size down in CodeGrinder.

The solver successfully solves all 20 of them with the following
times on my desktop machine:

1.  0.037s
2.  0.259s
3.  2.491s
4.  7.300s
5.  0.876s
6.  1.420s
7.  2.986s
8.  2.082s
9.  1.166s
10. 0.235s
11. 4.508s
12. 6.023s
13. 0.073s
14. 0.085s
15. 0.027s
16. 4.938s
17. 0.027s
18. 0.037s
19. 1.945s
20. 1.536s
