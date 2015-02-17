%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Digit Classification (0,1,2,...,9)	      %%%
%%% project for Machine Learning, AUEB, 2014 %%%
%%% John Zobolas					               %%%
%%% TRAIN THE DATA!!!                        %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

clear all; 
close all;

rand('seed',0);

% load the data
load mnist_all.mat;

% list{i} = digit i-1 trained/tested
testDataList = {test0; test1; test2; test3; test4; test5; test6; test7; test8; test9}; 
trainDataList = {train0; train1; train2; train3; train4; train5; train6; train7; train8; train9};

% K = Poses bernoulli na baloume! (the more the better)
KList = [1 2 4 8 16 32];

% keep the results of the m(K,D) bernoulli parameters kai ton ek ton
% proteron pithanotiton p(K)
% 6 values for K (1,2,4,8,16,32) and 10 digits to train (0-9)
mcell = cell(6,10);
pcell = cell(6,10);

% BALE 1:6 !!!!!
for numOfK = 1:6

K = KList(numOfK);
fprintf('\n%%%%%%%%%% TRAINING FOR K=%d %%%%%%%%%%\n',K);

for digit=1:10
% ousiastika kanoume train to psifio (digit-1)!!!

% x = data matrix
x = double(trainDataList{digit});

% make the pixels to 1 or 0
x(x < 3) = 0;
x(x > 0) = 1;

% N = numberOfData, D = 784 - diastiasi dedomenon
[N D]=size(x);

%ARXIKOPOIISEIS
% p = pinakas ton ek ton proteron pithanotiton p(k)=1/K
p = (1/K).*ones(1,K);

% M = pinakas bernoulli parametron: 0.4 < M(k,d) < 0.6
a = 0.4; b = 0.6;
m = a + (b-a).*rand(K,D);

% z(n,k) = pinakas me tis ek ton usteron pithanotites 
z = zeros(N,K);

%%% EM ALGORITHM %%%
L_old = inf;
tic
while 1
   
   %%%              E step                 %%%
   %%%         ipologizo ta z(n,k)         %%% 
   %%% me kolpa gia arithmitiki eustatheia %%%
   
   %fprintf('E step\n');
   
   f2 = x*log(m)' + (1-x)*(log(1-m))';
   f = f2 + ones(N,1)*log(p);
   maxf = max(f,[],2)';
   f = f - maxf'*ones(1,K);
   f = exp(f);
   
   % pinakas athroismaton by grammes
   sumf = sum(f,2);
   
   for n=1:N
      z(n,:) = f(n,:)/sumf(n); 
   end

   %%%             M step                  %%%
   %%%         ipologizo ta m(k,d)         %%% 
   %%% me kolpa gia arithmitiki eustatheia %%%
   
   %fprintf('M step\n');
   
   sum2 = sum(z);
   sum1 = z'*x;
   temp = sum2'*ones(1,D);
   m = sum1./temp;
   p = sum2/N; 
   
   % epeidi mpainei se logarithmo epeita:
   m(m==0) = 1e-10;
   m(m>=1) = 1 - 1e-10;
   
   %%% ELEGXOS SIGKLISIS     %%%
   %%% me eustatheia kai edo %%%
   
   f2 = x*log(m)' + (1-x)*(log(1-m))';
   fL = f2 + ones(N,1)*log(p);
   maxfL = max(fL,[],2)';
   fL = fL - maxfL'*ones(1,K);
   fL = exp(fL);
   
   L_new = sum(maxfL' + log(sum(fL,2)));
   
   %fprintf('L function: %f kai diafora: %f\n', L_new, L_new - L_old);
    
   if (abs(L_new - L_old) < 1e-5)
      break;
   end
   
   L_old = L_new;

end

time=toc;
fprintf('\nTotal Execution Time (EM): %f for K=%d and training digit=%d\n', time, K, digit-1);

% kratame tis bernoulli parametrous + tis ek ton proteron pithanotites
mcell{numOfK,digit} = m;
pcell{numOfK,digit} = p;

end

end

