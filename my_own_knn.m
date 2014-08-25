% This program was written to use the results from GA and classify the data
% into 4 groups depending on the severity of respiratory disorder.

clc;close all;clear all;

dataMatrix=xlsread('fvcmclassifytrain.xlsx');                               % training data set
queryMatrix=xlsread('fvcmclassifytest.xlsx');                               % testing data set
k=3;                                                                        % chosen value of 'k'
distance_mat=dist(dataMatrix(:,1:2), queryMatrix');                         % euclidean distance between points in the testing and training data set; each column corresponds to distance between one query point and all data points
[sortval sortpos] = sort(distance_mat,1,'ascend');
near_neigh = sortpos(1:3,:);                                                % choosing three nearest neighbors for each point in testing data set
numDataVectors = size(dataMatrix,1);
numQueryVectors = size(queryMatrix,1);
near_neigh_class = zeros(size(near_neigh));

for x=1:k
    for y=1:numQueryVectors
        near_neigh_class(x,y) = dataMatrix(near_neigh(x,y),16);             % storing the class of the nearest neighbors of each test point
    end
end
query_class=mode(near_neigh_class,1);                                       % test point assigned to same class as the majority of its nearest neighbors

classes = unique(query_class);                                              % plotting the results
ma = {'ko','gs','bd','rs'};
for i = 1:length(classes)
    pos = find(query_class==classes(i));
    plot(queryMatrix(pos,1),queryMatrix(pos,2),ma{i});axis equal;xlabel('FVC (L)');ylabel('FEF_2_5_-_7_5% (L/s)');legend('Normal','Mild Disorder','Moderate Disorder','Severe Disorder');
    title('Classfication Based on Severity of Respiratory Disorder');hold on
end