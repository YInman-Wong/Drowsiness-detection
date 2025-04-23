function [result,predicted_label,Ttest,test_number] = defaultsvm_individual(number,P,T,train_ratio)
%% 
% 输入
% -P：需要进行SVM分类的矩阵（一行为一条数据，归一化时注意一下mapminmax是对每行归一化）
% -T: 原矩阵的标签（一行为一条数据）
% -test_ratio: 测试集占比
% 输出
% -accuracy,recall,presicious,time： 准确率，召回率，精度，训练时间
% -Ttest: 训练集的标签
% - predicted_label: svm对测试集的输出
%%
test_ratio = 1-train_ratio;
%% features
tic % timing
[Xtraining,Ttraining,Xtest,Ttest,test_number] = subset_individual(number,P,T,test_ratio);
model = svmtrain(Ttraining,Xtraining);%,cmd
time = toc; % end timing
[predicted_label, accuracy, decision_values] = svmpredict(Ttest, Xtest, model);
%% rd and pd
j = 1;
while j <= 3
    recall(1,j) = sum(predicted_label == j & Ttest == j)/sum(Ttest == j);
    presicious(1,j) = sum(predicted_label == j & Ttest == j)/sum(predicted_label == j);
    j = j + 1;
end
result = [0.01*accuracy(1,1) recall presicious time];