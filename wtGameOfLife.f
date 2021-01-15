( -- MATRIX STYLE UTILISING ALLOT -- )
: ARRAY ( n/mn--- ) DEPTH 1 = IF 1 THEN CREATE 2DUP , , * DUP HERE SWAP 0 FILL ALLOT DOES> ( j i addr -- addr-i,j ) DUP @ 1 = IF 0 SWAP THEN CELL+ DUP @ ROT * + + CELL+ ; ( -- EXTENDING MATRIX DEFINITION TO ALLOW FOR 1D ARRAYS -- )
: ROWS -2 CELLS 0 ;
: COLUMNS -1 CELLS 0 ;
: LOC ROWS ;
: LEN -1 CELLS ;
( -- THIS CAN BE UTILISED BY CALLING m n matrix testmatrix -- )
( -- j i testmatrix c@ will get the value at index i, j-- )
( -- n j i testmatrix c! will assign n to index i, j -- )
( -- rows testmatrix @ will get the rows of the matrix -- )
( -- columns testmatric @ will get the columns of the matrix -- )
( -- Extending our definition to allow for 1D arrays or lists -- )
( -- n matrix testlist --- )
( --- i testlist c@ will index the list -- )
( --- n i testlist c! will assign n to the index i -- )
( -- len testlist @ will get the length of the list -- )

( -- MATRIX STYLE UTILISING ALLOCATE -- )
VARIABLE M
VARIABLE N
: ALTMATRIX ( mn -- ) * DUP HERE SWAP 0 FILL ALLOCATE DROP ;
: INDEX ( j i addr -- addr-i, j ) -ROT M @ * + + ;
( -- THIS CAN BE UTILISED BY FIRST ASSINGING M AND N, and then calling it as M @ N @ altmatrix constant testmatrix -- )
( -- j i testmatrix index c@ will get the value at index i, j -- )
( -- n j i testmatrix index c! will assign n to index i, j -- )
( -- n @ will get the rows of the testmatrix -- )
( -- m @ will get the columns of the testmatrix -- )

200 M !
200 N !
M @ N @ ARRAY BOARD ( -- This is our main matrix -- )
M @ N @ ARRAY COUNTBOARD ( -- This is our counting matrix -- )

( -- UPDATING COUNTING BOARD -- )

: CWRAP DUP 0 < IF COLUMNS BOARD @ + ELSE COLUMNS BOARD @ MOD THEN ;
: RWRAP DUP 0 < IF ROWS BOARD @ + ELSE ROWS BOARD @ MOD THEN ;
: R+ 1 + RWRAP ;
: R- 1 - RWRAP ;
: C+ SWAP 1 + CWRAP SWAP ;
: C- SWAP 1 + CWRAP SWAP ;
: COUNTIJ ( j i -- count ) 0 -ROT 2DUP R+ BOARD c@ 3 ROLL + -ROT 2DUP R- BOARD c@ 3 ROLL + -ROT 2DUP C+ BOARD c@ 3 ROLL + -ROT 2DUP C- BOARD c@ 3 ROLL + -ROT 2DUP R+ C+ BOARD c@ 3 ROLL + -ROT 2DUP R- C- BOARD c@ 3 ROLL + -ROT 2DUP R+ C- BOARD c@ 3 ROLL + -ROT R- C+ BOARD c@ + ;
: UPDATECB ROWS COUNTBOARD @ 0 DO COLUMNS COUNTBOARD @ 0 DO I J COUNTIJ I J COUNTBOARD c! LOOP LOOP ;

