function [B,P] = permm(A, ptype, idp)
% input *************
% A: A square matrix A
% ptype: There are 3 modes:'reversed', 'random', 'followed'
% -1 :: 'reversed': The order of column indices will be automatically
% determined by reversing current indice order. E.g. [1 2 3] becomes [3 2
% 1]
% 1 :: 'random': The indices of existing columns will be shuffled randomly
% 0 :: 'followed': The exact order to which the matrix should be permuted
% according to
% ipd: order of column indices that need shuffling accordingly. 
% *********************

% output *************
% B: permuted version of matrix A
% P: permutation matrix giving B
% *********************

% Reference **********
% https://www.mathworks.com/matlabcentral/fileexchange/25148-permute-a-matrix
% PERMM Permutates a matrix A by given indexes by computing B = P'*A*P
% 
% B     = permm(A,idp)
% [B,P] = permm(A,idp)
% 
% The function applies simultaneous column and row permutation, that is by
% given indexes idp = [k j m ...] the function rearranges the elements of A
% so that B11=Akk, B12=Akj, ...  B21 = Ajk, B22=Ajj, ...
% 
% Example
% A   = [11 12 13;
%        21 22 23;
%        31 32 33]      % initial matrix
% idp = [2 3 1]         % order of rearrangement
% B = permm(A, idp);    % rearranged matrix
% Andrey Popov      andrey.popov @ gmx.net                      29.10.2009
% Copyright (c) 2009, Andrey Popov
% All rights reserved.

% Check inputs
if nargin < 2
    error('permm:nargin','permm requires two inputs');
end
[n,m]    = size(A);
if n ~= m
    error('permm:A','The matrix to be permuted should be a square matrix');
end

if ptype == 0
    if n ~= length(idp)
        error('permm:idp','The index vector idp should have as many elements as the size of A');
    end
    sidp = sort(idp(:))';
    if any((1:n) - sidp)
        error('permm:sidp','For a n x n matrix A, the index vector idp should contain the numbers\n1:n in the desired permutation order');
    end
end

if ptype == -1
    a = 1:n;
    idp = flip(a);
end

if ptype == 1
    idp = randperm(n);
end
% if indices not to be provided

% Perform permutation
P = speye(n);
P = P(:,idp);
B = P'*A*P;
end