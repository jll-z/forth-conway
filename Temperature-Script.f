
1 constant temperature { Define the temperature of system }
variable count_alive 
4 count_alive !
row_small col_small * constant size 
variable count_success 
variable conway-file-id-3
10000 constant iterations_prob
10 constant N


: make-binomial-file
    s" C:\Users\Joe\Documents\Binomial.txt " r/w create-file drop
    conway-file-id-3 !
    ;

: close-file-binomial
    conway-file-id-3 @ close-file drop ;



: calculate_prob ( p0 --> )
    size * count_alive @ temperature * + .s
    1 temperature + .s
    size * rnd .s
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


        

