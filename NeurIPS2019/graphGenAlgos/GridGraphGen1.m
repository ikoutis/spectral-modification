function G = GridGraphGen1(m, n, type)

% input *********
% m: size 1
% n: size 2
% type: ::0: unweighted, ::1: weighted
% *****************

% output ***********
% G: A grid graph of size m x n with random weight between 1, 2 if type = 1
% *****************

% discussion ***********  
% A grid graph G_(m,n) has mn nodes and (m-1)n+(n-1)m=2mn-m-n edges
% *****************

edge_total = 2*m*n - m - n;
row = zeros(1, edge_total);
col = zeros(1, edge_total);


pointer = 1; % a pointer to track where the insertion will happen
p2 = 1; % a pointer that move along the pre-defined array
while p2 <= edge_total - n + 1 % excluding the last row which only need one edge specification per node. 
    % check if this element is of the last column
    if mod(pointer,n) == 0
        row(p2) = pointer;
        col(p2) = pointer + n;
        p2 = p2 + 1;
        pointer = pointer + 1;
        continue
    end
    row(p2) = pointer;
    col(p2) = pointer + 1;
    p2 = p2 + 1;
    row(p2) = pointer;
    col(p2) = pointer + n;
    p2 = p2 + 1;
    pointer = pointer + 1;

end

% fill in the edges in the last row
for i = p2 : edge_total  % last node does not need edge specification
    row(p2) = pointer;
    col(p2) = pointer + 1;
    pointer = pointer + 1;
    p2 = p2 + 1;
end

w = ones(1, edge_total);
if type == 1
    w = randi(2, 1, edge_total);
end

G = graph(row, col, w);


end