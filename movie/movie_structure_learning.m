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
data = zeros(length(FrameStack),24);
for i=1:length(FrameStack)
    data(i,:) = FrameStack{i};
end
clear FrameStack
nInstances = length(data);
n_nodes = 24;

%%Make edgeStruct
nStates = max(data);
adj = ones(n_nodes);
adj = adj+diag(-1*ones(1,n_nodes));
edgeStruct = UGM_makeEdgeStruct(adj,nStates,0,100); %no mex
maxState = max(nStates);
nEdges = edgeStruct.nEdges;

%%Training
ising = 0; % Use full potentials
tied = 0; % Each node/edge has its own parameters
[nodeMap,edgeMap] = UGM_makeMRFmaps(n_nodes,edgeStruct,ising,tied);
nParams = max([nodeMap(:);edgeMap(:)])
w = zeros(nParams,1);

% Make Edge Regularizer
lambda = 5;
nNodeParams = max(nodeMap(:));
nParams = max(edgeMap(:));
nEdgeParams = nParams-nNodeParams;
regularizer = [zeros(nNodeParams,1);lambda*ones(nEdgeParams,1)];

% Inference Method
inferFunc = @UGM_Infer_MeanField;

% Train
suffStat = UGM_MRF_computeSuffStat(data,nodeMap,edgeMap,edgeStruct);
funObj = @(w)UGM_MRF_NLL(w,nInstances,suffStat,nodeMap,edgeMap,edgeStruct,inferFunc);
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

% Display Graph (requires graphviz)
figure;
drawGraph(adjFinal);
title('Estimated Structure');
pause