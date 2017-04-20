%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Digit Classification (0,1,2,...,9)	     %%%
%%% project for Machine Learning, AUEB, 2014 %%%
%%% John Zobolas                             %%%
%%% TEST THE DATA!!!                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We assume that the bernoullimix3(.m) has ran
% and has produced the necessary data
% -> m(N,K),p(K) for every k.

% we change the test data, making them either 0 or 1:
test = cell(1,10);
for digit=1:10
    x = double(testDataList{digit});
    x(x < 3) = 0;
    x(x > 0) = 1;
    test{digit} = x;
end

% find the a priori probabilities for every digit using the
% training set: (ep(digit)=N(digit)/N(all))
ep = zeros(1,10);
for digit=1:10
   ep(digit) = size(trainDataList{digit},1); 
end
ep = ep./sum(ep);

% dimension of data:
D = 784;

fileID = fopen('results.txt','w');

% for every K find a different average Error (for all the digits):
avgError = zeros(1,6);

KList = [1 2 4 8 16 32]; 
for numOfK = 1:6

totalTestData = 0;
totalCount = 0;
K = KList(numOfK);      

fprintf(fileID,'\n%%%%%%%%%% RESULTS FOR K=%d %%%%%%%%%%\n',K);

for testdigit=1:10
    % testdigit is an index
    
    % x is the matrix with the test data
    x = test{testdigit};
    
    % how much test data for this digit
    N = size(x,1);
    
    % pith(N,10) is the matrix distribution
    pith = zeros(N,10);
    tic
    for n=1:N
        for c=1:10
            sum1 = 0;
            for k=1:K
                product = 1;
                for d=1:D
                    product = product * power(mcell{numOfK,c}(k,d),x(n,d)) * power(1-mcell{numOfK,c}(k,d),1-x(n,d));
                end
            sum1 = sum1 + product * pcell{numOfK,c}(k);
            end
            pith(n,c) = log(sum1) + log(ep(c));
        end
    end
    time=toc;
    fprintf(fileID,'\nTime: %f', time);
    
    maxp = max(pith,[],2)'; % max of every row 
    pith = pith - maxp'*ones(1,10);
    pith = exp(pith);
    
    sumpith = sum(pith,2);
    
    for n=1:N
      pith(n,:) = pith(n,:)/sumpith(n); 
    end
    
    % I want to check how many times in the test data the probability that a digit was indeed 
    % the one it should be, is the largest of all! E.g. for a test digit of '4' I expect the probability
    % that it is indeed '4' to be larger, than for it to be '0,','1','2','3','5','6','7','8' or '9'.
    
    % a column-vector with the indexes of the largest elements of every row of pith matrix:
    [~,index] = max(pith,[],2); 
    
    count = 0;
    for n=1:N
       if (index(n) ~= testdigit) 
           count = count+1;
       end
    end
    
    fprintf(fileID,'\nFor the digit=%d we found %d mistakes in %d test data. Error Percentage:%.3f\n',testdigit-1,count,N,(count/N)*100);
    
    totalCount = totalCount + count;
    totalTestData = totalTestData + N;

end

avgError(numOfK) = (totalCount/totalTestData)*100;

end

for numOfK=1:6
    K = KList(numOfK);
    fprintf(fileID,'For K=%d, the total error percentage was %.3f\n',K,avgError(numOfK));
end

fclose(fileID);
    
