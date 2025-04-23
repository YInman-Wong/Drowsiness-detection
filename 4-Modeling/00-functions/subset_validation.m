function [Xtraining,Ttraining,Xtest,Ttest,num] = subset_validation(number,X,T,test_ratio)
%% explaination
% 该函数把原始数据集（一行为一条数据）划分为训练集和测试集（一行为一条数据）
% ======= input ========
% -X: 原始数据集，一行为一条数据
% -T：原始标签，一行为一条数据
% -test_ratio: 测试集占比
% -k: 交叉验证折数

% ======= output =======
% -Xtraining,Ttraining: 训练集和训练集标签（一行为一条数据）
% -Xtest,Ttest：测试集和测试集标签（一行为一条数据）
% -num: 测试集被试编号
%% function
ndata = size(X,1);        % ndata样本数(行)，D维数（列）
num_test = round(test_ratio * ndata);
if num_test > test_ratio * ndata
    num_test = num_test - 1;
end
R = randperm(ndata);         % 1到ndata这些数随机打乱得到的一个随机数字序列作为索引
for i = 1:1/test_ratio
    D{i} = R;
end
for i = 1:1/test_ratio
    Xtest{i} = X(D{i}((i-1)*num_test+1 : i*num_test),:);  % 以索引的前num_test个数据点作为测试样本Xtest
    Ttest{i} = T(D{i}((i-1)*num_test+1 : i*num_test),:);
    num{i} = number(D{i}((i-1)*num_test+1 : i*num_test),:);
    D{i}((i-1)*num_test+1 : i*num_test) = [];
    Xtraining{i} = X(D{i},:);          % 剩下的数据作为训练样本Xtraining
    Ttraining{i} = T(D{i},:);
end
