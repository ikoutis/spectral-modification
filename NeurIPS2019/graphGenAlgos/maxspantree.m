function mst = maxspantree(T)
    
% input ********************
% @T: A tree, undirected graph.
% ********************

% output ********************
% @mst: maximum spanning tree
% ********************
% 

    % T is a weighted graph
    % Flip the weight of T
    try
        T.Edges.Weight(1);
    catch
        T.Edges.Weight = ones(height(T.Edges),1);
    end
    
    
    T.Edges.Weight = -1 * T.Edges.Weight;
    mst = minspantree(T, 'Method', 'Sparse', 'Type', 'forest'); % Use Kruskal's algorithm https://www.mathworks.com/help/matlab/ref/graph.minspantree.html
    % Flip the weight of MST back to original weight
    mst.Edges.Weight = -1 * mst.Edges.Weight;
end