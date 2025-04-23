function [results,tel,label_kNN_ave,num] = knn(number,P,T,test_ratio,k)
%% explaination
% 输出： 准确率 召回率 精度 运算时间 测试集target 预测标签 编号
% 输入： 特征矩阵 标签 训练集占比 近邻数
%% main function
if ~exist('test_ratio', 'var')
     test_ratio = 0.1;
end  
if ~exist('k', 'var')
     k = 3;
end               % 如果没有输入k值，取k=3
                  % 也很有意思，取3总不会太差

[trd,trl,ted,tel] = subset(P,T,test_ratio);
%% function
ndata = size(P,1);        % ndata样本数(行)，D维数（列）
num_test = round(test_ratio * ndata);
R = randperm(ndata);         % 1到ndata这些数随机打乱得到的一个随机数字序列作为索引
ted = P(R(1:num_test),:);  % 以索引的前num_test个数据点作为测试样本Xtest
tel = T(R(1:num_test),:);
num = number(R(1:num_test),:);

R(1:num_test) = [];
trd = P(R,:);          % 剩下的数据作为训练样本Xtraining
trl = T(R,:);


[results,label_kNN_ave] = f_kNN_ave(trd,trl,ted,tel,k);