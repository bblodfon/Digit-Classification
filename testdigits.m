%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%% Digit Classification (0,1,2,...,9)	     %%%
%%% project for Machine Learning, AUEB, 2014 %%%
%%% John Zobolas					         %%%
%%% TEST THE DATA!!!                         %%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% We assume that the bernoullimix3(.m) has ran
% and has produced the necessary data
% -> m(N,K),p(K) for every k.

% allazoume ta test data gia na einai kai auta
% me 0 kai 1:
test = cell(1,10);
for digit=1:10
    x = double(testDataList{digit});
    x(x < 3) = 0;
    x(x > 0) = 1;
    test{digit} = x;
end

% briskoume tis ek ton proteron pithanotites
% gia kathe psifio apo to training set: (ep(digit)=N(digit)/N(all))
ep = zeros(1,10);
for digit=1:10
   ep(digit) = size(trainDataList{digit},1); 
end
ep = ep./sum(ep);

% den allazei apo prin i diastasi:
D = 784;

% to arxeio opou tha grapsoume ta apotelesmata
fileID = fopen('results.txt','w');

% krata to pososto ton lathon gia ola ta psifia
% ksexorista gia kathe K:
avgError = zeros(1,6);

% apo prin:
KList = [1 2 4 8 16 32]; 
% BALE 1:6 !!!!!
for numOfK = 1:6

totalTestData = 0;
totalCount = 0;
K = KList(numOfK);      

fprintf(fileID,'\n%%%%%%%%%% RESULTS FOR K=%d %%%%%%%%%%\n',K);

for testdigit=1:10
    % eksetazoume to (digit-1) kathe fora
    
    % x o pinakas ton test data
    x = test{testdigit};
    
    % how much test data for (digit-1)
    N = size(x,1);
    
    % pinakas ipo sinthiki katanomon: pith(N,10)
    % kathe grammi antistoixei se ena test data
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
    
    maxp = max(pith,[],2)'; %max kathe grammis
    pith = pith - maxp'*ones(1,10);
    pith = exp(pith);
    
    % pinakas athroismaton by grammes
    sumpith = sum(pith,2);
    
    for n=1:N
      pith(n,:) = pith(n,:)/sumpith(n); 
    end
    
    % thelo na chekaro poses fores sta test data
    % i pithanotita na itan ontos stin katigoria pou
    % ksero oti itan ena psifio, eimai i magaliteri!!!
    
    %vector-stili me tis theseis ton megaliteron se kathe grammi tou pith:
    [~,index] = max(pith,[],2); 
    
    count = 0;
    for n=1:N
       if (index(n) ~= testdigit) 
           count = count+1;
       end
    end
    
    fprintf(fileID,'\nGia to digit=%d brikame %d lathi sta %d dedomena elegxou. Error Percentage:%.3f\n',testdigit-1,count,N,(count/N)*100);
    
    totalCount = totalCount + count;
    totalTestData = totalTestData + N;

end

% oso einai to numOfK:
avgError(numOfK) = (totalCount/totalTestData)*100;

end
% BALE 1:6 !!!!!
for numOfK=1:6
    K = KList(numOfK);
    fprintf(fileID,'Gia K=%d, error percentage was %.3f\n',K,avgError(numOfK));
end

fclose(fileID);
    
