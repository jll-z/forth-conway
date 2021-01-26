

{ ----------- Insert variables here -------- }

26 constant row
26 constant col
col 2 - constant col_small
row 2 - constant row_small

variable conway-file-id
variable conway-file-id-2
variable sum
variable count_alive
variable count_dead
variable edges 
0 constant corner



CREATE SEED  123475689 ,

: Rnd ( n -- rnd )   { Returns single random number less than n }
   SEED              { Minimal version of SwiftForth Rnd.f      }
   DUP >R            { Algorithm Rick VanNorman  rvn@forth.com  }
   @ 127773 /MOD 
   2836 * SWAP 16807 * 
   2DUP > IF - 
   ELSE - 2147483647 +  
   THEN  DUP R> !
   SWAP MOD ;

: make_array * allocate drop ; ( row col --> )        { Create a new array }

row_small col_small make_array constant life_board
row_small col_small make_array constant life_board_inverted


: array_! ( addr n i j --> )                          { Add element n to position i, j }
  swap col * ( addr n i j --> addr n j i*col )
  + ( addr n j i*col --> addr n j+i*col )
  rot + ( addr n j+i*col --> n addr + j+i*col )   
  c! ;

: array_@ ( addr i j --> )                      { Get element i j }
  swap col * ( addr i j --> addr j i * col )
  + + ( addr j i * col --> addr+j+i*col )
  c@  ;

: array_@_small ( addr i j --> )
    swap col_small * ( addr i j --> addr j i * col )
    + + ( addr j i * col --> addr+j+i*col )
    c@  ;

: array_!_small ( addr n i j --> )                          { Add element n to position i, j }
  swap col_small * ( addr n i j --> addr n j i*col )
  + ( addr n j i*col --> addr n j+i*col )
  rot + ( addr n j+i*col --> n addr + j+i*col )   
  c! ;


: show_array ( addr col row --> )
  row 0 do cr           { break line after every row }
  col 0 do dup ( addr --> addr addr )
  J I  array_@ .          { Read from array_@ word to obtain numbers }
  loop loop 
  drop ;                { Drop the address output }

: show_small_array ( addr --> )  { show array without BC }
    row_small 0 do cr
        col_small 0 do dup
            J row_small * ( --> addr addr j*row_small ) I + +
            c@ .
        loop
    loop drop ;


: fill_rnd ( addr--> )        { Fill array with random numbers }
  row 0 do
  col 0 do ( addr --> addr )
  dup 2 rnd J I ( addr --> addr addr rnd8 J I )
  array_! loop loop
  drop ; 

: fill_0 ( addr --> )          { Fill an array with zeros }
    row 0 do
        col 0 do
            dup 0 J I array_!
        loop
    loop drop ;



: life_rules ( n--> )     { Life rules based on number of neigbouring cells output true or false}
  dup ( n --> n n )
  case
    0 of drop false endof
    1 of drop true endof
    2 of drop true endof
    3 of drop true endof
    4 of drop false endof
    5 of drop false endof
    6 of drop false endof
    7 of drop false endof
    8 of drop false endof
  endcase ; ( --> true/false )

: create_row ( addr i j --> )
  swap col * ( addr i j --> addr j i*col )
  + + ( --> addr+j+i*col) 1 swap ( --> 1 addr+j+i*col )
  >R 
  R@ 1 + c!
  R@ 1 - c!
  R@ col - c!
  R@ col + c!
  R@ col - 1 + c!
  R@ col + 1 + c!
  R@ col + 1 - c!
  R@ col - 1 - c!
  R> drop ;



: count_neighbours ( addr i j --> )
    swap col * ( addr i j --> addr j i*col )
    + + ( --> addr + j + i*col ) 
    >R 
    R@ 1 + c@ sum c+!
    R@ 1 - c@ sum c+!
    R@ col - c@ sum c+!
    R@ col + c@ sum c+!
    R@ col - 1 + c@ sum c+!
    R@ col + 1 + c@ sum c+!
    R@ col + 1 - c@ sum c+!
    R@ col - 1 - c@ sum c+!
    R> drop 
    sum c@ 0 sum c! ;  { replace sum with 0 for next iteration }

