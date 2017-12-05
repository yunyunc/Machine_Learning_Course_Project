clear all
close all

cd UGM
addpath(genpath(pwd))
cd ..

%%load data
load tr_data.mat
data = zeros(length(FrameStack),24);
for i=1:length(FrameStack)
    data(i,:) = FrameStack{i};
end
clear FrameStack
n_instances = length(data);
n_nodes = 24;

%%Make edgeStruct
nStates = max(data);
adj = zeros(n_nodes);
for i=1:n_nodes-1
    adj(i,n_nodes) = 1;
end
adj = adj+adj';
edgeStruct = UGM_makeEdgeStruct(adj,nStates,0,100); %no mex
maxState = max(nStates);
nEdges = edgeStruct.nEdges;

%%Training
ising = 0; % Use full potentials
tied = 0; % Each node/edge has its own parameters
[nodeMap,edgeMap] = UGM_makeMRFmaps(n_nodes,edgeStruct,ising,tied);
nParams = max([nodeMap(:);edgeMap(:)])
w = zeros(nParams,1);

% Compute sufficient statistics
suffStat = UGM_MRF_computeSuffStat(data,nodeMap,edgeMap,edgeStruct);

% Evaluate NLL
nll = UGM_MRF_NLL(w,n_instances,suffStat,nodeMap,edgeMap,edgeStruct,@UGM_Infer_Tree)

% Optimize
w = minFunc(@UGM_MRF_NLL,w,[],n_instances,suffStat,nodeMap,edgeMap,edgeStruct,@UGM_Infer_Tree);


