## Spectral Modification of Graphs

Spectral graph clustering is based on the connection between eigenvectors of the normalized graph Laplacian and low-conductance cuts in the graph. However this connection is not always direct. It is often the case that the cut corresponding to the lowest eigenvectors of the graph is far from the optimal cut.  The code, based on this [NeurIPS paper](https://proceedings.neurips.cc/paper/2019/hash/dbbf603ff0e99629dda5d75b6f75f966-Abstract.html) modifies the input graph in a way that approximately preserves its cluster structure, while forcing its lower eigevectors to 'capture' a better cut. 

The code is written in MATLAB and depends on the [CMG solver](https://github.com/ikoutis/cmg-solver/wiki/Combinatorial-Multigrid). 

To run, install CMG and follow the steps suggested by demo.m
