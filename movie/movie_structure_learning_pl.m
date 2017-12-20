clear all
close all

cd UGM
addpath(genpath(pwd))
cd ..

cd L1General
addpath(genpath(pwd))
cd ..

%%load data
load tr_data.mat
data = zeros(length(FrameStack)/80,57);
for i=1:length(FrameStack)/80
    data_i = FrameStack{i};
    age_one_hot = ones(1,5);
    age_one_hot(data_i(1)) = 2;
    occ_one_hot = ones(1,21);
    occ_one_hot(data_i(3)) = 2;
    year_one_hot = ones(1,10);
    year_one_hot(data_i(4)) = 2;
    data(i,:) = [age_one_hot data_i(2) occ_one_hot year_one_hot data_i(5:23) data_i(25)]; %ignore movie id for now
end
clear FrameStack
[nInstances, n_nodes] = size(data);
y = data;

%%Make full adj
nStates = max(data);
adj = ones(n_nodes);
adj = adj+diag(-1*ones(1,n_nodes));

%%Make edgeStruct
edgeStruct = UGM_makeEdgeStruct(adj,nStates,0,100); %no mex
maxState = max(nStates);
nEdges = edgeStruct.nEdges;

%%Training
ising = 1;
tied = 0; % Each node/edge has 1 parameter (ising)
[nodeMap,edgeMap] = UGM_makeMRFmaps(n_nodes,edgeStruct,ising,tied);
nParams = max([nodeMap(:);edgeMap(:)]);

%%%Make W
w = zeros(nParams,1);

%%Make Potentials
[nodePot,edgePot] = UGM_MRF_makePotentials(w,nodeMap,edgeMap,edgeStruct);

%Make Edge Regularizer
lambda = 5;
nNodeParams = max(nodeMap(:));
nParams = max(edgeMap(:));
nEdgeParams = nParams-nNodeParams;
regularizer = [zeros(nNodeParams,1);lambda*ones(nEdgeParams,1)];

%Make XNode & Xedge
Xnode = [ones(nInstances,1,n_nodes)];
Xedge = [ones(nInstances,1,nEdges)];

%% Train
funObj = @(w)UGM_CRF_PseudoNLL(w,Xnode,Xedge,y,nodeMap,edgeMap,edgeStruct);
w = L1General2_PSSgb(funObj,w,regularizer);

% Find Active Edges
adjFinal = zeros(n_nodes);
for e = 1:edgeStruct.nEdges
    params = edgeMap(:,:,e);
    params = params(params(:)~=0);
    if any(w(params(:)) ~= 0)
        n1 = edgeStruct.edgeEnds(e,1);
        n2 = edgeStruct.edgeEnds(e,2);
        adjFinal(n1,n2) = 1;
        adjFinal(n2,n1) = 1;
    end
end
density = length(find(adjFinal == 0)) / (57*57)