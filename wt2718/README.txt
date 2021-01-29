---------OVERVIEW-----------

Within the wt2718 folder there are two files, wtGameOfLife.f and bmpCode.f

The wtGameOfLife.f contains the main game of life script, with visual displaying

The visual display code is given by bmpCode.f, this is a modified helper code and it should have the disclamer at the start 

To run wtGameOfLife.f ensure you have the file paths configured correctly for the bmp display file and rnd file. I cannot automatically configure this as it is specific to the directory of the user.

When you load wtGameOfLife.f into a SwiftForth terminal (using the Include) it will come up with N and Line are not unique. I think I am overwritting some old definition of those words, but I am not completely sure. Regardless, the code will run perfectly.

To observe the game of life, choose a seed from the seed section and enter it into the terminal. This will initalise the board with the seed.
Then run n LIFE, where n is the integer number of generations. This will automatically run the game of Life for those generations, printing the generation number to the terminal.

To clear the board and enter another seed, enter the CLEAR command and then the seed you would like to test.

An example of this running would be:

RANDOMSEED
500 LIFE

To generate 500 Generations of the Game of Life

To vary the board size, simply assign a different number to the variables M and N. For the BMP display code, the numbers chosen have to be integer multiples of 4.

To vary the rulset, simply modify the contents of the LIVERULES and BORNRULES arrays, either by changing their size (where I have indicated) and implement a new rulset as laid out in the custom rulset template. Then, the rulset must be modified in the SETUP in the life section of the code.
