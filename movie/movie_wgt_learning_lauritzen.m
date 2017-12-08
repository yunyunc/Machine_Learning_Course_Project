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
edgeStruct = UGM_makeEdgeStruct(adj,nStates,0,100);
maxState = max(nStates);
nEdges = edgeStruct.nEdges;
edgeEnds = edgeStruct.edgeEnds;

%%Make nodePot
nodePot = zeros(n_nodes,maxState);
for n = 1:n_nodes
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
            edgePot(s1,s2,e) = length(find(data(:,n1) == s1 & data(:,n2) == s2)) / n_instances;
        end
    end
end
