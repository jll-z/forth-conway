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
