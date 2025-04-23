function [result,test_target,test_output,number] = feed(num,P,T,train_ratio)
tic;
net = feedforwardnet([round(1.4*size(P,1)),round(0.6*size(P,1))],'trainlm');
net.divideParam.trainRatio=train_ratio;
net.divideParam.valRatio=(1-train_ratio)/2;
net.divideParam.testRatio=(1-train_ratio)/2;

[net,tr] = train(net,P,T);
output = sim(net,P);
output = reclassify_3(output);

test_target = T.* tr.testMask{1};
test_target(isnan(test_target)) = [];
test_output = output .* tr.testMask{1};
test_output(isnan(T.* tr.testMask{1})) = [];
number = num .* tr.testMask{1};
number(isnan(T.* tr.testMask{1})) = [];

time = toc;
accuracy = sum(test_output == test_target)/length(test_target');
% auc = roc(zero_one(test_output),zero_one(test_target));
for j = 1:3
    recall(1,j) = sum(test_output == j & test_target == j)/sum(test_target == j);
    presicious(1,j) = sum(test_output == j & test_target == j)/sum(test_output == j);
end
result = [accuracy recall presicious time]; % auc 