function [P, parent, children, n, external] = pathGraph(n) 
% input ********************
% n: the total number of nodes in a path graph
% ********************

% output ********************
% parent, children: parent and children here are used for convenience and do not
% matter in undirected graph
% external: contains the list of external nodes
% n: total number of nodes in this type of graph
% P: a path graph
% ********************

% the number of parent and children are equal in the path graph
% and is 1 less than the number of node
% the last node and end node are external nodes
parent = zeros(1,n-1);
children = zeros(1,n-1);
external = [1, n];
for i=1:n-1
    parent(i)=i;
    children(i)=i+1;
end

% construct the graph
P = graph(parent, children);

end
