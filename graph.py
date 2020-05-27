#!/usr/bin/env python3
#programme to create a graph of beam size versus BLEU
#Authors: Joëlle Gasser and Wenyuan Wu

import matplotlib.pyplot as plt
import numpy as np


x= np.arrange(0,1) 

#plot average line
y_mean = [np.mean(y) for i in y]
fig, ax = plt.subplots()
mean_line = ax.plot(x, y_mean, label='Mean of averages', linestyle='--')

#give a label to x and y axis
plt.xlabel('BEAM SIZE')
plt.ylabel('BLEU')

plt.vlines(x, 0, y)


#save the graph as png
plt.savefig('bleu_beam.png')
savefig('bleu_beam.png', bbox_inches='tight') #remove whitespace around the image