% generate a double binary tree
G = DoubleBinaryTreeGen(7,0); % unweighted graph

% these are the default values
opts.m = 2;
opts.ntrees = 3;

% modify G
modified_G = modifyGraph(G, opts);

% perform graph embedding
embedding = graphEmbedding(G, 1, modified_G);

% classification into 2 classes
clus_vec = classification(embedding, 2, G);

% visualize classification result
fig_num = visualization(G, clus_vec, 1, 2);

