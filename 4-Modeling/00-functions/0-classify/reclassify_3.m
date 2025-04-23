function [y] = reclassify_3(a)
% -a: 行向量
% -y：行向量

y = round(a);
y(y<1) = 1;
y(y>3) = 3;