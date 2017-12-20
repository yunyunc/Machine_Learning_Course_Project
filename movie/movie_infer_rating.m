%%load data
load te_data.mat
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
% data = zeros(length(FrameStack),24); %for model 1
% for i=1:length(FrameStack)
%     temp = FrameStack{i};
%     data(i,:) = [temp(1:23) temp(25)];
% end
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
err = (n_instances-err)/n_instances;