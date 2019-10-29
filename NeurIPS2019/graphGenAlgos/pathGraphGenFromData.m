function [P] = pathGraphGenFromData(ev, node_idx) 
% input ********************
% ev: the values corresponding to the node of the to be genereated path
% graph
% node_idx: the nodes of the path graph
% ********************

% output ********************
% P: a path graph whose edge is the absolute value of the difference
% between two node values.
% ********************

[n, ~]  = size(node_idx);

parent = zeros(1,n-1);
children = zeros(1,n-1);


for i=1:n-1
    parent(i)=node_idx(i);
    children(i)=node_idx(i+1);
    w = abs(ev(i+1) - ev(i));
end

% construct the graph
P = graph(parent, children, w);

end
