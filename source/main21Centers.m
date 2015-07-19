close all;
clear all;
warning('off','MATLAB:rankDeficientMatrix');
%load devices data
load('devicesRowDataAndExternalRowData.mat');
%load('dbScanCenters12Week.mat');
deviceKeys = keys(devices);
[~,m]=size(deviceKeys);
%length of the data will be used(maybe some of them will be skiped for testing phase)
rowDataLength=4*24*7*12;
%all data length
allDataLength=4*24*7*13;
stepForResolution = 1;
%normalization :let oldRowData be one device data, then newRowData[i]=(oldRowData[i]-minOfRowData)/(maxOfRowData-minOfRowData)
data=NaN*ones(m,allDataLength);
for i=1:m
    deviceData = devices(deviceKeys{i});
    minValue=min(deviceData);
    maxValue=max(deviceData);
    deviceData = 100*(deviceData-minValue)/(maxValue-minValue);
    data(i,:)=deviceData;
    deviceData=deviceData(1:rowDataLength);
    devices(deviceKeys{i}) = deviceData;
end;
%make resolution: 15 minutes, hourly, dayly...
devices = makeResolutionForCycleData(devices,stepForResolution);
% removing  outliers with dbScan algorithm
P=NaN*ones(rowDataLength/stepForResolution,m);
for i=1:m
    deviceData = devices(deviceKeys{i});
    P(:,i)=deviceData';
end;
%*1 for week , *0.5 for all weeks, *2 for day
E=norm(P(:,1)-P(:,2))*0.5;
minPts=30;
[C, ptsC, dbscanCenter] = dbscan(P, E, minPts);
satisfying = find(~ptsC);
[l,~]=size(satisfying);
%noisy data identified by dbScan as clusterId=0 supposed to be outlier
outliers=[];
for k=1:l
    i=ceil(satisfying(k));
    if ~ismember(i,outliers)
        outliers=[outliers i];        
        %removing outliers
        remove(devices,deviceKeys{i});
    end;
end;
%updating deviceKeys variable and m - count of non-outlier devices
deviceKeys = keys(devices);
[~,m]=size(deviceKeys);
%clustering and reconstruction
centerCount=3;
iterationCount=50;
exponent=2;
weekCount=rowDataLength/(4*24*7);
%threshold used inside fuzzyClustering21Centers, we are plotting some
%data whos reconstruction error is greater than threshold just to get
%filling about bad reconstruction cases
threshold=10;
[center,coeff,cycleError] = fuzzyClustering21Centers(devices, centerCount,exponent,iterationCount, rowDataLength, weekCount, threshold);
[centerCount,~]=size(center);
%plot centers
figure('name','centers','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
for weekDay=1:7
    for i=1:centerCount
        subplot(7,centerCount,(weekDay-1)*centerCount + i);
        plot(center(i,:,weekDay));
    end;
end;
%cycle error graph
for weekDay=1:7
    figure('name',strcat('cycle error ',num2str(weekDay)),'NumberTitle','off');
    mean(cycleError(:,weekDay))
    hold on;
    plot(100/m:100/m:100,sort(cycleError(:,weekDay)));
    plot(100/m:100/m:100,ones(1,m)*5);
    plot(100/m:100/m:100,ones(1,m)*10);
    hold off;
end;