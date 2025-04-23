function E = segmentSeqForEn(sequence, dim, tau, flag)
    if nargin < 2
        dim = 2;
    end
    if nargin < 3
        tau = 1;
    end
    if nargin < 4
        flag = 1;
    end
    
    switch(flag)
        case(1) %% entropy理论默认是1
            %% sequence是1*N向量，dim是产生数据片段的个数(即E的行数)，tau采集数据延时的时间(是个整数，一般是1)
            N = length(sequence);

            ind = 1:N-(dim-1)*tau; % 这才是数据截断的长度
            E = sequence(ind);

            f = tau*(1:dim-1);
            for i = 1:length(f)
                New_ind = 1+f(i):length(ind)+f(i);
                E = [E;sequence(New_ind)];
            end
            %% 此时E按列的数据的维数就是dim
        case(2)
             %% sequence是1*N向量，dim是数据片段的长度(数据片段的维数)，tau采集数据延时的时间(是个整数，一般是1)
            ind = 1:dim;%数据截断的长度
            E = sequence(ind);
            while 1
                ind = ind + tau;            
                if ind(end)>length(sequence)
                    break
                else
                    E = [E;sequence(ind)];
                end
            end
            E = E';
    end
end