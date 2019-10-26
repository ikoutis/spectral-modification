function [normalizedCost, edge_cut_node, edge_cut_predecessor, total_node_of_cluster, rawCosts] = linearTreePartition6(AT)

% Edges of T
% [p,c,~] =  find(triu(adjacency(T,'weighted')));
% [p, c, ~] = find(triu(AT));


% Pick an arbitrary root
% root = p(1);
[root, ~,~] = find(AT>0,1);

% Number of edges
% e_T = length(p);
[e_n, ~] = size(nonzeros(AT));
e_T = e_n/2;

% Total degree of T
[~, ~, total_degree_T] = find(sum(sum(AT)));
degree_T = sum(AT);

% Dividing parent and children nodes based on dfs
[~, dt, ~, pred] = dfs(AT,root, 0); % this will produce ans = 1. Possibly mute this in dfs.
% [~, dt, ~, pred, suc] = dfs_suc(AT, root); % huong add suc (i.e. successor into the dfs algorithm);
% parent_T = pred(suc);
% [~,idx] = sort(dt(nonzeros(pred))); % sorting is faster than not sorting with successor tracking in dfs ?!?
% k = [idx(end); idx(1:end-1)];
% k = idx;
[~,idx] = sort(dt);
k = idx(find(idx==root):end); % to remove all smaller connected component
dfs_postorder_nodes = flip(k);

children_T = k(2:end);
parent_T = nonzeros(pred(idx(2:end)))';

% variable initiations
rawCosts = sparse(zeros(1, e_T));
total_degree_of_cluster = sparse(zeros(1, e_T));
total_node_of_cluster = sparse(zeros(1, e_T));
edge_cut_node = sparse(zeros(1, e_T+1)); % one end of the edge to be cut
edge_cut_predecessor = sparse(zeros(1, e_T+1)); % the other end of the edge to be cut

% establish lookup predecessors and successors of T
% highest_node_id = e_T + 1;
[n1,n2,~] = find(max(AT));
highest_node_id = max(union(n1,n2));
% dfs_predecessors = sparse(zeros(highest_node_id,1));
dfs_successors = cell(1, highest_node_id); % a node may have more than one child, use cell structure

dfs_predecessors(children_T(1:length(k)-1)) = parent_T(1:length(k)-1);

for i = 1:length(k)-1
    try
        dfs_successors{parent_T(i)} = [dfs_successors{parent_T(i)}, children_T(i)];
    catch
    end
end


for i=1:length(dfs_postorder_nodes)-1 % excluding the root node
    % node under consideration
    node = dfs_postorder_nodes(i); % this node is a child of a parent that composes the edge cut
    % tracking what edge being cut of the tree by the actual node number
    edge_cut_node(node) = node;
    edge_cut_predecessor(node) = dfs_predecessors(node);
    % the raw cost of a node while traversing postorder is its own degree
    [~,~,rawCosts(node)] = find(degree_T(1, node)); % due to degree_T is sparse
    % the degree of the separated clusted after the cut
    total_degree_of_cluster(node) = degree_T(node);
    % the number of nodes separated between two partition if the edge is
    % removed
    total_node_of_cluster(node) = 1;
    % if this is a parent node (not a leaf node), add up the cost of the
    % direct children involved
%     disp(node)
    node_children = dfs_successors{node};
    if isempty(node_children) ~= 1
        for child= node_children
            rawCosts(node) = rawCosts(node) + sum(rawCosts(child));
            total_degree_of_cluster(node) = total_degree_of_cluster(node) + sum(total_degree_of_cluster(child));
            total_node_of_cluster(node) = total_node_of_cluster(node) + sum(total_node_of_cluster(child));
        end
        try
            rawCosts(node) = rawCosts(node) - 2 * sum(rawCosts(dfs_successors{node}));
        catch
        end
    end
end

% calculate the normalized cost
total_degree_of_cluster = sparse(min(total_degree_of_cluster, total_degree_T - total_degree_of_cluster));

rawCosts = sparse(rawCosts);
normalizedCost = rawCosts./ sparse(total_degree_of_cluster);

end