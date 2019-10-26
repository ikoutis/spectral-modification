% function [cc] = energy_td(G, opts)
%
% energy-based tree decomposition
%
% input ********************
% G: weighted graph
%
%
% opts: optional arguments
%
% opts.ntrees: number of output trees (default 3)
%
% Algorithm Parameters:
% opts.df: discount factor in graph (default 1/2)
% ********************
%
% output ********************
% cc: cell array of trees



function [cc] = energy_td(G, opts)

n = height(G.Nodes);

try
  opts.df;
catch
  opts.df = 1/2;
end



try
  opts.ntrees;
catch
  opts.ntrees = 3;
end



%% create re-weighted graph, based on eigenvector
ev = graphEmbedding1(G, 1);

u = G.Edges.EndNodes(:,1);
v = G.Edges.EndNodes(:,2);
w = G.Edges.Weight;


new_w = (ev(u) - ev(v)).^2.*w+ 1e-011; % adding small quantity to avoid disconnected trees
G_rw = graph(u,v,new_w);

%%

cc = cell(1,opts.ntrees);

for i = 1: opts.ntrees



    T = maxspantree(G_rw);
    cc{i}.mst = inheritWeight(T,G);
    
    
    if i == opts.ntrees
        break
    end
    
    
    % re-weight by opts.df
    G_rw = rmedge(G_rw, T.Edges.EndNodes(:,1), T.Edges.EndNodes(:,2));
    T.Edges.Weight = T.Edges.Weight* opts.df;
    G_rw = addedge(G_rw, T.Edges.EndNodes(:,1), T.Edges.EndNodes(:,2), T.Edges.Weight);

end

end



function R = inheritWeight(T,G)
% input: T,G graphs
%
% output R: edges of T with weights from G 
% 


  T = adjacency(T,'weighted');
  G = adjacency(G,'weighted');
  

  n = length(T);
  [i,j] = find(T);
  R = sparse(i,j, ones(length(i),1), n,n);
  R = G.*R;   % entry-wise product
  
  R = graph(R);

end
