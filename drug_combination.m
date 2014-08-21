%% The program reads from an input data file and imports the content into a
%% cell. The number of unique patient ID's or total number of patients is
%% estimated using the unique() function. For each patient, the drugs
%% administered on different days are stored in a variable. When more than
%% one drug is administered on the same day, the combination of drugs is printed. 
%% My data base consists of 5 drugs - fluorouracil, oxaliplatin, 
%% 5FU, B and C. I tested the program twice- once with 3 patients ID's and
%% the second time, with 4 patient ID's. The attached text file
%% 'drug_history.txt' has three ID's.


clc;close all;clear all;

fid = fopen('drug_history.txt','rt');                                               % Load data file.
data = textscan(fid, '%s %s %s', 'Delimiter',',', 'CollectOutput',1);               % Scan data separated by comma into individual columns
fclose(fid);

pt_id_set = unique(data{1}(:,1));                                                   % Find total number of patients

pt{length(pt_id_set)}={};                                                           % Initial a 'pt' cell which has date and drug information about each patient

for y=1:length(pt_id_set)
    z=1;
    for x=1:length(data{1})
        if cell2mat(data{1}(x,1))==pt_id_set{y}
            pt{y}(z,1) = data{1}(x,2);                                              % Store data in 1st column
            pt{y}(z,2) = data{1}(x,3);                                              % Store drug information in 2nd column
            z=z+1;
        end
    end
end

for y=1:length(pt_id_set)
    b=0;m=0;n=0;dupRows=0;printRows=0;dupRowValues=0;
    [b,m,n] = unique(pt{y}(:,1), 'first');                                          % Finds individual dates when each patient was administered drug(s)
    dupRows = setdiff(1:length(pt{y}(:,1)), m);                                     % Estimates dates when more than one drug was given (duplicate rows of dates)
    printRows = sort([dupRows-1 dupRows],'ascend');
    dupRowValues = char(pt{y}(printRows,2));                                        % Stores drugs given on the same day
    line1 = 'Drugs Administered together for Patient-%1.0f : \n';
    fprintf(line1,y);
    for x=1:2:size(dupRowValues,1)
        line2 = '%s, %s \n\n';                                                      % Prints drugs administered on each day 
        fprintf(line2,dupRowValues(x,:),dupRowValues(x+1,:));
    end
end