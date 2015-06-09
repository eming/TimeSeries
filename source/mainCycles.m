close all
clear all
load('devicesRowData.mat');
%load('dbScanCenters.mat');
%normalization
deviceKeys = keys(devices);
[~,m]=size(deviceKeys);
rowDataLength=0;
for i=1:m
    deviceData = devices(deviceKeys{i});
    [~,rowDataLength] = size(deviceData);
    for j=1:rowDataLength/672
       minValue=min(deviceData((j-1)*672+1:j*672));
       maxValue=max(deviceData((j-1)*672+1:j*672));
       deviceData((j-1)*672+1:j*672) = 100*(deviceData((j-1)*672+1:j*672)-minValue)/(maxValue-minValue);
    end;
    devices(deviceKeys{i}) = deviceData;
end;
%make resolution, last column for each device is mean weakly cycle
cycleLength = 24*4*7;
stepForResolution = 4;
devices = cycleMeanData(devices,stepForResolution,cycleLength);
cycleCount=rowDataLength/cycleLength;
% removing  outliers
P=NaN*ones(cycleLength/stepForResolution,m*cycleCount);
for i=1:m
    deviceData = devices(deviceKeys{i});
    P(:,((i-1)*cycleCount+1):i*cycleCount)=deviceData(:,1:cycleCount);
end;
minPts=30;
% *1 for weeks, *2 for days
E=norm(P(:,1)-P(:,2))*2;
[C, ptsC, centres] = dbscan(P, E, minPts);
satisfying = find(~ptsC);
[l,~]=size(satisfying);
outliers=[];
for k=1:l
    i=ceil(satisfying(k)/cycleCount);
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
[center,coeff,meanCycleError,cycleError,deviceParams] = fuzzyClustering(devices, centerCount,exponent,iterationCount,isLeastSquareSolution,cycleCount);
%plot centers
figure('units','normalized','outerposition',[0 0 1 1]);
for i=1:centerCount
    subplot(ceil(centerCount/2),2,i);
    plot(center(i,:));
end;
%mean weekly cycle error graph    
threshold=12.5;
meanCycleError = sort(meanCycleError);
figure;
logicalIndex=meanCycleError < threshold;
satisfying = find(logicalIndex);
size(satisfying)/size(meanCycleError)
plot(meanCycleError(satisfying));
%weekly cycle error graph
figure;
logicalIndex=cycleError < threshold;
satisfying = find(logicalIndex);
size(satisfying)/size(cycleError)
plot(sort(cycleError(satisfying)));
%graphs of weekly cycles with big error  
satisfying = find(~logicalIndex);
size(satisfying)
[~,l]=size(satisfying);
badDevices=[];
for k=1:min(10,l)
    i=ceil(satisfying(k)/cycleCount);
    if ~ismember(i,badDevices)
        badDevices=[badDevices i];
    end;
    deviceData=devices(deviceKeys{i});
    j=mod(satisfying(k),cycleCount);
    if j==0
        j=cycleCount;
    end;
    deviceParam=deviceParams{i};
    reconstructed=deviceParam(:,j)'*center;
    figure;
    plot(1:cycleLength/stepForResolution,deviceData(:,j),'r',1:cycleLength/stepForResolution,reconstructed,'g');
    errorTitle = 100*mean(abs(reconstructed - deviceData(:,j)'))/(max(deviceData(:,j))-min(deviceData(:,j)));
    title(num2str(errorTitle));
end;
% %20 weekly cycles(one per device) with small errors
% for k=1:20
%     if ismember(k,badDevices)
%         continue;
%     end;
%     figure;
%     params=deviceParams{k};
%     for i=1:centerCount
%         subplot(centerCount/2,2,i);
%         plot(params(i,:));
%     end;
% end;
% %draw all week cycle graphs for a defined key
% deviceData=devices(deviceKeys{16});
% for i=1:cycleCount
%     figure;
%     plot(deviceData(:,i));
% end;