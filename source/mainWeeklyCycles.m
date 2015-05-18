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
    
threshold=5;
meanWeekError = sort(meanWeekError);
figure;
satisfying = find(meanWeekError < threshold);
size(satisfying)
plot(meanWeekError(satisfying));

weekError = sort(weekError);
figure;
satisfying = find(weekError < threshold);
size(satisfying)
plot(weekError(satisfying));

figure;
params=deviceParams{1,1};
for i=1:centerCount
    subplot(centerCount/2,2,i);
    plot(params(i,:));
end;