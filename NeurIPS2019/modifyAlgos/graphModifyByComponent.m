%function G_modified = graphModifyByComponent(G, cc)
%
% Construct modified graph from tree decomposition
%
% input ***********
% @G: a simple graph
% @cc: connected component: All graphs as tree generated from a pre-defined
% method
% ******************
%
% output ***********
% @modified_G: The spectral modified graph of G
% ******************

function G_modified = graphModifyByComponent(G, cc)


% current highest node id
[n, ~] = size(G.Nodes);

% current increase step
rise_step = 0;

sw_cc = cell(1, length(cc));

G_modified = G;

for i = 1: length(cc)
    % mta: modified tree adjacency
    
    sw_cc{i}.mta = modifyTree(adjacency(cc{i}.mst, 'weighted'));
    [k,j,v] = find(sw_cc{i}.mta); % extract sw_cc info

    % current highest node id
    [mi, ~] = size(sw_cc{i}.mta);

    % increase i from current available internal id
    k(k>n) = k(k>n) + rise_step;
    j(j>n) = j(j>n) + rise_step;

    G_modified = addedge(G_modified,k,j,v);
    rise_step = rise_step + mi - n-1;
end

G_modified = simplify(G_modified);

end
