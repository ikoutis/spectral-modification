function [DBT, parent, children, n, external, level] = doubleBinaryTree(k)
% input ********************
% k: height of one side of the binary tree.
% ********************

% output ********************
% parent, children: parent and children here are used for convenience and do not
% matter in undirected graph
% external: contains the list of external nodes
% n: total number of nodes in this type of tree
% level: the level of a node is the height of the tree at which a node resides. 
% DBT: double binary tree graph
% ********************

% known ********************
% the total number of nodes (both internal and external) is 2^(k+1) - 2
% the total number of external leaves is 2^k
% the total number of internal leaves is 2^k-2
% ********************

% the size of the parent is the same as one of the children
% the last +1 is reserved to connected the two tree
parent = zeros(1, 2^(k+1)-4+1);
children = zeros(1, 2^(k+1)-4+1);
external = zeros(1,2^k);
level = zeros(1,(2^(k+1)-2));
s = 1;
n = 0;

[parent, children, n, external, level] = binaryTree(k, s, parent, children, external, level);
[parent, children, n, external, level] = binaryTree(k, n+1, parent, children, external, level);

% connect two binary trees to produce
% the double binary tree
parent(end) = s;
children(end) = n+1;
n = 2*n;

% construct the graph
DBT = graph(parent, children);

end