function [NLL,g] = UGM_loss(w,data,nInstances,suffStat,nodeMap,edgeMap,edgeStruct)

%%set up
[nodePot,edgePot] = UGM_MRF_makePotentials(w,nodeMap,edgeMap,edgeStruct);
[nNodes,maxStates] = size(nodePot);
nEdges = edgeStruct.nEdges;
edgeEnds = edgeStruct.edgeEnds;
nStates = edgeStruct.nStates;

% Compute LogZi
tot_logZ_i = 0;
for e = 1:nEdges
    n1 = edgeEnds(e,1);
    n2 = edgeEnds(e,2);
    for s1 = 1:nStates(n1)       
        for s2 = 1:nStates(n2)
            w_ij = w(edgeMap(s1,s2,e));
            b_i = w(nodeMap(n1,s1));
            num_config = length(find(data(:,n1) == s1 & data(:,n2) == s2));
            tot_logZ_i = tot_logZ_i + num_config*exp(b_i+w_ij);
        end
    end
end

NLL = -w'*suffStat + tot_logZ_i;

end