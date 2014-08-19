clc;close all;clear all; 

%--------------------------------------------------------------------GA Parameters
fvcm=xlsread('fvcm122.xlsx');
q=xlsread('fef2.xlsx');
npar=1;                                                                     % number of optimization variables
varhi=3.5445;varlo=3.349;
varhip=60; varlop=25;                                                       % variable limits
varlor=2.94; varhir=5.22;
e=10;
maxit=500;                                                                  % max number of iterations
mincost=0.0;                                                                % minimum cost
popsize=494;                                                                % set population size
mutrate=0.2;                                                                % set mutation rate
selection=0.4;                                                              % fraction of population retained
Nt=npar;                                                                    % continuous parameter GA Nt=#variables
keep=floor(selection*popsize);                                              % population members that survive and go to next iteration/generation
eliminate=popsize-keep;
nmut=ceil((popsize-1)*Nt*mutrate);                                          % total number of mutations

%-------------------------------------------------------------------Creating the initial population
iga=0;                                                                      % generation counter initialized

par=(varhi-varlo)*rand(popsize,npar)+varlo; 
parp=(varhip-varlop)*rand(popsize,npar)+varlop; 
parr=(varhir-varlor)*rand(popsize,npar)+varlor; 
fvcs=(parp-(parr.*q))/e;                                                    % p=(e*v)+(r*q)  % par=v=(p-(r*q))/e                
ff='testfunction';
cost=feval(ff,parp,parr);                                                   % calculates population cost using ff
[cost,ind]=sort(cost);                                                      % min cost in element 1
parp=parp(ind,:);                                                           % sort continuous
parr=parr(ind,:);


%-------------------------------------------------------------------- Iterate through generations
while iga<maxit 
    iga=iga+1;                                                              % increments generation counter

%-------------------------------------------------------------------- Pair and mate
    M=ceil((popsize-eliminate)/2);                                          % number of matings
    pick1=rand(1,M);                                                        % mate #1
    pick2=rand(1,M);                                                        % mate #2

    prob=flipud([1:keep]'/sum([1:keep]));                                   % weights chromosomes indicate preference / importance %only the top Nkeep number of chrosomes are considered for mating
    odds=[0 cumsum(prob(1:keep))'];                                         % probability distribution function
    
    %----------------------------------------------------------------RANDOM SELECTION OF CHROMOSOMES FOR MATING
    ic=1;
    while ic<=M                                                             
        for id=2:keep+1                      
            if pick1(ic)<=odds(id) & pick1(ic)>odds(id-1)       
                ma(ic)=id-1;                                                % ma and pa contain the indicies of the chromosomes that will mate
            end
            if pick2(ic)<=odds(id) & pick2(ic)>odds(id-1)
                pa(ic)=id-1;                                                % ma and pa contain the indicies of the chromosomes that will mate
            end
        end
        ic=ic+1;
    end

    %--------------------------------------------------------------- Mating(single pt crossover)
    ix=1:2:keep;                                                            % index of mate #1=1,3,5,... %index of mate2=2,4,6,....
    xp=ceil(rand(1,M)*Nt);                                                  % point of corss-over 
    r=rand(1,M); 
    for ic=1:M
        xy=par(ma(ic),xp(ic))-par(pa(ic),xp(ic)); 
        par(keep+ix(ic),:)=par(ma(ic),:);                                   
        par(keep+ix(ic)+1,:)=par(pa(ic),:);                                 
        par(keep+ix(ic),xp(ic))=par(ma(ic),xp(ic))-r(ic).*xy;               % 1st offspring
        par(keep+ix(ic)+1,xp(ic))=par(pa(ic),xp(ic))+r(ic).*xy;             % 2nd offspring
        if xp(ic)<npar 
            par(keep+ix(ic),:)=[par(keep+ix(ic),1:xp(ic)); par(keep+ix(ic)+1,xp(ic)+1:npar)];
            par(keep+ix(ic)+1,:)=[par(keep+ix(ic)+1,1:xp(ic)); par(keep+ix(ic),xp(ic)+1:npar)];
        end 
    end
%--------------------------------------------------------------------Mutate the population
    mrow=sort(ceil(rand(1,nmut)*(popsize-1))+1); 
    mcol=ceil(rand(1,nmut)*Nt); 
    for ii=1:nmut
        par(mrow(ii),mcol(ii))=(varhi-varlo)*rand+varlo;                    % mutation step
    end 

%--------------------------------------------------------------------Cost computation
    cost=0.5*(fvcm-fvcs).^2;                                                %The new offspring and mutated chromosomes are evaluated

    [cost,ind]=sort(cost);                                                  % Sort the costs and associated parameters
    par=par(ind,:);

%--------------------------------------------------------------------Stopping criteria
    if iga>=maxit | cost(1)<mincost 
        break
    end
    [iga cost(1)];
end 

%--------------------------------------------------------------------Visualization of results
disp(['population size = ' num2str(popsize)  '     number of generations=' num2str(iga) '       best cost=' num2str(cost(1)) ]);
msgbox(['PREDICTED FVC BY OPTIMIZATION:  ' num2str(par(1,:))]);

figure;
sorta=sort(cost,'descend');
plot(sorta);
xlabel('generations');
ylabel('cost');
title('OPTIMIZATION');