% function swT = modifyTree(T)
%
%
% T: adjacency of a tree
% swT: adjacency of the maximizer tree.
%      original nodes appear in coordinates 1:n  in swT (i.e. they keep their numbers)

function swT = modifyTree(T)

opts.direct = 3;
n = length(T);
d = zeros(n,1);
H = hierarchy(T,opts,d);

L = length(H);
n = length(H{1}.A);


%% give proper id's to all nodes
for j=1:L-1
    H{j}.cI = double(H{j}.cI+n+1);  %convert to double
    n = n+H{j}.nc;
end


%% bottom level
n = length(H{1}.A);
i(1:n,1) = [1:n]';
j(1:n,1) = H{1}.cI;
w(1:n,1) = diag(H{1}.A);

for k=2:L-1
    i = [i; [min(H{k-1}.cI):max(H{k-1}.cI)]' ];
    j = [j; H{k}.cI];
    w = [w; diag(H{k}.A)];
end

%% top node
i = [i; [min(H{end-1}.cI):max(H{end-1}.cI)]' ];
j = [j; (max(j)+1)*ones(length(i)-length(j),1)];
w = [w;diag(H{end}.A)];


%% construct swT

n = max(j);
swT = sparse(i,j,w, n,n);
swT = swT+swT';  %symmetrize
