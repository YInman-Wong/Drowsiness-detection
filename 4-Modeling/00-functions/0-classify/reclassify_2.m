function [y] = reclassify_2(a)
% -a: 行向量
% -y：行向量

y(a<1.5) = 1;
y(a>=1.5) = 2;