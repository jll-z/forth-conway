{ ------------------------------------ Conway Game of Life jll18 README ------------------------------ }

The script contains 3 files in order to run Conway's Game of Life

1. Conway-Codes.f
2. Temperature-Script.f
3. bmp-display-2.f



Running Conway Game of Life

Conways game of life can be run by typing the run_conway word into the Forth terminal after ecexuting 
all the relevant files. Should a temperature parameter be included, this can be run using the run_conway_with_temperature word.
More information on the temperature methods can be found below. The simulation can be run immediately using default settings but these variables
can be easily changed using the methods below. The default is to run with a randomly filled array but this can be changed using he methods below or by
manually inputting aray items using the array_! word. (e.g. to place a live cell in the position (3,2) we would input matrix 1 3 2 array_! ). Before inputing new 
cells, it is advisable to use the word reset to clear the array first

Note that the file paths of the externally referenced files bmp-diplay-2 and Teperature-Script will likely
need to be changed to the paths of the files on the users computer. This can be done on lines 321 (visual output)
and 480 (Temperature-Script)


There are some variable which may be adjusted by the user to suit the experimenal needs, 
these are located in 2 main parts of the code

1. The number of rows and columns, these can be changed on lines 5 and 6

2. Visualisation options, select 1 to view the bmp-display and 0 for no visualisation. 
This can be adjusted on line 378. Default is 1

3. Statistics Option. If switched to 1, the statistics will be printed on the screen. This is found on line 379.
Default is 1

4. Wrapping. Select 1 for absorbing boundaries and 0 for wrapping boundaries. This is found on line 376.
Defaut is 1

5. Iterations. The default number is 200 iterations, this can be changed by altering the constant on line 375

6. Boundary Checking. This method checks to see if the cells at the edges of the board are alive. Default is 0
change to 1 to check

Description of Script Files

1. Conway-Codes.f

This file contains all the main methods to run Conway's Game of Life, including the run code and file
output options. 

2. bmp-display-2.f

Thsi file contains the Windows specific code required to run the visualisation as well as the code to write
the life board to te bmp-data. There is no need to change any of the script in this code

3. Temperature-Script.f

This file contains the words to change the effective "temperature" of the life board, which introduces
indeterminiitic rules to Conway's Game of Life. This is used to in our investigations into the Statistical 
Physics quanitities in the Game of Life. There is also a word go_with_temperature which can be optionally used
to run the code with the temperature element.The temperaure of the system is by default set to 0 but can be changed
on line 2.

The temperature can also be input as a float, this requires changing the scaling fouund on line 3. 

Life Board Seeds

There are a few seeds which can be initialised immediately. 

1. Horizontal_row
This creates a horizontal row at the centre of the life-board, this is input as 

length of life horizontal_row

2. fill_50
This creates a randomly filled sees which is 50-50 alive and dead, input us

fill_50

3. fill_percentage

This creates a randomly filled seeds which are the defined percentage alive, input as

(percentage) fill_percentage
