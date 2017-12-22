% clear all
% close all

cd UGM
addpath(genpath(pwd))
cd ..

%%Load data
load tr_data.mat
data = zeros(length(FrameStack),57);
for i=1:length(FrameStack)
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

%%Load adj from memory
load learned_ugm_2000_trlns.mat
adj = adjFinal;

%%Make edgeStruct
nStates = max(data);
edgeStruct = UGM_makeEdgeStruct(adj,nStates,0,100); %no mex
maxState = max(nStates);
nEdges = edgeStruct.nEdges;

%%Training
ising = 1; % Use ising 
tied = 0; % Each node/edge has its own parameters
[nodeMap,edgeMap] = UGM_makeMRFmaps(n_nodes,edgeStruct,ising,tied);
nParams = max([nodeMap(:);edgeMap(:)])
w = zeros(nParams,1);

% Compute sufficient statistics
suffStat = UGM_MRF_computeSuffStat(data,nodeMap,edgeMap,edgeStruct);

% Evaluate NLL
inferFunc = @UGM_Infer_MeanField;
nll = UGM_MRF_NLL(w,nInstances,suffStat,nodeMap,edgeMap,edgeStruct,inferFunc)

% Optimize
w = minFunc(@UGM_MRF_NLL,w,[],nInstances,suffStat,nodeMap,edgeMap,edgeStruct,inferFunc);

[nodePot,edgePot] = UGM_MRF_makePotentials(w,nodeMap,edgeMap,edgeStruct);

% adjFinal = zeros(n_nodes,n_nodes);
% for e = 1:edgeStruct.nEdges
%     params = edgeMap(:,:,e);
%     params = params(params(:)~=0);
% %     if any(w(params(:)) ~= 0)
%         n1 = edgeStruct.edgeEnds(e,1);
%         n2 = edgeStruct.edgeEnds(e,2);
%         temp = w(params(:));
%         adjFinal(n1,n2) = temp(1);
%         adjFinal(n2,n1) = temp(1);
% %     end
% end