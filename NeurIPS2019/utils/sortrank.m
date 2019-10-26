function [p, c]= sortrank(o_id, o_rank)
% this function sort id based on rank and yields pairs of end vertices of
% edges in a tree
% the primary goal is to look up the weight of the segment and identify the
% top and bottom of the segment

% sample data . command line: [p,c] = sortrank([], [])
if isempty(o_id)
    o_id = [9 10 13 14];
    o_rank = [3 4 6 5];
%     o_id = [15,14,10, 9, 5];
%     o_rank = [ 7, 6, 6, 5, 7];
%     o_id = [6 2 1];
%     o_rank = [2 2 1];
end

length_id = length(o_id);

% declare p. The number of edge should be 1 less than the number of node in
% a tree
p = zeros(1, length_id -1);
c = zeros(1, length_id -1);

[~, idx] = sort(o_rank);

% rearrange based on new sorting order
id = zeros(1, length_id -1);

for i = 1: length_id
    id(i) = o_id(idx(i));
end

anker_rank = id(idx(1));

for i = 2: length_id
    % when there is no tie in the sorted rank
    if o_rank(idx(i)) > o_rank(idx(i-1))
        c(i-1) = id(i);
        p(i-1) = id(i-1);
        % keep the parent that will connect in case of tie
        anker_rank = id(i-1);
    elseif o_rank(idx(i)) == o_rank(idx(i-1))
    % there is an equivalent in rank, step backward to the anker rank
        p(i-1) = anker_rank;
        c(i-1) = id(i);
    end
        
end


end