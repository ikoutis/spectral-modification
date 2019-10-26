function H = inheritWeight(H,G)

% input
% G: weighted graph
% H: a graph on the same set of nodes as G
%
% output
% H: inherits the weights from the corresponding edges in G
% **************

a = H.Edges.EndNodes(:,1);
b = H.Edges.EndNodes(:,2);
idx = findedge(G,a,b);
edgeweight = G.Edges.Weight(idx);
H.Edges.Weight = edgeweight;

end
