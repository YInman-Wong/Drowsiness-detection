clear
cd('E:\00-毕业论文');
addpath(genpath(pwd))
% 读取数据集
load('modeling.mat')
%% 
% 定义输入目标
P = [i p];
T = f; % T = ind2vec(T');
clearvars -except P T num

%%

[Xtraining,Ttraining,Xtest,Ttest,number] = subset_validation(num,P,T,0.1);
target = Ttest;
participant = number;

for i = 1:10
    [tree_classifier,time] = tree_classifier(Xtraining{i}, Ttraining{i});

    output{i} = tree_classifier.predictFcn(Xtest{i});
    accuracy = sum(output{i} == target{i})/length(target{i}');
    for j = 1:3
        recall(1,j) = sum(output{i} == j & target{i} == j)/sum(target{i} == j);
        presicious(1,j) = sum(output{i} == j & target{i} == j)/sum(output{i} == j);
    end
    results(i,:) = [accuracy recall presicious time]; 
    clear tree_classifier
end
clearvars -except target output results P T participant
%% 画图
h = histogram(results(:,1),'BinWidth',0.01);
axis([0.805,0.865,0,4.25]);
set(gca,'FontSize',14,'Fontname', 'Times New Roman');
xlabel('准确率','FontSize',14,'Fontname', '宋体');
ylabel('出现次数','FontSize',14,'Fontname', '宋体');
% saveas(h,'.\4-模型搭建\tree_results\pdf.tiff')

%%
for j = 1:35
    for i = 1:10
        itarget{i,j} = target{i}(participant{i}(:,1) == j,:);
        ioutput{i,j} = output{i}(participant{i}(:,1) == j,:);
        
        accuracy{j}(i,1) =  sum(ioutput{i,j} == itarget{i,j})/length(itarget{i,j});
        for k = 1:3
            recall{j}(i,k) = sum(ioutput{i,j} == k & itarget{i,j} == k)/sum(itarget{i,j} == k);
            presicious{j}(i,k) = sum(ioutput{i,j} == k & itarget{i,j} == k)/sum(ioutput{i,j} == k);
        end
    end
    individual_analysis_ip(j,:) = [mean(accuracy{j}) mean(recall{j}) mean(presicious{j})];
end
sum(individual_analysis_ip(:,1)<0.8)
figure;
b = bar([individual_analysis_ip(:,1)]); axis([0,36,0.4,1.02]);
set(gca,'FontSize',14,'Fontname', 'Times New Roman');
xlabel('被试','FontSize',14,'Fontname', '宋体');
ylabel('准确率','FontSize',14,'Fontname', '宋体');
% saveas(b,'.\4-模型搭建\tree_results\individual.tiff')

clearvars -except results target output participant h individual_analysis_ip b
% save('.\4-模型搭建\tree_results\tree_results.mat')