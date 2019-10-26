function L = laplacianAdj(M, mtype, ltype)

% input *********
% M: A square matrix
% mtype: 
% 0:: adjacency matrix
% 1:: laplacian matrix
% ltype: type of laplacian matrix that needs calculating. Only applicable
% if mtyp = 0
% 0:: unnormalized L
% 1:: normalized L
% *****************

% output ***********
% L: laplacian matrix
% *****************

if mtype == 0
D = sum(M);
% unnormalized laplacian for ltype = 0
L = diag(D) - M;

if ltype == 1
    % normalized laplacian
    L = diag(D.^(-1/2))*L*diag(D.^(-1/2));
end

elseif mtype == 1
    D = diag(M);
    L = diag(D.^(-1/2))*M*diag(D.^(-1/2));
end

end