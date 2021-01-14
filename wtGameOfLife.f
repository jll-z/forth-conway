( -- MATRIX STYLE UTILISING ALLOT -- )
: MATRIX ( mn -- ) CREATE 2DUP , , * DUP HERE SWAP 0 FILL ALLOT DOES> ( j i addr -- addr-i,j ) CELL+ DUP @ ROT * + + CELL+ ;
: ROWS -2 CELLS 0 ;
: COLUMNS -1 CELLS 0 ;
: LOC ROWS ;
( -- THIS CAN BE UTILISED BY CALLING m n matrix testmatrix -- )
( -- j i testmatrix c@ will get the value at index i, j-- )
( -- n j i testmatrix c! will assign n to index i, j -- )
( -- rows testmatrix @ will get the rows of the matrix -- )
( -- columns testmatric @ will get the columns of the matrix -- )


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
