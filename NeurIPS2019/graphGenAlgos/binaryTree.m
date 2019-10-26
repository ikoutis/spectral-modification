function [parent, children, n, external, level] = binaryTree(k, s, parent, children, external, level)

% input ********************
% k: height of the binary tree. In effect, if the root starts with 1
% s: the starter node
% ********************

% output ********************
% level: the level of a node is the height of the tree at which a node resides. 
% parent, children: parent and children here are used for convenience and do not
% matter in undirected graph
% external: contains the list of external nodes
% n: total number of nodes in this type of tree
% ********************

% known ********************
% the total number of nodes (both internal and external) is 2^k - 1
% the total number of external leaves is 2^(k-1)
% the total number of internal leaves is 2^(k-1)-1
% ********************

% index of one side of an edge
idx = 1;
% external node index start
idxex = 1;
% when created for a double binary tree
% the position is added on to the previous number of node
if s > 1 
    idx = 2^k-1;
    idxex = 2^(k-1)+1;
end

% assign value for the parent node
for i= 1:2^(k-1)-1
    parent(idx+(i-1)*2:idx+(i-1)*2+1) = i+s-1;
end

% assign value for the children node
for i = 2:2^(k)-1
    children(idx+i-2) = i+s-1;
end

% list out all node that is external
external(idxex:idxex+2^(k-1)-1) = 2^(k-1)+s-1:2^(k)+s-2;

% report the total number of node
n = 2^k - 1;

% the level of each node
if s == 1
    level_base = 1;
else
    % treat 1 as the root node
    % therefore, level of node in a tree that is not starting from 1 
    % will be increased by 1
    level_base = 2;
end
level(s:s+n-1) = floor(log2(1:n))+level_base;
end