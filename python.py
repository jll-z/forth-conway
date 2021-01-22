import matplotlib.pyplot as plt
from matplotlib import colors


import numpy as sp
rows = 5
cols = 5
iterations = 10

with open("Conway_Files.txt") as f:
    lines = f.readlines()
    
matrix_array = sp.zeros((rows, cols))
for i in range(len(lines)):
    line = lines[i].split()
    line = sp.array(list(map(int, line)))
    if i == 0:
        matrix_array = sp.stack((matrix_array, line.reshape(rows, cols)))
    else: 
        matrix_array = sp.concatenate((matrix_array, [line.reshape(rows, cols)]))
        

# Run this code if you only want to see one generation still
fig, ax = plt.subplots()
cmap = colors.ListedColormap(['white', 'black'])
bounds = [0,1, 2]
norm = colors.BoundaryNorm(bounds, cmap.N)
ax.grid(which='major', axis='both', linestyle='-', color='k', linewidth=2)
ax.set_xticks(sp.arange(-0.5, cols, 1));
ax.set_yticks(sp.arange(-0.5,rows, 1));
ax.set_yticklabels([])
ax.set_xticklabels([])
im = plt.imshow(matrix_array[9], cmap=cmap, norm=norm, animated=True)


plt.show()

# Run this code to show animation
import matplotlib.animation as animation
fig, ax = plt.subplots()
cmap = colors.ListedColormap(['white', 'black'])
bounds = [0,1, 2]
norm = colors.BoundaryNorm(bounds, cmap.N)
#ax.grid(which='major', axis='both', linestyle='-', color='k', linewidth=2)
ax.set_xticks(sp.arange(-0.5, cols, 1));
ax.set_yticks(sp.arange(-0.5,rows, 1));
ax.set_yticklabels([])
ax.set_xticklabels([])
ims =[]
for i in range(iterations):
    im = plt.imshow(matrix_array[i], cmap=cmap, norm=norm, animated=True)
    ims.append([im])
    
ani = animation.ArtistAnimation(fig, ims, interval=50, blit=True, repeat_delay = 1000)



plt.show()

def period(list_arrays):
    repeat = False
    for i in range(len(list_arrays)):
        for j in range(i):
            if sp.array_equal(list_arrays[i], list_arrays[j]) == True:
                period = i - j
                generation_oscillating = j -1 
                repeat = True
                break
        if repeat == True:
            break
    return period, generation_oscillating
