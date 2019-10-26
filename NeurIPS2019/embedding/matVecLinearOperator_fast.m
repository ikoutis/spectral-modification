function [x] = matVecLinearOperator_fast(v, M, sfun)

% input ********************
% v: vector
% M: graph Laplacian
% sfun: approximate inverse (solver function) for M
%
% 
% ********************

% output ********************
% 
% Let SC_M be the Schur complement of M with respect to the elimination
% of the first dim(M)-dim(v) nodes/coordinates of M. Then:
%
% SC_M *x = v
% ********************
    i = 0;
    % size of modified graph
    [~,n] = size(M);
    [vr, ~] = size(v);
    v = orthogonalizeVec(v);
    
    % insert 0 to the head of v to give it the size of the modified graph
    x = [zeros(n-vr-i,1); v];
    x = sfun(x);
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