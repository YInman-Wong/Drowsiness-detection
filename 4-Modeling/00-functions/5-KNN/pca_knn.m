function [results,label_kNN_ave,tel] = pca_knn(P,T,precision,test_ratio,k)
%% explaination
% 输出： 准确率 召回率 精度 运算时间 预测标签 概率
% 输入： 特征矩阵 标签 训练集占比 近邻数
%% main function
if ~exist('precision', 'var')
     precision = 0.9;
end 

if ~exist('test_ratio', 'var')
     test_ratio = 0.4;
end  

if ~exist('k', 'var')
     k = 3;
end               % 如果没有输入k值，取k=3
                  % 也很有意思，取3总不会太差
                  
[coeff,score,latent] = pca(P);%我们这里需要他的pc和latent值做分析
s = cumsum(latent)./sum(latent);
s = s(s<=precision); %精度取0.95
score = score(:,1:(length(s)+1));% score是降维旋转后矩阵

[trd,trl,ted,tel] = subset(score,T,test_ratio);
[results,label_kNN_ave] = f_kNN_ave(trd,trl,ted,tel,k);