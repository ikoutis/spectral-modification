function [cc] = treeDecomposition_RemoveOrIncrease(G, opts)
% input ********************
% G: Weighted Graph
%
% opts: optional arguments--
%
% opts.iter_num  number of trees in the output, default = 3
% opts.prob_keep:  scalar (0,1), default =  0.5
% opts.rand_tree: the type of randomness for the maximum spanning tree to
% ge benerated
%
% output ********************
% cc: cell array
%
% cc{i}.mst: Spanning tree of G at iteration i
%
% Off-tree edges in G are kept with probability opts.prob_keep
% and their weights are multiplied by 1/opts.prob_keep
% ********************

% audit log: What changed compared to previous version
% adding the check to see if the tree generated is different from the tree
% generated before. If not, break out early

try 
    opts.iter_num;
catch
    opts.iter_num = 3;
end

try 
    opts.prob_keep ;
catch
    opts.prob_keep =0.5 ;
end

cc = cell(1,opts.iter_num);


for i=1:opts.iter_num
  
  T = randish_maxspantree(G);
  cc{i}.mst = T;

  G = rmedge(G, T.Edges.EndNodes(:,1), T.Edges.EndNodes(:,2));
  adj_G = adjacency(G, 'weighted');


  % Off-tree edges are subject to either be removed or double in weight
  Gu = G.Edges.EndNodes(:,1)';
  Gv = G.Edges.EndNodes(:,2)';
  Gw = G.Edges.Weight;
  
  % break if there is no edge left
  len = length(Gu);
  
  ndx = find(rand(len,1)<opts.prob_keep);
  T = addedge(T, Gu(ndx), Gv(ndx), Gw(ndx)/opts.prob_keep);
  T = simplify(T);
  G = T;
  
  if len == 0
     break;
  end
  
  end_at = i;

end

cc = cc(1:end_at);

end