: life_rules_alive ( n--> )     { Life rules based on number of neigbouring cells output true or false}
  dup ( n --> n n )
  case
    0 of drop 0 endof
    1 of drop 0 endof
    2 of drop 1 endof
    3 of drop 1 endof
    4 of drop 0 endof
    5 of drop 0 endof
    6 of drop 0 endof
    7 of drop 0 endof
    8 of drop 0 endof
  endcase ; ( --> 1/0 )

: life_rules_dead ( n--> ) 
    3 = if
        1
    else 
        0
    then ;

: life_rules ( n dead/alive --> )
    true = if ( n dead/alive --> n)
        life_rules_alive ( n --> alive/dead)
    else    
        life_rules_dead ( n --> alive/dead)
    then ;

: check_alive ( n --> )
    1 = if
        true
    else
        false
    then ;

: scan_array ( output_addr input_addr --> )               { Scan the input array }
    row 1 - 1 do
        col 1 - 1 do
            2dup dup 
            J I count_neighbours 
            swap J I array_@ 
            check_alive
            life_rules 
            J I array_! 
        loop
    loop drop drop ;

: fill_row_0 ( addr i --> )
    col 0 do 
        2dup 
        0 swap I array_! 
    loop drop drop ;

: fill_edge_0 ( addr i --> )
    2dup ( --> addr i addr i )
    0 swap ( --> addr i addr 0 i ) 0 array_!
    0 swap ( --> addr i addr 0 i ) col 1 - array_!
    ;

: no_wrap ( addr --> )
    row 0 do dup  ( --> addr addr )
        I dup ( --> addr addr I I )
        case
            0 of ( --> addr addr I ) fill_row_0 endof ( --> addr )
            row 1 - of fill_row_0 endof
        drop fill_edge_0 dup 
        endcase
    loop drop ;

: fill_row_wrap  ( addr i --> )
    col 1 - 1 do 
        2dup 2dup ( --> addr i addr i addr i )
        row 2 - swap - abs ( --> addr i addr i addr row-2-i )
        I array_@ ( --> addr i addr i dead/alive )
        swap ( --> addr i addr dead/alive i )
        I array_! ( --> addr i )
    loop 
    2dup 2dup 2dup ( --> addr i addr i addr i )
    row 2 - ( --> addr i addr i addr i row -2 ) - ( i - row + 2) abs 
    col 2 - ( --> addr i addr i addr i +2 - row col-2 ) array_@ swap 0 array_! 
    ( --> addr i addr i ) 
    row 2 - - ( --> addr i addr i+2-row ) abs 1 array_@ 
    ( --> addr i cell_val )
    swap ( --> addr cell_val i ) col 1 - array_!
    ;

: fill_edge_wrap ( addr i --> )
    2dup 2dup 
    col 2 - array_@ swap
    0 array_! 2dup
    1 array_@ swap 
    col 1 - array_!
    ;

: wrapping ( addr --> )
    row 0 do dup  ( --> addr addr )
        I dup ( --> addr addr I I )
        case
            0 of ( --> addr addr I ) fill_row_wrap endof ( --> addr )
            row 1 - of fill_row_wrap endof
        drop fill_edge_wrap dup 
        endcase
    loop drop ;

: set_matrix_equal ( addr 1 addr 2 --> )
    row 0 do
        col 0 do 
            2dup J I array_@ 
            J I array_!
        loop
    loop drop drop ;

: remove_BC ( addr --> )
    row 1 - 1 do
        col 1 - 1 do
            dup ( --> addr addr )
            J I array_@ ( --> addr n )
            I 1 - ( --> addr n i-1)
            J 1 - ( --> addr n i-1 j-1)
            col_small * + ( --> addr n j' + i'*col-2 )
            life_board + c!
        loop
    loop drop ;

: check_edges_alive   { Check to see if the edges are alive }
    col_small 0 do  
        life_board 0 I array_@_small edges +!
        life_board col_small 1 - I array_@_small edges +!
    loop
    row_small 1 - 1 do
        life_board I 0 array_@_small edges +!
        life_board I col_small 1 - array_@_small edges +!
    loop
    edges @ 0 = if
        false
    else
        true
    then ;

: fill_50    { Fill with 50-50 random }
    Begin 
        matrix fill_rnd
        matrix count_statistics
        =
     until ;

        
{ ------------------------------------------- Writing data to files -------------------------------------------------- }



