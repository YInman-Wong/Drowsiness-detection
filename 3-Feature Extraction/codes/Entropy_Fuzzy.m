function FuzzyEn = Entropy_Fuzzy(sequence, dim, r, n, tau, flag)
%%
% - sequence：1*N向量
% - dim：产生数据片段的个数(即E的行数，向量空间的维度)
% - tau：采集数据延时的时间(是个整数，一般是1)
%%
    if nargin < 2  % nargin：判断输入变量个数
        dim = 2;
    end
    if nargin < 3
        r = 0.25;
    end
    if nargin < 4
        n = 4;
    end
    if nargin < 5
        tau = 1;
    end
    if nargin < 6
        flag = 1;
    end
    %if tau > 1, sequence = downsample(sequence, tau); end
    r = r*std(sequence);% r = g × Std
    
    N = length(sequence);
    result = zeros(1,2);

    for j = 1:2
        m = dim+j-1;
        phi = zeros(1, N-m*tau);
        dataMat = segmentSeqForEn(sequence, m, tau, flag);
        dataMat = dataMat-repmat(mean(dataMat), m, 1);
        
        for i = 1:N-m*tau
            tempMat = max(abs(dataMat(:, 1:end-1) - repmat(dataMat(:,i), 1, N-m*tau)));
            D = exp(-(tempMat.^n)/r);
            phi(i) = (sum(D)-1)/(N-m*tau-1);%减掉i=j的情况
        end
        
        result(j) = sum(phi)/(N-m*tau)+eps;
    end
    
    FuzzyEn = log(result(1))-log(result(2));    
end