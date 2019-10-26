function [biclassification] = biPartition(G, ev, ptype)

% input ******
% G: a simple graph or its adjacency matrix
% ev: 2nd smallest eigen vector for G
% ptype: The type of structure based on which the original vertices are
% bi-partitioned. "1" for using the minimum spanning tree. "0" for using
% path
% *************

% output ****
% T: A spanning tree based on the modification on G's edge weights.
% A: The weighted adjacency matrix of T. Note, testing the
% hypothesis that the low stretch tree can be approximate using the 2nd
% lowest eigen vector and weight of G. For example, for an edge (u,
% v) with weight w, the new weight of G is w(x_u - x_v)^2 where x_u and x_v
% are the corresponding values of the eigen vector of the 2nd smallest
% eigen value.
% **************


try 
    G.Edges.EndNodes(1)
catch
    G = graph(G);
end

% obtain graph G node count
[n,~] = size(G.Nodes);

u = G.Edges.EndNodes(:,1);
v = G.Edges.EndNodes(:,2);

if ptype == 1
    new_w = abs(ev(u) - ev(v));
    G_mod = graph(u,v,new_w);
    T = minspantree(G_mod); 
elseif ptype == 0
    [sorted_ev, idx] = sort(ev, 'ascend');
    T = pathGraphGenFromData(sorted_ev, idx);
end

% sweep through all of the edges of T to identify best cut.
[normalizedCost, edge_cut_node, edge_cut_predecessor, total_node_of_cluster, ~] = ...
    linearTreePartition5(adjacency(T,'weighted'));

min_norm_cost = min(normalizedCost);

% identify all indices where the normalized cost cut <= minimum normalized
% cost.
result = normalizedCost <= min_norm_cost;

% determine the balance of the cut
% the smaller size among the sizes of the two node sets
% (purely by node count, not by weight or degree)
total_node_of_cluster_sw = result.* min(total_node_of_cluster, n - total_node_of_cluster); 

% identify the edge cut that produce the best balanced or the node counts
% are maxed out. Max of min node counts.
[mv, ~] = max(total_node_of_cluster_sw);

% there may be a tie here, will cut the first found value
% indice of all edges that yields the most balance cut.
mis = find(total_node_of_cluster_sw == mv,1);

% remove the edge for bipartition
T2 = rmedge(T, edge_cut_node(mis), edge_cut_predecessor(mis));

% find the connected component
biclassification = conncomp(T2);

% if ptype == 0
    % at this point, the classification must be reordered back to the
    % original graph.
%     biclassification = biclassification(idx);
%     biclassification = biclassification - 1;
% end

end