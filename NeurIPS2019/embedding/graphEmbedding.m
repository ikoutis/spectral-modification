% function [embedding] = graphEmbedding1(G, dim, H, Bfun)
%
% input
%
% G: weighted graph
% dim: Embedding dimension
% H: weighted graph  (modified graph, optional)
%
% Bfun: optional function implementing matrix-vector with graph Laplacian B
%     : if given then embedding comes from generalized eigenvalue problem
%     : with B in the place of the standard diagonal D
%     
%
% Note: if size of G is <1500 then dense solvers are employed
%
%
% ********************
%
% output ********************
%
% embedding:  n x dim matrix. Row i is embedding of node i into R^{dim}
%
% ********************
%
% future addition: external B/Bfun

function [embedding] = graphEmbedding1(G, dim, H, Bfun)


  A = laplacian_cmg( adjacency(G,'weighted') );
  d = diag(A);                          % graph degrees
  
  if nargin<4
        Bfun = @(x)  d.*x - d*(d'*x)/sum(d);  % standard denominator K
  end
  n = length(A);
  
  %% small/dense case first
  if n<1500
      D = sparse([1:n],[1:n],d, n, n);
      A = full(A);
      B = D - d*d'/sum(d);
      
      [V, E] = eig(pinv(A)*B);
      
      [~, ndx] = sort(real(diag(E)));   %eigenvalues are real. ignore numerical imaginary part.
      V = V(:,ndx);                     %rearrange eigenvectors
      
      embedding = ProjectionStep(V(:,end-dim+1:end), d, Bfun);  %process embedding
      return
  end
  
  %% sparse without modified graph
  
  if (nargin == 2)
      
      pfun = cmg_sdd(A);
      Y = rand(n,dim);
      
      [V,lambda,failureFlag]=lobpcg(Y, A ,@(x)col_pfun(x,Bfun), @(x)col_pfun(x,pfun), 1e-5,50,0);
      embedding = ProjectionStep(V, d, Bfun);
      return
     
  end
  
  %% sparse with modified graph as input
  %
  % Important: This assumes that modified graph H is ordered with n last nodes
  % in 1-1 correspondence with G nodes
  if (nargin >= 3)
      
      M = laplacian_cmg(adjacency(H,'weighted'));
      
      pfun = cmg_sdd(M);                      % preconditioner for M
      Mfun = @(b) pcg(M, b, 1e-05,50, pfun);  % solve with M   (higher dimension)
      
      % solve with Schur complement of M with respect to extra nodes
      scMfun = @(v) matVecLinearOperator_fast(v, M, Mfun);
      sfun = @(x)col_pfun(x,scMfun);          % apply on columns
  
      [V,~] = eigs( @(x) sfun(Bfun(x)), n, dim );
      embedding = ProjectionStep(V, d, Bfun);
  
  end

end


function EIGVECTS = ProjectionStep(EIGVECTS, degsG, Bfun)

n = length(EIGVECTS);

for i = 1:size(EIGVECTS,2)
    c = - dot(degsG,EIGVECTS(:,i)) / dot(degsG,ones(n,1) );
    EIGVECTS(:,i) = EIGVECTS(:,i) + c * ones(n,1);
    EIGVECTS(:,i) = EIGVECTS(:,i) / sqrt( EIGVECTS(:,i)' * Bfun( EIGVECTS(:,i) ) );
end

if size(EIGVECTS,2)>1
    for i=1:n
        EIGVECTS(i,:) = EIGVECTS(i,:) / norm(EIGVECTS(i,:),2);
    end
end

end