( -- INCLUDING OPTIONS -- )
INCLUDING-OPTION C:\ForthInc-Evaluation\Projects\Game of Life\` bmpCode.f ( -- This code I shall include in the git -- )


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

190 M !
190 N !
M @ N @ ARRAY BOARD ( -- This is our main matrix -- )
M @ N @ ARRAY COUNTBOARD ( -- This is our counting matrix -- )
2 ARRAY LIVERULES
1 ARRAY BORNRULES


( -- STATISTICS -- )

VARIABLE GEN
VARIABLE ALIVE
0 ALIVE !
0 GEN !
: G+ GEN @ 1+ GEN ! ;
: A+ ALIVE @ 1+ ALIVE ! ;

: COUNTALIVE 0 ALIVE ! ROWS BOARD @ 0 DO COLUMNS BOARD @ 0 DO I J BOARD c@ 1 = IF A+ THEN LOOP LOOP ;

: STATSUPDATE COUNTALIVE ;


( -- RULESET -- )
: B3L23 3 0 BORNRULES c! 2 0 LIVERULES c! 3 1 LIVERULES c! ;


( -- UPDATING -- )
( -- Updating Counting Board -- )
0 CONSTANT BOUNDARIES  ( -- 0 for periodic, 1 for absorbing -- )
: CWRAP SWAP DUP 0 < IF COLUMNS BOARD @ + ELSE COLUMNS BOARD @ MOD THEN SWAP ;
: RWRAP DUP 0 < IF ROWS BOARD @ + ELSE ROWS BOARD @ MOD THEN ;
: RABSORB DUP -1 = SWAP DUP ROWS BOARD @  = ROT OR IF FALSE ELSE TRUE THEN ;
: CABSORB SWAP DUP -1 = SWAP DUP COLUMNS BOARD @ = ROT OR IF SWAP FALSE ELSE SWAP TRUE THEN ;
: WRAP ( j i -- 1/0) RWRAP CWRAP BOARD c@ ;
: ABSORB ( j i -- 1/0 ) RABSORB IF CABSORB IF BOARD c@ ELSE 2DROP 0 THEN ELSE 2DROP 0 THEN ; 
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

( -- DISPLAY CODE -- )
: ASCIIDISPLAY CR ." GENERATION: " GEN @ . CR ROWS BOARD @ 0 DO CR COLUMNS BOARD @ 0 DO I J BOARD c@ 1 = IF ." *" ELSE ."  " THEN LOOP LOOP ;

: TRANSLATEBMP DUP DUP 2 + @ + SWAP 54 + 0 ROWS BOARD @ 1 - 3 ROLL 3 ROLL DO 2DUP BOARD c@ 0 = if 255 255 255 ELSE 000 000 000 THEN I TUCK c! 1+ TUCK c! 1+ c! SWAP DUP COLUMNS BOARD @ 1 - = IF DROP 0 SWAP 1 - ELSE 1 + SWAP THEN 3 +LOOP 2DROP ;
: BMPDISPLAY bmp-address @ TRANSLATEBMP bmp-address @ bmp-to-screen-stretch ;
: BMPSETUP M @ bmp-x-size ! N @ bmp-y-size ! Setup-Test-Memory New-bmp-Window-stretch bmp-window-handle ! ;

: DISPLAYSETUP BMPSETUP ;
: DISPLAY BMPDISPLAY ;


( -- FILE I/O -- )
VARIABLE FILE-ID

: INITIAL-STATE s" C:\ForthInc-Evaluation\Projects\Game of Life\States.txt" r/w CREATE-FILE DROP FILE-ID ! ; 
( -- This file name needs to be modified to the specific directory the marker uses -- )
: WRITE-CURRENT ROWS BOARD @ 0 DO COLUMNS BOARD @ 0 DO I J BOARD c@ (.) FILE-ID @ WRITE-FILE DROP s"  " FILE-ID @ WRITE-FILE DROP LOOP LOOP s"  " FILE-ID @ WRITE-LINE DROP ;
: CLOSE-STATE FILE-ID @ CLOSE-FILE DROP ;


( -- File I/O for lab work -- )
VARIABLE LINE-SIZE
VARIABLE DENSITY-ID 
3 LINE-SIZE !
0 DENSITY-ID !

: DENSITYDATA s" C:\ForthInc-Evaluation\Projects\Game of Life\DENSITYDATA\density_" PAD PLACE BOUNDARIES 0 = IF s" periodic" ELSE s" absorbing" THEN PAD APPEND ROWS BOARD @ (.) PAD APPEND DENSITY-ID @ (.) PAD APPEND s" .txt" PAD APPEND PAD COUNT r/w CREATE-FILE DROP FILE-ID ! ;
: LINEDATA s" C:\ForthInc-Evaluation\Projects\Game of Life\LINEDATA\line_" PAD PLACE LINE-SIZE @ (.) PAD APPEND s" .txt" PAD APPEND PAD COUNT r/w CREATE-FILE DROP FILE-ID ! ;
: DENSITYFDATA s" C:\ForthInc-Evaluation\Projects\Game of Life\DENSITYDATA\DENSITYFINALSTATES\density_" PAD PLACE BOUNDARIES 0 = IF s" periodic" ELSE s" absorbing" THEN PAD APPEND ROWS BOARD @ (.) PAD APPEND DENSITY-ID @ (.) PAD APPEND s" .txt" PAD APPEND PAD COUNT r/w CREATE-FILE DROP FILE-ID ! ;
 

( -- SEEDS -- )
( -- GLIDER SEEDS, ENTER ANY OF THESE AT THE START TO OBSERVE BEHAVIOUR OF THAT SEED -- )
: RANDOMSEED ROWS BOARD @ 0 DO COLUMNS BOARD @ 0 DO 2 RND I J BOARD c! LOOP LOOP ;
: GLIDER 1 1 4 BOARD c! 1 2 4 BOARD c! 1 3 4 BOARD c! 1 3 3 BOARD c! 1 2 2 BOARD c! ;
: PIHEPTOMINO 1 M @ 2 / 1 - N @ 2 / BOARD c! 1 M @ 2 / N @ 2 / BOARD c! 1 M @ 2 / 1 + N @ 2 / BOARD c! 1 M @ 2 / 1 -  N @ 2 / 1 + BOARD c! 1 M @ 2 / 1 +  N @ 2 / 1 + BOARD c! 1 M @ 2 / 1 -  N @ 2 / 2 + BOARD c! 1 M @ 2 / 1 +  N @ 2 / 2 + BOARD c! ;
: EHEPTOMINO 1 M @ 2 / N @ 2 / BOARD c! 1 M @ 2 / 1 + N @ 2 / BOARD c! 1 M @ 2 / 2 + N @ 2 / BOARD c! 1 M @ 2 / 1 - N @ 2 / 1 + BOARD c! 1 M @ 2 / N @ 2 / 1 + BOARD c! 1 M @ 2 /  N @ 2 / 2 + BOARD c! 1 M @ 2 / 1 + N @ 2 / 2 + BOARD c! ;
: THUNDERBIRD 1 M @ 2 / 1 -  N @ 2 / BOARD c! 1 M @ 2 /  N @ 2 / BOARD c! 1 M @ 2 / 1 +  N @ 2 / BOARD c! 1 M @ 2 / N @ 2 / 2 +  BOARD c! 1 M @ 2 / N @ 2 / 3 +  BOARD c! 1 M @ 2 / N @ 2 / 4 +  BOARD c! ;
: FISH 1 4 2 BOARD c! 1 7 2 BOARD c! 1 3 3 BOARD c! 1 3 4 BOARD c! 1 3 5 BOARD c! 1 4 5 BOARD c! 1 5 5 BOARD c! 1 6 5 BOARD c! 1 7 4 BOARD c! ;
: LINESEED DEPTH 0 = IF M @ 2 - THEN LOCALS| a | a 2 / 2 * a = IF M @ 2 / a 2 / + ELSE M @ 2 / a 2 / 1 + + THEN M @ 2 / a 2 / -   DO 1 I N @ 2 / BOARD c! LOOP ;


( -- DEBUGGING COMMANDS -- )
: SMALLDISPLAY ." MAIN BOARD " 10 ROWS BOARD @ MIN 0 DO CR 10 COLUMNS BOARD @ MIN 0 DO I J BOARD c@ . LOOP LOOP CR CR ." COUNT BOARD" 10 0 DO CR 10 0 DO I J COUNTBOARD c@ . LOOP LOOP ;
: CLEAR ROWS BOARD @ 0 DO COLUMNS BOARD @ 0 DO 0 I J BOARD c! 0 I J COUNTBOARD c! LOOP LOOP ;



( -- LIFE -- ) 


: SETUP B3L23 DISPLAYSETUP STATSUPDATE INITIAL-STATE ;
: LIFE 0 GEN ! 0 SETUP DO WRITE-CURRENT UPDATE G+ CR GEN @ . DISPLAY STATSUPDATE LOOP CLOSE-STATE ; ( -- run n LIFE, with n being the number of generations required -- )


( -- GENERATING FUNCTIONS FOR LABWORK -- )
( -- These will not generate any files as they are specific to my directory -- ) 
: LINE 51 4 DO CLEAR LINEDATA CR LINE-SIZE @ DUP ." LINE-SIZE " . 1+ LINE-SIZE ! 1000 0 B3L23 I LINESEED DO WRITE-CURRENT UPDATE STATSUPDATE LOOP CLOSE-STATE CLEAR 1000 ms LOOP ;
: DENSITY 50 0 DO CLEAR DENSITYDATA CR DENSITY-ID @ DUP ." ITERATION " . 1+ DENSITY-ID ! 250 0 B3L23 RANDOMSEED DO WRITE-CURRENT UPDATE LOOP CLOSE-STATE CLEAR 100 ms LOOP ;
: FDENSITY 10 0 DO CLEAR DENSITYFDATA CR DENSITY-ID @ DUP ." ITERATION " . 1+ DENSITY-ID ! 8000 0 B3L23 RANDOMSEED DO I 1000 MOD 0 = IF I . THEN UPDATE LOOP WRITE-CURRENT CLOSE-STATE CLEAR 100 ms LOOP ;











