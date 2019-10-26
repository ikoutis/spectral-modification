function [ EIGVECTS, EIGVECTS_raw, lambda, failureFlag ] = baseline_SpectralEmbedding( G, dim)

%% Requires the solver from    http://www.cs.cmu.edu/~jkoutis/cmg.html
%  Download it and follow the instructions in the ReadtMe.txt file
%  (to install it, run the command:     MakeCMG.m   )

%% Input:
% G: sacency matrix of weighted graph
% dim: dimesion of the embedding


%% Output: 
% EIGVECTS      = geometric embedding with radial projection
% EIGVECTS_raw  = geometric embedding without radial projection

% Note that the the cmg solver may fail if the matrices are too dense.



%% Build the two graph Laplacians
G = sparse(G);
n = length(G);
d = sum(G)'; 
sd = sum(d);

if not( sum(abs(diag(G))) == 0)
    disp('Matrix diagonal must be zero'); 
    return;
end

[~, bsizes] = conncomp(graph(G)); 
if (length(bsizes)>1)
    disp('Graph must be connected');
end

L = diag(d)-G;

Bfun = @(x) (d.*x -   d*(d'*x)/sd);  % this implements a complete Laplacian


%% Solve generalized eigenproblem using the fast Laplacian solver

[ EIGVECTS_raw, lambda, failureFlag ] = InversePowerMethod(L, Bfun, dim);

lambda = diag(lambda);

%% Compute projection step
EIGVECTS_raw = ProjectionStep(EIGVECTS_raw, d, Bfun);   % input('fixEIGS');

%% Compute radial projection step
EIGVECTS = RadialProjectionStep(EIGVECTS_raw); 

end


function EIGVECTS = RadialProjectionStep(EIGVECTS)
n = length(EIGVECTS);
for i=1:n
    EIGVECTS(i,:) = EIGVECTS(i,:) / norm(EIGVECTS(i,:),2);
end
end


function EIGVECTS = ProjectionStep(EIGVECTS, d, Bfun)

n = length(EIGVECTS);

for i = 1:size(EIGVECTS,2)
    c = - dot(d,EIGVECTS(:,i)) / dot(d,ones(n,1) );
    EIGVECTS(:,i) = EIGVECTS(:,i) + c * ones(n,1);
    EIGVECTS(:,i) = EIGVECTS(:,i) / sqrt( EIGVECTS(:,i)' * Bfun( EIGVECTS(:,i) ));
end


end



function [ EIGS, lambda, failureFlag ] = InversePowerMethod(L,Bfun, k)


%  [blockVectorX,lambda,failureFlag,lambdaHistory,residualNormsHistory]=...
%   lobpcg(blockVectorX,'operatorA','operatorB','operatorT',blockVectorY,...
%   residualTolerance,maxIterations,verbosityLevel);
%
%   computes smallest eigenvalues lambda and corresponding eigenvectors
%   blockVectorX of the generalized eigenproblem Ax=lambda Bx, where
%   Hermitian operators operatorA and operatorB are given as functions, as
%   well as a preconditioner, operatorT. The operators operatorB and
%   operatorT must be in addition POSITIVE DEFINITE.

residualTolerance = 1e-5;
maxIterations = 50;
verbosityLevel = 0;

pfun = cmg_sdd(L);
n = length(L);

[EIGS,lambda,failureFlag]=lobpcg(randn(n,k),L,@(x)col_pfun(x,Bfun),@(x)col_pfun(x,pfun),residualTolerance,maxIterations,verbosityLevel);


end


function M = col_pfun( A, pfun )

[n, m] = size(A);
for k=1:m
    M(:,k) = pfun(A(:,k)); 
    M(:,k) = M(:,k)-sum(M(:,k))/n;
end

end





