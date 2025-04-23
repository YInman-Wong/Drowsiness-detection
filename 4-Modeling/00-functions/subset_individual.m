function [Xtraining,Ttraining,Xtest,Ttest,test_number] = subset_individual(number,X,T,test_ratio)
%% explaination
% 该函数把原始数据集（一行为一条数据）划分为训练集（一列为一条数据）和测试集（一列为一条数据）
% ======= input ========
% -X: 原始数据集，一行为一条数据
% -T：原始标签，一行为一条数据
% -test_ratio: 测试集占比

% ======= output =======
% -Xtraining,Ttraining: 训练集和训练集标签（一行为一条数据）
% -Xtest,Ttest：测试集和测试集标签（一行为一条数据）
%% function
ndata = size(X,1);        % ndata样本数(行)，D维数（列）
num_test = round(test_ratio * ndata);
R = randperm(ndata);         % 1到ndata这些数随机打乱得到的一个随机数字序列作为索引
Xtest = X(R(1:num_test),:);  % 以索引的前num_test个数据点作为测试样本Xtest
Ttest = T(R(1:num_test),:);
test_number = number(R(1:num_test),:);
R(1:num_test) = [];
Xtraining = X(R,:);          % 剩下的数据作为训练样本Xtraining
Ttraining = T(R,:);
% num_training = size(Xtraining,1);%num_training；训练样本数