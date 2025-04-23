clear
cd('E:\00-毕业论文');
addpath(genpath(pwd))
% 读取数据集
load('modeling.mat')

% load('modeling1.mat')
% load('i1.mat')

%% 
% 定义输入目标
P = [i p]';
T = f'; T = ind2vec(T);
number = num';

clearvars -except P T number

i = 1;
while i <= 10
    i
    [temp_results,temp_target,temp_output,temp_number] = prnn_individual(number,P,T,0.1);
%     if i <= 2
%         if temp_results(1,1) < 0.7
%            continue
%         end
%     else
%         if temp_results(1,1) < 0.72
%            continue
%         end
%     end
    results(i,:) = temp_results;
    target{i} = temp_target;
    output{i} = temp_output;
    participant{i} = temp_number;
    i = i + 1;
end
%% 画图
h = histogram(results(:,1),'BinWidth',0.01);
axis([0.645,0.715,0,5.25])
set(gca,'FontSize',14,'Fontname', 'Times New Roman');
xlabel('准确率','FontSize',14,'Fontname', '宋体');
ylabel('出现次数','FontSize',14,'Fontname', '宋体');
saveas(h,'.\4-模型搭建\prnn_results\pdf.tiff')
%% 个体差异
for j = 1:35
    for i = 1:10
        itarget{i,j} = target{i}(:,participant{i}(1,:) == j);
        ioutput{i,j} = output{i}(:,participant{i}(1,:) == j);
        
        accuracy{j}(i,1) =  sum(ioutput{i,j} == itarget{i,j})/length(itarget{i,j});
        for k = 1:3
            recall{j}(i,k) = sum(ioutput{i,j} == k & itarget{i,j} == k)/sum(itarget{i,j} == k);
            presicious{j}(i,k) = sum(ioutput{i,j} == k & itarget{i,j} == k)/sum(ioutput{i,j} == k);
        end
    end
    prnn_individual_analysis_ip(j,:) = [mean(accuracy{j}) mean(recall{j}) mean(presicious{j})];
end
%% 再次画图
figure;
b = bar([prnn_individual_analysis_ip(:,1)]); % axis([0,36,0.4,1]);
set(gca,'FontSize',14,'Fontname', 'Times New Roman');
xlabel('被试','FontSize',14,'Fontname', '宋体');
ylabel('准确率','FontSize',14,'Fontname', '宋体');
% saveas(b,'.\4-模型搭建\prnn_results\individual.tiff')

clearvars -except results target output participant h prnn_individual_analysis_ip b
% save('.\4-模型搭建\prnn_results\prnn_results.mat')