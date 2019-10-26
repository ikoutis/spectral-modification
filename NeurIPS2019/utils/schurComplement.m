function A = schurComplement(G, modified_G)

% input *****
% G: a graph G. 
% modified_G: the spectrally modified of G
% ***************

% output *****
% A: the schur of modified G
% *****************

[n, ~] = size(G.Nodes);

% Find the unnormalized laplacian matrix of the reshuffled adjacency
% matrix.
s_swA = adjacency(modified_G, 'weighted');
s_swL = laplacianAdj(s_swA, 0, 0);
[Q,~,~] = cholGsparse(s_swL,height(modified_G.Nodes)-n);

A = LaplacianToAdjancency(Q);



end