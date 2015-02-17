% We assume that the bernoullimix3(.m) has ran
% and has produced the necessary data
% -> m(N,K),p(K) for every k.

% Draw the "trained/learned" digits:
% put Kplot = 1,2,4,8,16,32!!!
Kplot = 4;
indK = find(KList == Kplot);

hold on;
for i=1:10
    mToPlot = mcell{indK,i};
    for j=(Kplot*(i-1)+1):(Kplot*(i-1)+Kplot)
         % 10 digits, K = Kplot
         fprintf('i:%d kai j:%d\n',i,j);
         subplot(10,Kplot,j);
         k = j - (i-1)*Kplot;
         imagesc(reshape(mToPlot(k,:),28,28)');
         axis off; grid on; colormap('gray');
         %axis equal;
         set(gca, 'PlotBoxAspectRatio', [15,8,10]);
    end
end
hold off;
