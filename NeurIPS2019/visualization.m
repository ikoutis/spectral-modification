function fig_num = visualization(G, clus_vec, type, fig_num)

% input **********
% G: Graph
%
% clus_vec: The vector that indicates the clusters of the graph
%
% type: ::0: original graph, ::1: spectral-modified graph for graphic
% saving purpose only fig_num: The figure number to plot finding
% ***************

[n, ~] = size(G.Nodes);

h = figure(fig_num);

if n< 100
    j = plot(G, 'EdgeLabel', G.Edges.Weight);
else
    j = plot(G);
end

if type == 0
    t = 'o';
else
    t = 'mod';
end

%fprintf('\nPloting based on the %s eigenvectors. Save files under results\\illus_%s.png name ', t)
    
avail_color = ['r','b','c','y','g','m','k'];
u = unique(clus_vec);

for i = 1: length(u)
    highlight(j, clus_vec == u(i), 'NodeColor', avail_color(i));
    highlight(j, 1:n, 'MarkerSize',6, 'NodeFontSize',10);
end

savefig(h,".\results\illus_"+t+".fig");

fig_num = fig_num + 1;
end

