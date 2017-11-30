clear all
close all

cd UGM
addpath(genpath(pwd))
cd ..

%%load data
load data.mat
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

% Make nodeMap
% nodeMap = zeros(n_nodes,maxState,'int32');
% num_wgts = 0;
% for i=1:n_nodes
%     num_states = nStates(i);
%     for j=1:num_states
%         nodeMap(i,j) = num_wgts+j;
%     end
%     num_wgts = num_wgts + num_states;
% end
% 
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


