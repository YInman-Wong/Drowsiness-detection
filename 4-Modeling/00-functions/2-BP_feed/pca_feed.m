function [result,test_target,test_output] = pca_feed(feature,fl,precisious)
tic;
[pc,score,latent] = pca(feature');%我们这里需要他的pc和latent值做分析
s = cumsum(latent)./sum(latent);
s = s(s < precisious); %精度取0.9
score = score(:,1:(length(s)+1));

net = feedforwardnet([round(2*0.66*(length(s)+1)),round(2*0.34*(length(s)+1))],'trainlm');
net.divideParam.trainRatio=0.6;
net.divideParam.valRatio=0.2;
net.divideParam.testRatio=0.2;

[net,tr] = train(net,score',fl);
output = sim(net,score');
%%
output = reclassify_2(output);
%%
test_target = fl.* tr.testMask{1};
test_target(isnan(test_target)) = [];
test_output = output .* tr.testMask{1};
test_output(isnan(fl.* tr.testMask{1})) = [];
time = toc;
accuracy = sum(test_output == test_target)/length(test_target');
auc = roc(zero_one(test_output),zero_one(test_target));
for j = 1:2
    recall(1,j) = sum(test_output == j & test_target == j)/sum(test_target == j);
    presicious(1,j) = sum(test_output == j & test_target == j)/sum(test_output == j);
end
result = [accuracy recall presicious auc time];