{ ----------- Insert variables here -------- }

7 constant row
7 constant col

variable conway-file-id
variable sum
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


: array_! ( addr n i j --> )                          { Add element n to position i, j }
  swap col * ( addr n i j --> addr n j i*col )
  + ( addr n j i*col --> addr n j+i*col )
  rot + ( addr n j+i*col --> n addr + j+i*col )   
  c! ;

: array_@ ( addr i j --> )                      { Get element i j }
  swap col * ( addr i j --> addr j i * col )
  + + ( addr j i * col --> addr+j+i*col )
  c@  ;


: show_array ( addr --> )
  row 0 do cr           { break line after every row }
  col 0 do dup ( addr --> addr addr )
  J I  array_@ .          { Read from array_@ word to obtain numbers }
  loop loop 
  drop ;                { Drop the address output }


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



: mat_mul ( vector_addr, M_addr--> )                                        
  row 0 do 
    col 0 do 
    2dup 
    J I array_@ ( vector_addr, M_addr, vector_add, Mij )
    swap I + c@ ( --> vec, M, Mij, vecj)
    * ( --> vec, M, Mij * vecj )
    output_vector J + c+!
    loop 
  loop ;

: show_vector ( addr --> )                          { Show a 1d vector array }
  row 0 do
   dup 
   I + c@ .
  loop ;



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
    1 of drop 1 endof
    2 of drop 1 endof
    3 of drop 1 endof
    4 of drop 0 endof
    5 of drop 0 endof
    6 of drop 0 endof
    7 of drop 0 endof
    8 of drop 0 endof
  endcase ; ( --> true/false )

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
    loop drop ;

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
    2dup
    corner swap 0 array_!
    corner swap col 1 - array_!
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
    loop drop ;
        
{ ------------------------------------------- Writing data to files -------------------------------------------------- }



: make-file
    s" C:\Users\Joe\Documents\Conway_Files.txt " r/w create-file drop
    conway-file-id !
    ;

: write-matrix    ( addr --> )
    row 0 do 
        col 0 do   
            dup ( --> addr addr )
            J I array_@ (.) conway-file-id @ write-file drop
            s"  " conway-file-id @ write-file drop
        loop 
    loop drop ;

: write-blank                                        { Write an empty line to the file       }
  s"  " conway-file-id @ write-line drop
;


: close-file                                 { Close the file pointed to by the file  }
  conway-file-id @                                  { handle.                                }
  close-file drop
; 

{ --------------------------- Running Conway ---------------------------- }

10 constant iterations
0 constant wrap
row col make_array constant matrix
row col make_array constant new_matrix

matrix fill_0
new_matrix fill_0

{ -------------------------- Initialise matrix with seed --------------------- }
matrix 1 2 3 array_!
matrix 1 3 2 array_!
matrix 1 3 4 array_!
matrix 1 4 3 array_!

{ -------------------------- Run word ------------------------------- }

: run_conway
    wrap 0= if
        matrix wrapping
        ." Running with Wrapping "
    else
        matrix no_wrap
        ." Running with no wrapping "
    then 
    make-file
    iterations 0 do 
        matrix write-matrix
        write-blank
        matrix show_array
        new_matrix matrix scan_array
        wrap 0= if 
            new_matrix wrapping 
        then 
        matrix new_matrix set_matrix_equal
    loop
    ;


