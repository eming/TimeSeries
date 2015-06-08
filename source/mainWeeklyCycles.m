close all
clear all
load('devices.mat');
load('dbScanCenters.mat');
%normalization
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
%make resolution, last column for each device is mean weakly cycle
stepForResolution = 4;
devices = weeklyMeanData(devices,stepForResolution);
% % removing  outliers
% P=NaN*ones(672/stepForResolution,1003*13);
% for i=1:m
%     deviceData = devices(deviceKeys{i});
%     P(:,((i-1)*13+1):i*13)=deviceData(:,1:13);
% end;
% minPts=30;
% E=norm(P(:,1)-P(:,2));
% [C, ptsC, centres] = dbscan(P, E, minPts);
satisfying = find(~ptsC);
[l,~]=size(satisfying);
outliers=[];
for k=1:l
    i=ceil(satisfying(k)/13);
    if ~ismember(i,outliers)
        outliers=[outliers i];        
        remove(devices,deviceKeys{i});
    end;
end;
deviceKeys = keys(devices);
%clustering and reconstruction
centerCount=10;
iterationCount=100;
exponent=2;
isLeastSquareSolution = true;
[center,coeff,meanWeekError,weekError,deviceParams] = fuzzyClustering(devices, centerCount,exponent,iterationCount,isLeastSquareSolution);
%plot centers
figure('units','normalized','outerposition',[0 0 1 1]);
for i=1:centerCount
    subplot(ceil(centerCount/2),2,i);
    plot(center(i,:));
end;
%mean weekly cycle error graph    
threshold=5;
meanWeekError = sort(meanWeekError);
figure;
logicalIndex=meanWeekError < threshold;
satisfying = find(logicalIndex);
size(satisfying)/size(meanWeekError)
plot(meanWeekError(satisfying));
%weekly cycle error graph
figure;
logicalIndex=weekError < threshold;
satisfying = find(logicalIndex);
size(satisfying)/size(weekError)
plot(sort(weekError(satisfying)));
%graphs of weekly cycles with big error  
satisfying = find(~logicalIndex);
size(satisfying)
[~,l]=size(satisfying);
badDevices=[];
for k=1:min(10,l)
    i=ceil(satisfying(k)/13);
    if ~ismember(i,badDevices)
        badDevices=[badDevices i];
    end;
%     deviceData=devices(deviceKeys{i});
%     j=mod(satisfying(k),13);
%     if j==0
%         j=13;
%     end;
%     deviceParam=deviceParams{i};
%     reconstructed=deviceParam(:,j)'*center;
%     figure;
%     plot(1:672/stepForResolution,deviceData(:,j),'r',1:672/stepForResolution,reconstructed,'g');
%     errorTitle = 100*mean(abs(reconstructed - deviceData(:,j)'))/(max(deviceData(:,j))-min(deviceData(:,j)));
%     title(num2str(errorTitle));
end;
% %20 weekly cycles(one per device) with small errors
for k=1:20
    if ismember(k,badDevices)
        continue;
    end;
    figure;
    params=deviceParams{k};
    for i=1:centerCount
        subplot(centerCount/2,2,i);
        plot(params(i,:));
    end;
end;
% %draw all week cycle graphs for a defined key
% deviceData=devices(deviceKeys{16});
% for i=1:13
%     figure;
%     plot(deviceData(:,i));
% end;