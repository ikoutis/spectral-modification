function clus_vec = classification(embedding, clus_num, G)

% input *****
% embedding:  n x dim matrix. Row i is embedding of node i into R^{dim}
% clus_num: the number of clusters that need to be classified
% G: simple graph G, is only required for opts.clus_num == 2 or adjacency
% matrix
% ********************
%
% output ********************
% clus_vec is a vector of size equal to the number of nodes, and gives a
% cluster ID for every number
% ********************

if clus_num > 2
    clus_vec = kmeans_pp(embedding , clus_num);   %kmeans_pp is in helpers of consClust
else
    if (nargin == 2)
        disp('Check input, original graph is required');
    else
        try G.Edges.EndNodes(1);
        catch G = graph(G);
        end
        A = adjacency(G, 'weighted');
        clus_vec = biPartition(A, embedding(:,clus_num-1), 0);  % 0 for path, 1 for tree
    end
end

end