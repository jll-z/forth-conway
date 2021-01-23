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


""" Find velocity of glider using a 3d input matrix """
def find_velocity(input_matrix, glider, start_iteration, end_iteration):
    shape = len(glider)
    test_matrix = sp.zeros((shape, shape))
    x_pos = []
    y_pos = []
    count = 0
    generation = []
    for i in range(start_iteration, end_iteration):
        for j in range(int(shape/2), row - int(shape/2)):
            for k in range(int(shape/2), col - int(shape/2)):
                test_matrix = input_matrix[j-int(shape/2): j + int(shape/2), k-int(shape/2): k+int(shape/2)]
                if sp.array_equal(test_matrix, glider) == True:
                    count += 1
                    x_pos.append(j)
                    y_pos.append(k)
                    generation.append(i)
                    break
            break
        if count == 2:
            break
    time = generation[1] - generation[0]
    x_speed = (x_pos[1]-x_pos[0])/time
    y_speed = (y_pos[1] - y_pos[0])/time
    return x_speed, y_speed

""" Find the number of known patterns using one generation of life board """
def count_known_pattern(matrix_array, input_element):
    count = 0
    shape = len(input_element)
    for i in range(int(shape/2), row - int(shape/2)):
        for j in range(int(shape/2), col - int(shape/2)):
            test_matrix = matrix_array[i-int(shape/2): i+int(shape/2), j-int(shape/2): j+int(shape/2)]
            if sp.array_equal(input_element, test_matrix) == True:
                count += 1
    return count
    


        
