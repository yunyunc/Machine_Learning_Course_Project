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
nodeMap = zeros(n_nodes,maxState,'int32');


