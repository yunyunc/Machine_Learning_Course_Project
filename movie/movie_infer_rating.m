%%load data
load te_data.mat
data = zeros(length(FrameStack),24);
for i=1:length(FrameStack)
    data(i,:) = FrameStack{i};
end
clear FrameStack

%%testing
[n_instances, query_var] = size(data);
err = 0;
for i=1:n_instances
    clamped = data(i,:);
    clamped(query_var) = 0;
    [nodeBel,edgeBel,logZ] = UGM_Infer_Conditional(nodePot,edgePot,edgeStruct,clamped,@UGM_Infer_Exact);
    [prob, pred] = max(nodeBel(query_var,:));
    if pred ~= data(i,query_var)
        err = err+1;
    end
end
