function A = LaplacianToAdjancency(L)

A = L - diag(diag(L));
A = A * -1;

end