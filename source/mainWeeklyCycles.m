close all
clear all
load('devices.mat');

deviceKeys = keys(devices);
[~,m]=size(deviceKeys);
for i=1:m
    deviceData = devices(deviceKeys{i});
    for j=1:13 
        minValue=min(deviceData(:,j));
        maxValue=max(deviceData(:,j));
        deviceData(:,j) = 100*(deviceData(:,j)-minValue)/(maxValue-minValue);
    end;
    devices(deviceKeys{i}) = deviceData;
end;

stepForResolution = 4;
devices = weeklyMeanData(devices,stepForResolution);

centerCount=10;
iterationCount=100;
exponent=2;
isLeastSquareSolution = false;
[center,coeff,meanWeekError,weekError,deviceParams] = fuzzyClustering(devices, centerCount,exponent,iterationCount,isLeastSquareSolution);

figure('units','normalized','outerposition',[0 0 1 1]);
for i=1:centerCount
    subplot(centerCount/2,2,i);
    plot(center(i,:));
end;
    
threshold=25;
meanWeekError = sort(meanWeekError);
figure;
logicalIndex=meanWeekError < threshold;
satisfying = find(logicalIndex);
size(satisfying)
plot(meanWeekError(satisfying));

figure;
logicalIndex=weekError < threshold;
satisfying = find(logicalIndex);
plot(sort(weekError(satisfying)));

satisfying = find(~logicalIndex);
size(satisfying)
[~,l]=size(satisfying);
for k=1:10
    i=ceil(satisfying(k)/13);
    deviceData=devices(deviceKeys{i});
    j=mod(satisfying(k),13)+1;
    deviceParam=deviceParams{i};
    reconstructed=deviceParam(:,j)'*center;
    figure;
    plot(1:672/stepForResolution,deviceData(:,j),'r',1:672/stepForResolution,reconstructed,'g');
end;
figure;
testId=200;
params=deviceParams{testId};
for i=1:centerCount
    subplot(centerCount/2,2,i);
    plot(params(i,:));
end;

% deviceData=devices(deviceKeys{testId});
% for i=1:13
%     figure;
%     plot(deviceData(:,i));
% end;