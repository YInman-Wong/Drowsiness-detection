function [result,test_target,test_output] = pca_cascade(feature,fl,precision)
%% input
% - feature: 需要被降维，一列代表一条数据
% - fl:训练目标
% - precision:降维精度
%% output
% - accuracy:准确率
% - recall:召回率
% - presicious:精度
%% function
tic;
[coeff,score,latent] = pca(feature');%我们这里需要他的pc和latent值做分析
s = cumsum(latent)./sum(latent);
s = s(s<=precision); %精度取0.95
score = score(:,1:(length(s)+1));% score是降维旋转后矩阵

net = cascadeforwardnet([round(2*0.66*(length(s)+1)),round(2*0.34*(length(s)+1))],'trainlm');
net.divideParam.trainRatio=0.6;
net.divideParam.valRatio=0.2;
net.divideParam.testRatio=0.2;

[net,tr] = train(net,score',fl);
output = sim(net,score');
output = reclassify_3(output);

test_target = fl.* tr.testMask{1};
test_target(isnan(test_target)) = [];
test_output = output .* tr.testMask{1};
test_output(isnan(fl.* tr.testMask{1})) = [];

time = toc;
accuracy = sum(test_output == test_target)/length(test_target');
auc = roc(zero_one(test_output),zero_one(test_target));
accuracy = sum(test_output == test_target)/length(test_target');
for j = 1:3
    recall(1,j) = sum(test_output == j & test_target == j)/sum(test_target == j);
    presicious(1,j) = sum(test_output == j & test_target == j)/sum(test_output == j);
end
result = [accuracy recall presicious auc time];
histogram(result(:,1));

