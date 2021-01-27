

10 constant temperature { Define the temperature of system }
variable count_alive 
row_small col_small * constant size 
variable count_success 
variable conway-file-id-3
100000 constant iterations_prob
10 constant N


: make-binomial-file
    s" C:\Users\Joe\Documents\Binomial.txt " r/w create-file drop
    conway-file-id-3 !
    ;

: close-file-binomial
    conway-file-id-3 @ close-file drop ;



: calculate_prob ( p0 --> )
    size * count_alive @ temperature * + 
    1 temperature + 
    size * rnd 
    > if
        1
    else
        0
    then ;

: check_prob 
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

                    

    
: scan_array_with_temperature ( output addr input add --> )
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

: check_prob_array
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

: go_with_temperature
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
        cr ." Iteration " I . ." Running " cr
        matrix remove_BC
        life_board write-matrix
        write-blank
        matrix count_statistics
        . ." Number of dead cells " cr
        dup . ." Number of live cells " cr
        count_alive !
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
        . ." Change in live cells " cr
        . ." Change in dead cells " cr
        boundary_checking 1 = if
            check_edges_alive
            true = if
                ." Cell alive at edges "
            then
        then
        matrix new_matrix set_matrix_equal
        cr cr
    loop
    close-file
    bmp-window-handle @ DestroyWindow drop
    ;

