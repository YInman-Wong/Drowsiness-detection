function [result,test_target,test_output,test_number] = prnn_individual(number,P,T,train_ratio)
tic;
x = P;
t = T;
% Choose a Training Function
% For a list of all training functions type: help nntrain
% 'trainlm' is usually fastest.
% 'trainbr' takes longer but may be better for challenging problems.
% 'trainscg' uses less memory. Suitable in low memory situations.
trainFcn = 'trainscg';  % Scaled conjugate gradient backpropagation.

% Create a Pattern Recognition Network
hiddenLayerSize = 2*size(P,1);
net = patternnet(hiddenLayerSize, trainFcn);

% Choose Input and Output Pre/Post-Processing Functions
% For a list of all processing functions type: help nnprocess
net.input.processFcns = {'removeconstantrows','mapminmax'};

% Setup Division of Data for Training, Validation, Testing
% For a list of all data division functions type: help nndivision
net.divideFcn = 'dividerand';  % Divide data randomly
net.divideMode = 'sample';  % Divide up every sample
net.divideParam.trainRatio = train_ratio;
net.divideParam.valRatio = (1-train_ratio)/2;
net.divideParam.testRatio = (1-train_ratio)/2;

% Choose a Performance Function
% For a list of all performance functions type: help nnperformance
net.performFcn = 'crossentropy';  % Cross-Entropy

% Choose Plot Functions
% For a list of all plot functions type: help nnplot
net.plotFcns = {'plotperform','plottrainstate','ploterrhist', ...
    'plotconfusion', 'plotroc'};

% Train the Network
[net,tr] = train(net,x,t);

% Test the Network
y = net(x);

tind = vec2ind(t);
yind = vec2ind(y);

test_target = tind .* tr.testMask{1};
test_output = yind .* tr.testMask{1};
test_number = number .* tr.testMask{1};

test_number(isnan(test_number)) = [];
test_target(isnan(test_target)) = [];
test_output(isnan(test_output)) = [];%T.* tr.testMask{1})

time = toc;
accuracy = sum(test_output == test_target)/length(test_target');

auc = roc(zero_one(test_output),zero_one(test_target));
for j = 1:3
    recall(1,j) = sum(test_output == j & test_target == j)/sum(test_target == j);
    presicious(1,j) = sum(test_output == j & test_target == j)/sum(test_output == j);
end
result = [accuracy recall presicious auc time];

