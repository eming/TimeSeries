% close all
% clear all
load('devices.mat');

weekCount = 10;
devicesKeys = keys(devices);
[~, m] = size(devicesKeys);
serie = nan*ones(m,weekCount*672);
for i=1:m
    deviceData = devices(devicesKeys{i});
    mergeData = nan*ones(1,weekCount*672);
    for j=1:weekCount
        mergeData((j-1)*672 + 1:j*672) = deviceData(:,j)';
    end;
%     mergeData = smooth(mergeData,11);
    minValue=min(mergeData);
    maxValue=max(mergeData);
    mergeData = 100*(mergeData-minValue)/(maxValue-minValue);
    serie(i,:) = mergeData;
end;

centerCount = 10;
iterationCount=50;
exponent=2;
% [center,U,J]=fcm(serie,centerCount,[exponent; iterationCount; nan; nan]);

figure('units','normalized','outerposition',[0 0 1 1]);
for i=1:centerCount
    subplot(centerCount/2,2,i);
    plot(center(i,:));
end;

deviceParam = nan*ones(m, centerCount);
deviceError = nan*ones(1,m);
for i=1:m
    coeff = (center'\serie(i,:)')';
    deviceParam(i,:) = coeff;
    deviceError(1,i) = 100*mean(abs((coeff*center - serie(i,:))))/(max(serie(i,:))-min(serie(i,:)));
end;

threshold=10;
deviceError = sort(deviceError);
figure;
logicalIndex=deviceError<threshold;
satisfying=find(logicalIndex);
size(satisfying)
plot(deviceError(satisfying));