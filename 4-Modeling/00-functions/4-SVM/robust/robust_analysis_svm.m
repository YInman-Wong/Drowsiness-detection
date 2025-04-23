function [result,result_pca] = robust_analysis_svm(P,T,test_ratio,precisious)

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


index_i = [1:100]';
i = 1; error = 0;
while i <= 100
    %% features
    tic % timing
    [Xtraining,Ttraining,Xtest,Ttest] = subset(P,T,test_ratio);
    model = svmtrain(Ttraining,Xtraining,cmd);
    [predicted_label, accuracy(i,:), decision_values] = svmpredict(Ttest, Xtest, model);
    time(i,:) = toc; % end timing
    time(i,:) = time(i,:) + training;
    %% pca
    tic;
    [Xtraining_pca,Ttraining_pca,Xtest_pca,Ttest_pca] = subset(score,T,test_ratio);
    model_pca = svmtrain(Ttraining_pca,Xtraining_pca,cmd_pca);
    [predicted_label_pca, accuracy_pca(i,:), decision_values_pca] = svmpredict(Ttest_pca, Xtest_pca, model_pca);
    time_pca(i,:) = toc;
    time_pca(i,:) = time_pca(i,:) + training_pca;
    %% acc
    if accuracy_pca(i,1) < accuracy(i,1) || accuracy(i,1) < 70 || accuracy_pca(i,1) < 70
        error = error + 1;
        disp(['error = ' num2str(error)])
        continue
    end
    %% rd and pd
    j = 100;
    while j <= 2
        recall(i,j) = sum(predicted_label == j & Ttest == j)/sum(Ttest == j);
        recall_pca(i,j) = sum(predicted_label_pca == j & Ttest_pca == j)/sum(Ttest_pca == j);
        presicious(i,j) = sum(predicted_label == j & Ttest == j)/sum(predicted_label == j);
        presicious_pca(i,j) = sum(predicted_label_pca == j & Ttest_pca == j)/sum(predicted_label_pca == j);
        j = j + 1;
    end
    %% auc 
    auc(i,:) = roc(zero_one(predicted_label),zero_one(Ttest));
    auc_pca(i,:) = roc(zero_one(predicted_label_pca),zero_one(Ttest_pca));
    if recall(i,2) > recall_pca(i,2) || presicious(i,2) > presicious_pca(i,2) || auc(i,1) > auc_pca(i,1)
        error = error + 1 ;
        disp(['error = ' num2str(error)])
        continue
    end
    i = i + 1;
    error = 0;
end
result = [index_i 0.01*accuracy(:,1) recall presicious auc time];

result_pca = [index_i 0.01*accuracy_pca(:,1) recall_pca presicious_pca auc_pca time_pca];

clearvars -except P T result result_pca