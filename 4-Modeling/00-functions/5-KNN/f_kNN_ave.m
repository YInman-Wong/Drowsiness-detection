function [result,label_kNN_ave]=f_kNN_ave(trd,trl,ted,tel,k)

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%函数名称：基于平均距离的k近邻学习器 f_knn_ave.m
%%入口参数：训练数据 tr   测试数据 te   数据形式 特征+标签   近邻数 k
%%出口参数：精度 A_kNN_ave   预测标签 label_kNN_ave    对所有种类的概率 P_kNN_ave   运算时间 time
%%函数说明：
    %%对于测试样本，搜寻最近的每一种训练样本各k个，通过平均距离进行分类
    %%适合用于不均衡分类，在均衡分类中，也表现不俗
    %%缺点，速度慢，不能提前建模
    %%其它，可以精确估计运行时间，概率可信度高
%%by Sebastian Li, 2020.10.28, ZZU
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
if ~exist('k', 'var')
     k = 3;
end               % 如果没有输入k值，取k=3
                  % 也很有意思，取3总不会太差
                  
tic;
m1=size(trd,1);
m2=size(ted,1);    % m1为训练样本数，m2为测试样本数
L=unique(trl);      % 统计种类
ls=size(L,1);       % 统计类别总数

probability=zeros(size(ted,1),ls); 
label_kNN_ave=zeros(m2,1);         % 预设运行空间

for j=1:m2   % 对每一个测试样本
    distance=zeros(m1,1);
    for i=1:m1   % 对每一个训练样本
        distance(i)=norm(ted(j,:)-trd(i,:));    %计算测试数据与每个训练数据的欧式距离 
    end
    [distance1,index]=sort(distance);  % 对所有距离进行排序
    x1=trl(index);
    distance1(:,2)=x1;      % distance1的第一列是距离，第二列是标签
    di=zeros(ls,2);
for w=L'   % 对每个种类
    x2=find(distance1(:,2)==w);
    x2=x2(1:k,:);
    dis=distance1(x2,1);
    dis=sum(dis)/k;
    di(w,1)=dis;
    di(w,2)=w;
end                      % 把每一种标签都找出距离最近的k的样本，并计算平均距离
di(di(:,1)==0,:)=[];   % 处理标签不连续

c=sum(di(:,1))./di(:,1)';
c=c/max(c,[],2);
c(isnan(c)) = 0;   % 如果出现NaN，转化为0
% probability(j,:)=c;      % 输出概率：距离的总和除以各个距离，然后除以其中最大值，得类概率
b=sortrows(di,1);
label_kNN_ave(j,1)=b(1,2);  % 平均距离最近的标签为预测标签
end
time = toc;

bj=(label_kNN_ave==tel);
a=nnz(bj);
%% acc
A_kNN_ave=a/m2;                % 输出识别率
%% auc
% auc = roc(zero_one(label_kNN_ave),zero_one(tel));
%% recall and precision
for i = 1:3
    recall(1,i) = sum(label_kNN_ave == i & tel == i)/sum(tel==i); %召回率
    precisious(1,i) = sum(label_kNN_ave == i & tel == i)/sum(label_kNN_ave==i); %准确率
end
result = [A_kNN_ave recall precisious time];% auc 