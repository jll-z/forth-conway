( -- INCLUDING OPTIONS -- )
INCLUDING-OPTION C:\ForthInc-Evaluation\SWIFTFORTH\LIB\OPTIONS\` rnd.f
INCLUDING-OPTION C:\ForthInc-Evaluation\Projects\GameofLife\` bmpCode.f ( -- This code I shall include in the git -- )

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
2 ARRAY LIVERULES
1 ARRAY BORNRULES


( -- STATISTICS -- )
VARIABLE GEN
0 GEN !
: G+ GEN @ 1+ GEN ! ;


( -- RULESET -- )
: B3L23 3 0 BORNULES c! 2 0 LIVERULES c! 3 1 LIVERULES c! ;


( -- UPDATING -- )
( -- Updating Counting Board -- )
0 CONSTANT BOUNDARIES  ( -- 0 for periodic, 1 for absorbing -- )
: CWRAP SWAP DUP 0 < IF COLUMNS BOARD @ + ELSE COLUMNS BOARD @ MOD THEN SWAP ;
: RWRAP DUP 0 < IF ROWS BOARD @ + ELSE ROWS BOARD @ MOD THEN ;
: RABSORB DUP -1 = SWAP DUP ROWS BOARD @  = OR IF FALSE ELSE TRUE THEN ; ( -- if i = -1 or N produce logical false -- )
: CABSORB SWAP DUP -1 = SWAP DUP COLUMNS BOARD @ = OR IF SWAP FALSE ELSE SWAP TRUE THEN ; ( -- if j = -1 or M produce logical false -- )
: WRAP ( j i -- 1/0) RWRAP CWRAP BOARD c@ ; ( -- performs the wrapping for periodic boundaries -- )
: ABSORB ( j i -- 1/0 ) RABSORB CABSORB AND IF BOARD c@ ELSE 2DROP 0 THEN ; 
: B@ ( j i  -- 1/0 ) BOUNDARIES 0 = IF WRAP ELSE ABSORB THEN ;
: R+ 1 + ;
: R- 1 - ;
: C+ SWAP 1 + SWAP ;
: C- SWAP 1 - SWAP ;
: COUNTIJ ( j i -- count ) 0 -ROT 2DUP R+ B@ 3 ROLL + -ROT 2DUP R- B@ 3 ROLL + -ROT 2DUP C+ B@ 3 ROLL + -ROT 2DUP C- B@ 3 ROLL + -ROT 2DUP R+ C+ B@ 3 ROLL + -ROT 2DUP R- C- B@ 3 ROLL + -ROT 2DUP R+ C- B@ 3 ROLL + -ROT R- C+ B@ + ; 
: UPDATECOUNTBOARD ROWS COUNTBOARD @ 0 DO COLUMNS COUNTBOARD @ 0 DO I J COUNTIJ I J COUNTBOARD c! LOOP LOOP ;

( -- Updating Life Board -- )

: BORN? FALSE SWAP LEN BORNRULES @ 0 DO DUP I BORNRULES c@ = IF SWAP DROP TRUE SWAP THEN LOOP DROP ; 
: LIVE? FALSE SWAP LEN LIVERULES @ 0 DO DUP I LIVERULES c@ = IF SWAP DROP TRUE SWAP THEN LOOP DROP ;
: LIVEDIE? 1 = IF LIVE? IF 1 ELSE 0 THEN ELSE BORN? IF 1 ELSE 0 THEN THEN ;
: UPDATEBOARD ROWS BOARD @ 0 DO COLUMNS BOARD @ 0 DO I J COUNTBOARD c@ I J BOARD c@ LIVEDIE? I J BOARD c! LOOP LOOP ;

: UPDATE UPDATECOUNTBOARD UPDATEBOARD ;

( -- There are possible ineffencies in looping through both the count board and loop board 2 times but I can't figure out how else to do it, possibly generate an update list containing only the index pairs of the updated elements -- )


( -- DISPLAY CODE -- )
: ASCIIDISPLAY CR ." GENERATION: " GEN @ . CR ROWS BOARD @ 0 DO CR COLUMNS BOARD @ 0 DO I J BOARD c@ 1 = IF ." *" ELSE ."  " THEN LOOP LOOP ;

: TRANSLATEBMP DUP DUP 2 + SWAP 54 + 0 -ROT DO DUP 0 BOARD c@ 0 = if 255 255 255 ELSE 000 000 000 THEN I TUCK c! 1+ TUCK c! 1+ c! 1 + 3 +LOOP DROP ;
: BMPDISPLAY bmp-address @ TRANSLATEBMP bmp-address @ bmp-to-screen-stretch ;
: BMPSETUP M @ bmp-x-size ! N @ bmp-y-size ! Setup-Test-Memory New-bmp-Window-strech bmp-window-handle ! ;

: DISPLAYSETUP BMPSETUP ;
: DISPLAY ASCIIDISPLAY ;


( -- SEEDS -- )

: RANDOMSEED ROWS BOARD @ 0 DO COLUMNS BOARD @ 0 DO 2 RND I J BOARD c! LOOP LOOP ;



( -- LIFE -- )


: SETUP B3L23 DISPLAYSETUP ;
: LIFE 0 SETUP DO DISPLAY UPDATE G+ LOOP :


( -- DEBUGGING COMMANDS -- )
: SMALLDISPLAY ." MAIN BOARD " 10 0 DO CR 10 0 DO I J BOARD c@ . LOOP LOOP CR CR ." COUNT BOARD" 10 0 DO CR 10 0 DO I J COUNTBOARD c@ . LOOP LOOP ; ( -- Just a little command to see the behaviour of a small section of the board -- )
: CLEAR ROWS BOARD @ 0 DO COLUMNS BOARD @ 0 DO 0 I J BOARD c! 0 I J COUNTBOARD c! LOOP LOOP ;






