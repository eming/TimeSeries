load('devices.mat');

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
    
threshold=20;
meanWeekError = sort(meanWeekError);
figure;
logicalIndex=meanWeekError < threshold;
satisfying = find(logicalIndex);
size(satisfying)
plot(meanWeekError(satisfying));

figure;
logicalIndex=weekError < threshold;
satisfying = find(logicalIndex);
size(satisfying)
plot(sort(weekError(satisfying)));

figure;
satisfying = find(~logicalIndex);
i=ceil(satisfying(end)/13);
devicesKeys = keys(devices);
deviceData=devices(devicesKeys{i});
j=mod(satisfying(end),13)+1;
deviceParam=deviceParams{i};
reconstructed=deviceParam(:,j)'*center;
plot(1:672/stepForResolution,deviceData(:,j),'r',1:672/stepForResolution,reconstructed,'g');

figure;
testId=200;
params=deviceParams{testId};
for i=1:centerCount
    subplot(centerCount/2,2,i);
    plot(params(i,:));
end;

deviceData=devices(devicesKeys{testId});
for i=1:13
    figure;
    plot(deviceData(:,i));
end;