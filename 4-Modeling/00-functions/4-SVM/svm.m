function [result,predicted_label,Ttest,result_pca,predicted_label_pca,Ttest_pca] = svm(P,T,test_ratio,precisious)
%% 
% 输入
% -P：需要进行SVM分类的矩阵（一行为一条数据，归一化时注意一下mapminmax是对每行归一化）
% -T: 原矩阵的标签（一行为一条数据）
% -test_ratio: 测试集占比
% 输出
% -accuracy,recall,presicious,time： 准确率，召回率，精度，训练时间
% -Ttest: 训练集的标签
% - predicted_label: svm对测试集的输出
%% example
% P = features{1};
% T = fl_features{1};
% test_ratio = 0.4;
%%
tic;
[Xtraining,Ttraining,Xtest,Ttest] = subset(P,T,test_ratio);
[bestacc,bestc,bestg] = r_SVMcgForClass(Ttraining,Xtraining);
training = toc;
cmd = ['-g ',num2str(bestg),'-c ',num2str(bestc)];
tic;
[coeff,score,latent] = pca(P);%我们这里需要他的pc和latent值做分析
s = cumsum(latent)./sum(latent);
s = s(s<=precisious); %精度取0.9
score = score(:,1:(length(s)+1));% score是降维旋转后矩阵
[Xtraining_pca,Ttraining_pca,Xtest_pca,Ttest_pca] = subset(score,T,test_ratio);
[bestacc_pca,bestc_pca,bestg_pca] = r_SVMcgForClass(Ttraining_pca,Xtraining_pca);
training_pca = toc;
cmd_pca = ['-g ',num2str(bestg_pca),'-c ',num2str(bestc_pca)];

i = 1;
while i <= 1
    %% features
    tic % timing
    [Xtraining,Ttraining,Xtest,Ttest] = subset(P,T,test_ratio);
    model = svmtrain(Ttraining,Xtraining,cmd);
    [predicted_label, accuracy(i,:), decision_values] = svmpredict(Ttest, Xtest, model);
    time = toc; % end timing
    time = time + training;
    %% pca
    tic;
    [Xtraining_pca,Ttraining_pca,Xtest_pca,Ttest_pca] = subset(score,T,test_ratio);
    model_pca = svmtrain(Ttraining_pca,Xtraining_pca,cmd_pca);
    [predicted_label_pca, accuracy_pca, decision_values_pca] = svmpredict(Ttest_pca, Xtest_pca, model_pca);
    time_pca = toc;
    time_pca = time_pca + training_pca;
%     %% acc
%     if accuracy_pca(1,1) < accuracy(1,1) || accuracy(1,1) < 70 || accuracy_pca(1,1) < 70
%         error = error + 1;
%         disp(['error = ' num2str(error)])
%         continue
%     end
    %% rd and pd
    j = 1;
    while j <= 2
        recall(1,j) = sum(predicted_label == j & Ttest == j)/sum(Ttest == j);
        recall_pca(1,j) = sum(predicted_label_pca == j & Ttest_pca == j)/sum(Ttest_pca == j);
        presicious(1,j) = sum(predicted_label == j & Ttest == j)/sum(predicted_label == j);
        presicious_pca(1,j) = sum(predicted_label_pca == j & Ttest_pca == j)/sum(predicted_label_pca == j);
        j = j + 1;
    end
    %% auc
    auc = roc(zero_one(predicted_label),zero_one(Ttest));
    auc_pca = roc(zero_one(predicted_label_pca),zero_one(Ttest_pca));
%     if recall(1,2) <= recall_pca(1,2) && presicious(1,2) <= presicious_pca(1,2) && auc <= auc_pca
%         break
%     else
%         error = error + 1 ;
%         disp(['error = ' num2str(error)])
%     end
    i = i + 1;
    error = 0;
end
result = [0.01*accuracy(1,1) recall presicious auc time];
result_pca = [0.01*accuracy_pca(1,1) recall_pca presicious_pca auc_pca time_pca];