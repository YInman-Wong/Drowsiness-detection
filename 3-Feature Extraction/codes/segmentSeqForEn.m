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
        case(1) %% entropy����Ĭ����1
            %% sequence��1*N������dim�ǲ�������Ƭ�εĸ���(��E������)��tau�ɼ�������ʱ��ʱ��(�Ǹ�������һ����1)
            N = length(sequence);

            ind = 1:N-(dim-1)*tau; % ��������ݽضϵĳ���
            E = sequence(ind);

            f = tau*(1:dim-1);
            for i = 1:length(f)
                New_ind = 1+f(i):length(ind)+f(i);
                E = [E;sequence(New_ind)];
            end
            %% ��ʱE���е����ݵ�ά������dim
        case(2)
             %% sequence��1*N������dim������Ƭ�εĳ���(����Ƭ�ε�ά��)��tau�ɼ�������ʱ��ʱ��(�Ǹ�������һ����1)
            ind = 1:dim;%���ݽضϵĳ���
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