: make-file
    s" C:\Users\Joe\Documents\Conway_Files.txt " r/w create-file drop
    conway-file-id !
    ;

: make-activity-file
    s" C:\Users\Joe\Documents\Conway_Files_Activity.txt " r/w create-file drop
    conway-file-id-2 !
    ;


: write-matrix    ( addr --> )
    row_small 0 do 
        col_small 0 do   
            dup ( --> addr addr )
            J I array_@_small (.) conway-file-id @ write-file drop
            s"  " conway-file-id @ write-file drop
        loop 
    loop drop ;

: write-blank                                        { Write an empty line to the file       }
  s"  " conway-file-id @ write-line drop
;


: close-file                                 { Close the file pointed to by the file  }
  conway-file-id @                                  { handle.                                }
  close-file drop
  conway-file-id-2 @
  close-file drop
; 


{ --------------------------------------- Creating GIO ------------------ }

INCLUDING-OPTION C:\Users\Joe\Documents\Forth\Forth_Project` bmp-display-2.f 

: rearrange_board
    row_small 0 do
        col_small 0 do
            life_board J I array_@_small 
            life_board_inverted swap row_small 1 - J - I array_!_small
        loop
    loop ;

: go_visual
  rearrange_board
  bmp-address @ write_bmp
  bmp-address @ bmp-to-screen-stretch
  100 ms
  ;






{ ----------------------------------- Calculate Statistics --------------------------------- }

: count_statistics ( addr --> )
    0 count_alive !
    0 count_dead !
    row 1 - 1 do
        col 1 - 1 do
            dup 
            J I array_@ ( --> addr 1/0 ) dup 
            case
                1 of 1 count_alive +! drop endof
                0 of 1 count_dead +! drop endof
            endcase 
        loop
    loop drop
    count_alive @ count_dead @
    ;

: change_statistics ( addr1 addr 2 --> )
    count_statistics ( --> addr1 count_alive count_dead )
    rot count_statistics ( --> count_alive_1 count_dead_1 cout_alive_2 count_dead_2 )
    rot ( --> count_alive_1 count_alive_2 count_dead_2 count_dead_1 )
    swap - ( --> count_alive_1 count_alive_2 count_dead_1 - count_dead_2 )
    -rot - ( --> change_dead change_alive )
;





{ --------------------------- Running Conway ---------------------------- }

200 constant iterations   { Number of iterations }
0 constant wrap { 0 for non wrapping and 1 for wrapping boundaries }
1 constant boundary_checking { 1 to check is cells are alive in boundaries }
0 constant visualisation
row col make_array constant matrix
row col make_array constant new_matrix

matrix fill_0
new_matrix fill_0




{ -------------------------- Initialise matrix with seed --------------------- }

: horizontal_row ( n--> )    { Input a horizontal row at the center of the board }
    dup 2 / col 2 / ( --> n/2 col/2 )
    swap 2dup - ( --> col/2 n/2 col/2-n/2)
    -rot + rot
    2 mod 0= if
    else
        1 +
    then 
    swap ( --> col/2-n/2 col/2+n/2) 
    do
        1 row 2 / ( --> 1 row/2 ) 
        matrix -rot I array_!
    loop ;

matrix fill_rnd



{ -------------------------- Run word ------------------------------- }

: run_conway
    time&date drop drop drop drop { Assuming only s and min }
    60 * + >r
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
        New-bmp-Window-stretch              { Create new "stretch" window                     }
        bmp-window-handle !
    then
    iterations 0 do 
        cr ." Iteration " I . ." Running " cr
        matrix remove_BC 
        life_board write-matrix 
        write-blank
        matrix count_statistics
        . ." Number of dead cells " cr 
        . ." Number of live cells " cr 
        visualisation 1 = if    
            go_visual
        then
        new_matrix matrix scan_array
        wrap 0= if 
            new_matrix wrapping 
        else
            matrix no_wrap
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
    time&date drop drop drop drop
    60 * + r> -
    ." Time taken " . ." s "
    close-file
    bmp-window-handle @ DestroyWindow  drop
    ;

: reset    { Reset the matrices to start a new simulation }
    matrix fill_0
    new_matrix fill_0
;












