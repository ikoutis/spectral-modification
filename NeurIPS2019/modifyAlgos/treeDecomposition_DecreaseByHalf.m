function [cc] = treeDecomposition_DecreaseByHalf(G, opts)
%
% input ********************
% @G: Weighted Graph
%
% opts.iter_num: number of output trees (size of cc)
% ********************
%
% output ********************
% cc: cell array
%
% cc{i}.mst: Spanning tree of G at iteration i
%
% Edges of cc{i}.mst are discounted by a factor of 2 in G for next iteration
% ********************



cc = cell(1,opts.iter_num);

for i = 1: opts.iter_num

%     T = randish_maxspantree(G, opts.rand_tree);
    T = highStretchTreeGen(G);
    cc{i}.mst = T;

    % temporary remove edges of tree T
    G = rmedge(G, T.Edges.EndNodes(:,1), T.Edges.EndNodes(:,2));

    % decrease weight of T by half
    T.Edges.Weight = T.Edges.Weight / 2;

    % reconstruct G
    G = addedge(G, T.Edges.EndNodes(:,1), T.Edges.EndNodes(:,2), T.Edges.Weight);

end


end
