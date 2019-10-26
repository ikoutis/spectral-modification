function DoubleBinaryTree = DoubleBinaryTreeGen(l, type)

% input ********************
% type: ::0: unweighted, ::1: random weight either 1 or 2
% k: height of one side of the binary tree. Must be >= 4 to follow Miller
% et. al. to see poor estimation of spectral clustering. https://www.cs.cmu.edu/~glmiller/Publications/GuatteryMiller98.pdf
% ********************

[cp_1_2] = lengthForPath(l) ;
% construct path graph
[P, ~, ~, ~, ~] = pathGraph(cp_1_2);
% construct binary tree
[DBT, ~, ~, ~, ~] = doubleBinaryTree(l);
% path graph x binary tree = Gprod
[DoubleBinaryTree] = graphProduct(P, DBT);

edge_num = height(DoubleBinaryTree.Edges);
if type == 0
    DoubleBinaryTree.Edges.Weight = ones(edge_num,1);
else
    DoubleBinaryTree.Edges.Weight = randi(2, 1, edge_num)';
end

end