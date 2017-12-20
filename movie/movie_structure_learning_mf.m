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

%%Make full adj
nStates = max(data);
adj = ones(n_nodes);
adj = adj+diag(-1*ones(1,n_nodes));

%%Make edgeStruct
edgeStruct = UGM_makeEdgeStruct(adj,nStates,0,100); %no mex
maxState = max(nStates);
nEdges = edgeStruct.nEdges;

%%Training
ising = 1; % Use full potentials
tied = 0; % Each node/edge has its own parameters
[nodeMap,edgeMap] = UGM_makeMRFmaps(n_nodes,edgeStruct,ising,tied);
nParams = max([nodeMap(:);edgeMap(:)]);

%%Make Potentials
w = zeros(nParams,1);
[nodePot,edgePot] = UGM_MRF_makePotentials(w,nodeMap,edgeMap,edgeStruct);

% Make Edge Regularizer
lambda = 10;
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
    if sum(w(params(:)) > 1e-2)
%     if any(w(params(:)) > 1e-3)
        n1 = edgeStruct.edgeEnds(e,1);
        n2 = edgeStruct.edgeEnds(e,2);
        adjFinal(n1,n2) = 1;
        adjFinal(n2,n1) = 1;
    end
end
density = length(find(adjFinal == 0)) / (57*57)

%%plotting
node_names = {'age<=15','15<age<=25','25<age<=36','36<age<=57','58<age','gender','administrator','artist', 'doctor', 'educator', 'engineer', 'entertainment', 'executive', 'healthcare', 'homemaker','lawyer','librarian','marketing','none','other','programmer','retired','salesman','scientist','student', 'technician','writer','year>=1997','year=1996','year=1995','year=1994','year=1993','1982<=year<1993','1971<=year<1982','1960<=year<1971','1940<=year<1960','year<=1939','unknown','action','advanture','animation','children','comedy','crime','documentary','drama','fantasy','film-noir','horror','musical','mystery','romance','sci-fi','thriller','war','western','rating'};
G = graph(adjFinal,node_names);
plot(G)
