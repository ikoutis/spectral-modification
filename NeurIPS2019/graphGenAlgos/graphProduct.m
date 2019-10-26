function [Gprod] = graphProduct(G1, G2)
% input ********************
% G1, G2: Two graphs to find their cartesian product
% ********************

% output ********************
% GP: The product graph of two input graph G1 and G2
% ********************

% reference ********************
% https://www.mathworks.com/matlabcentral/answers/335123-product-of-two-graphs-in-matlab
% ********************
A1 = adjacency(G1);
A2 = adjacency(G2);
I1 = speye(numnodes(G1));
I2 = speye(numnodes(G2));
Aprod = kron(A1, I2) + kron(I1, A2);
Gprod = graph(Aprod);

end