% This program aligns two morphologically different signals - CO2 and
% respiratory pressure - using concepts of sum of squared difference and 
% coeffcient of determination (R^2)

close all;
clear all;
clc;

% Import CO2 data
CO2=xlsread('complete alignment data file.xlsx',-1);
normCO2=CO2./std(CO2);
shiftCO2=normCO2-mean(normCO2);

% Import P data
P=xlsread('complete alignment data file.xlsx',-1);
normP=P./std(P);

% Sum of sqaured difference
x=1;
for lag=-1000:1000
    shiftP=lagmatrix(normP,lag);
    shiftP(isnan(shiftP))=0;
    stats=corrcoef(shiftP,shiftCO2);
    Rsq(x)=stats(1,2).^2;
    for i=1:size(normP,1)
        sqdiff(i)=(shiftP(i)-shiftCO2(i)).^2;
    end
    sumdiff(x)=sum(sqdiff);
    x=x+1;
end
[maxr maxrloc]=max(Rsq);
optrsq=maxrloc-1000-1;

% Least square
[min minloc]=min(sumdiff);
optloc=minloc-1000-1;

% Plot
range=-1000:1000;
figure;subplot(211);plot(range,sumdiff);
text(range(minloc),min,['\rightarrow Minimum sum occurs at ',num2str(optloc)]);xlabel('Shift');ylabel('Sum of squared difference');

subplot(212);plot((1:6000)+optloc,normP(1:6000),'m',1:6000,shiftCO2(1:6000),'g','Linewidth',2);xlabel('Time (100samples=1s)');ylabel('Normalized amplitude of signals');
hleg=legend('Shifted pressure','CO_2');saveas(gcf,'Alg-3.png');
    
% R Sqaured- Coefficient of determination
x1=1;
for lag=-1000:1000
    newP1=lagmatrix(normP',lag);
    newP1(isnan(newP1))=0;
    stats1=corrcoef(newP1,shiftCO2');
    Rsq1(x1)=stats1(1,2).^2;
    x1=x1+1;
end
[maxr1 maxrloc1]=max(Rsq1);
optrsq1=maxrloc1-1000-1;

% Plot R^2
range=-1000:1000;
figure;plot(range,Rsq);
text(range(Rsq==max(Rsq)),max(Rsq),['\rightarrow Maximum R^2 at ',num2str(optrsq)]);
text(range(range==optloc),Rsq(range==optloc),['\rightarrow ',num2str(optloc)]);xlabel('Shift');ylabel('R^2');saveas(gcf,'Alg-3 r2.png');