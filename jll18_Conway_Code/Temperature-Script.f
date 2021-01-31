
0 constant temperature                                          { Define the temperature of system }
1 constant scale                                               { This converts floating point temp into integer for forth}
                                                                { for example temp 0.5 would input 5 into temperature}
                                                                { and 10 into the scale }
variable count_alive                                            { Number of Live Cells defined at beginning of run }
row_small col_small * constant size                             { Size of the array }
variable count_success                                          { Variable used to store data for test }
variable conway-file-id-3
100000 constant iterations_prob                                 { Iterations for binomial test }
10 constant N                                                   { Number of samples for binomial test }



: calculate_prob ( p0 --> )                                     { Rejection method algorithm based on initial life rules }
    size * scale * count_alive @ temperature * + 
    1 scale * temperature + 
    size * rnd 
    > if
        1
    else
        0
    then ;

                   
: scan_array_with_temperature ( output addr input add --> )     { Update the life board using the rejection algorithm }
    row 1 - 1 do
        col 1 - 1 do   
            2dup dup 
            J I count_neighbours
            swap J I array_@ 
            check_alive
            life_rules
            calculate_prob 
            J I array_!
        loop
    loop drop drop ;


: run_conway_with_temperature                                    { Run Game of Life with a Temperature Parameter }
    wrap 0= if
        matrix wrapping
        ." Running with Wrapping "
    else
        matrix no_wrap
        ." Running with no wrapping "
    then
    make-file
    make-activity-file
    visualisation 1 = if
        new-bmp-window-stretch
        bmp-window-handle !
    then
    iterations 0 do
        verbose 1 = if
            cr ." Iteration " I . ." Running " cr
        then
        matrix remove_BC
        life_board write-matrix
        write-blank
        matrix count_statistics swap dup
        count_alive !
        verbose 1 = if
            . ." Number of Live Cells " cr
            . ." Number of Dead Cells " cr
        else
            drop drop
        then 
        visualisation 1 = if
            go_visual
        then
        new_matrix matrix scan_array_with_temperature
        wrap 0= if
            new_matrix wrapping
        else
            new_matrix no_wrap
        then
        new_matrix matrix change_statistics dup 
        (.) conway-file-id-2 @ write-line drop 
        1 verbose = if
            . ." Change in dead cells " cr
            . ." Change in live cells " cr
        else
            drop drop
        then 
        boundary_checking 1 = if
            check_edges_alive
            true = if
                ." Cell alive at edges " cr
            then
        then
        matrix new_matrix set_matrix_equal
    loop
    close-file
    bmp-window-handle @ DestroyWindow drop
    ;

{ ---------------------------- Validations of the temperature methods -------------------}

: make-binomial-file
    s" C:\Users\Joe\Binomial.txt " r/w create-file drop
    conway-file-id-3 !
    ;

: close-file-binomial
    conway-file-id-3 @ close-file drop ;

: check_prob                                                        { Check the rnd generator by measuring 0s and 1s }
    make-binomial-file
    iterations_prob 0 do
        N 0 do
        1 calculate_prob 
        1 = if
            1 count_success +!
        then
        loop
        count_success @ (.) 
        conway-file-id-3 @ write-line drop
        0 count_success ! loop 
    close-file-binomial ;


: check_prob_array                                                  { Check the temperature function and rnd when incorporated into the life board }
    make-binomial-file
    iterations_prob 0 do
        N 0 do
        new_matrix matrix scan_array_with_temperature
        new_matrix 1 1 array_@
        1 = if
            1 count_success +!
        then
        loop
        count_success @ (.)
        conway-file-id-3 @ write-line drop
        0 count_success ! loop
        close-file-binomial ;


        



