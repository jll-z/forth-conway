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

VARIABLE M
VARIABLE N

200 M !
200 N !
M @ N @ ARRAY BOARD ( -- This is our main matrix -- )
M @ N @ ARRAY COUNTBOARD ( -- This is our counting matrix -- )
2 ARRAY LIVERUELS
1 ARRAY BORNRULES


( -- UPDATING -- )
( -- Updating Counting Board -- )

: CWRAP DUP 0 < IF COLUMNS BOARD @ + ELSE COLUMNS BOARD @ MOD THEN ;
: RWRAP DUP 0 < IF ROWS BOARD @ + ELSE ROWS BOARD @ MOD THEN ;
: R+ 1 + RWRAP ;
: R- 1 - RWRAP ;
: C+ SWAP 1 + CWRAP SWAP ;
: C- SWAP 1 + CWRAP SWAP ;
: COUNTIJ ( j i -- count ) 0 -ROT 2DUP R+ BOARD c@ 3 ROLL + -ROT 2DUP R- BOARD c@ 3 ROLL + -ROT 2DUP C+ BOARD c@ 3 ROLL + -ROT 2DUP C- BOARD c@ 3 ROLL + -ROT 2DUP R+ C+ BOARD c@ 3 ROLL + -ROT 2DUP R- C- BOARD c@ 3 ROLL + -ROT 2DUP R+ C- BOARD c@ 3 ROLL + -ROT R- C+ BOARD c@ + ;
: UPDATECOUNTBOARD ROWS COUNTBOARD @ 0 DO COLUMNS COUNTBOARD @ 0 DO I J COUNTIJ I J COUNTBOARD c! LOOP LOOP ;

( -- Updating Life Board -- )

: BORN? FALSE SWAP LEN BORNRULES @ 0 DO DUP I BORNRULES c@ = IF SWAP DROP TRUE SWAP THEN LOOP DROP ; ( -- Potentially inefficent implementation, but I need to figure out how to break out of do loops -- )
: LIVE? FALSE SWAP LEN LIVERULES @ 0 DO DUP I LIVERULES c@ = IF SWAP DROP TRUE SWAP THEN LOOP DROP ;
: livedie? 1 = IF LIVE? IF 1 ELSE 0 THEN ELSE BORN? IF 1 ELSE 0 THEN THEN ;
: UPDATEBOARD ROWS BOARD @ 0 DO COLUMNS BOARD @ 0 I J COUNTBOARD c@ I J BOARD c@ LIVEDIE? I J BOARD c! LOOP LOOP ;

: UPDATE UPDATECOUNTBOARD UPDATEBOARD ;

( -- There are possible ineffencies in looping through both the count board and loop board 2 times but I can't figure out how else to do it, possibly generate an update list containing only the index pairs of the updated elements -- )







