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

%%Make nodePot
nodePot = zeros(nNodes,maxState);
for n = 1:nNodes
    for s = 1:nStates(n)
        nodePot(n,s) = length(find(data(:,n) == s)) / n_instances;
    end
end

%%Make edgePot
edgePot = zeros(maxState,maxState,nEdges);
for e = 1:nEdges
    n1 = edgeEnds(e,1);
    n2 = edgeEnds(e,2);
    for s1 = 1:nStates(n1)
        for s2 = 1:nStates(n2)
            
        end
    end
end
