function FuzzyEn = Entropy_Fuzzy(sequence, dim, r, n, tau, flag)
%%
% - sequence��1*N����
% - dim����������Ƭ�εĸ���(��E�������������ռ��ά��)
% - tau���ɼ�������ʱ��ʱ��(�Ǹ�������һ����1)
%%
    if nargin < 2  % nargin���ж������������
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
    r = r*std(sequence);% r = g �� Std
    
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
            phi(i) = (sum(D)-1)/(N-m*tau-1);%����i=j�����
        end
        
        result(j) = sum(phi)/(N-m*tau)+eps;
    end
    
    FuzzyEn = log(result(1))-log(result(2));    
end