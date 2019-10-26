% function [modified_G] = modifyGraph(G, opts)

% input ********************
% G: weighted graph
% opts including the following options:
%   - m: graph decomposition algorithm
%       =2: Energy-Based Tree Decomposition  (default)
%       =3: Low-Stretch Tree Decomposition
%
%
%   - iter_num: number of iterations in tree decomposition, default = 3
%
%
% output ********************
% modified_G:  modified graph
% ********************


function [modified_G] = modifyGraph(G, opts)


% handling defaults
try opts.m;
catch opts.m = 2;
end

try opts.verbose;
catch opts.verbose = false;
end




if opts.m == 2
    if opts.verbose == true
        disp('Energy-Based Decomposition\n')
    end

    cc = energy_td(G, opts);
    mG = graphModifyByComponent(G, cc);
end



% if opts.m == 3
%     if opts.verbose == true
%         disp('Low-Stretch Tree Decomposition')
%     end
%     
%     
%     cc = lowStretch_td(G, opts);
%     mG = graphModifyByComponent(G, cc);
% 
% end




% Permute the nodes of G to get the original node id starting from node id 1
swA = adjacency(mG, 'weighted');
[m, ~] = size(swA);
[n, ~] = size(G.Nodes);
s_swA = permm(swA,0, [n+1:m 1:n]);

modified_G = graph(s_swA);

end


