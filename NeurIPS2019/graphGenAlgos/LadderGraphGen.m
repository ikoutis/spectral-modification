function [LG] = LadderGraphGen(k)

% input ********************
% k:the length of the cycles (=n/2)
% ********************

% output ********************
% A ladder graph where each edge for the inner and outer circle has weight
% 1 and each edge connecting node between two circles has weight 100/n^2.
% ********************

% reference ********************
% https://courses.cs.washington.edu/courses/cse521/16sp/521-lecture-12.pdf
% ********************

if (mod(k,2) ~= 0)
    disp('The number of node in either circle of the ladder graph must be even.Try again')
    return
end

[~, parent, children, ~, ~] = pathGraph(k) ;

% The second path circle
p2 = parent + k;
c2 = children + k;

% edge between nodes across two circles
% first close the path, then connect the edges and give them appropriate
% weights
LG = graph([parent parent(1) p2 p2(1) 1:k], [children children(end) c2 c2(end) k+1:2*k],...
    [ones(1,2*k) 100/(4*k*k)*ones(1,k)]);
plot(LG,'EdgeLabel',LG.Edges.Weight)

end