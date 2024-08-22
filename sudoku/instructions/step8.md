Naked sets
----------

In this step you will calculate naked sets for the entire board:

    naked_sets(board, table) ->
        0: nothing changed
        1: something changed

Iterate over the 27 groups of the board (similar to previous steps)
and call `single_pass` on each one.

You should return 1 if any changes were made (as reported by the
calls to `single_pass`) and 0 otherwise.

Note that calculating naked sets may reveal additional naked sets,
so the code that calls it (in `solve.s`) will call it repeatedly
until no more changes are reported.
