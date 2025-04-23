function Hx = inforn_entropy(y,duan)

 %不以原信号为参考的时间域的信号熵
% 【输入】
% - y:待求信息熵的序列
% - duan:待求信息熵的序列要被分块的块数(将序列按duan数等分，如果duan=10,就将序列分为10等份)
% 【输出】
% - Hx:y的信息熵

x_min=min(y);
x_max=max(y);
maxf(1)=abs(x_max-x_min);
maxf(2)=x_min;
duan_t=1.0/duan;
jiange=maxf(1)*duan_t;
pnum(1) = length(find(y));
for i=2:duan-1
    pnum(i) = length(find((y>=maxf(2)+(i-1)*jiange)&(y)));
end
pnum(duan)=length(find(y>=maxf(2)+(duan-1)*jiange));
ppnum=pnum/sum(pnum);%每段出现的概率
Hx=0;
for i=1:duan
    if ppnum(i)==0
        Hi=0;
    else
        Hi=-ppnum(i)*log2(ppnum(i));
    end
    Hx=Hx+Hi;
end