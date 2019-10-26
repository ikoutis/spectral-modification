function [x] = matVecLinearOperator(v, M)


% input ********************
% v: vector
% M: graph Laplacian
% ********************
%
% output ********************
% 
% Let SC_M be the Schur complement of M with respect to the elimination
% of the first dim(M)-dim(v) nodes/coordinates of M. Then:
%
% SC_M *x = v
% ********************
    i = 1;
    % size of the short-wired tree
    [~,n] = size(M);
    [vr, ~] = size(v);
    v = orthogonalizeVec(v);
    
    % insert 0 to the head of v to give it the size of the short-wired tree
    x = [zeros(n-vr-i,1); v];
    x = M(i+1:n,i+1:n) \ x;
    x = x(n-vr-i+1:end);  
    x = orthogonalizeVec(x);

end

% orthogonalizing to the constant vector
function [v] = orthogonalizeVec(v)
    if sum(v) ~= 0
        cst = sum(v)/length(v);
        v = v - cst;
    end
end