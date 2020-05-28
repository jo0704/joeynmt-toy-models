#!/usr/bin/env python3
#Authors: Joëlle Gasser and Wenyuan Wu
#programme that computes a graph to measure the impact of beam size on BLEU score

import matplotlib.pyplot as plt
import numpy as np

data = np.array([
    [1, 12.1],
    [2, 14.7],
    [3, 16.0],
    [4, 16.7],
    [5, 16.9],
    [6, 17.4],
    [7, 17.4],
    [8, 17.7],
    [9, 18.0],
    [10, 18.1],
])
x, y = data.T

#plot average line
y_mean = [np.mean(y) for i in y]
fig, ax = plt.subplots()
plt.plot(x, y_mean, label='Mean of the 10 BLEU scores', linestyle='--')

#plots the coordinates
plt.plot([1,2,3,4,5,6,7,8,9,10],[12.1,14.7,16.0, 16.7,16.9,17.4,17.4,17.7,18.0,18.1], marker='o', color='red')

#give a title and a label to x and y axis
plt.title('Impact of beam size on BLEU score')
plt.xlabel('BEAM SIZE')
plt.ylabel('BLEU')
plt.legend()

#save the graph as png
plt.savefig('bleu_beam.png')
plt.savefig('bleu_beam.png', bbox_inches='tight') #remove whitespace around the image