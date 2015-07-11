close all;
clear all;
warning('off','MATLAB:rankDeficientMatrix');
load('devicesRowDataAndExternalRowData.mat');
load('dbScanCenters12Week.mat');
deviceKeys = keys(devices);
[~,m]=size(deviceKeys);
%length of the data will be used(maybe some of them will be skiped for testing phase)
rowDataLength=4*24*7*12;
%all data length
allDataLength=4*24*7*13;
stepForResolution = 1;
%normalization globally
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
%make resolution
devices = makeResolutionForCycleData(devices,stepForResolution);
% removing  outliers
P=NaN*ones(rowDataLength/stepForResolution,m);
for i=1:m
    deviceData = devices(deviceKeys{i});
    P(:,i)=deviceData';
end;
%*1 for week , *0.5 for all weeks, *2 for day
% E=norm(P(:,1)-P(:,2))*0.5;
% minPts=30;
% [C, ptsC, dbscanCenter] = dbscan(P, E, minPts);
satisfying = find(~ptsC);
[l,~]=size(satisfying);
outliers=[];
for k=1:l
    i=ceil(satisfying(k));
    if ~ismember(i,outliers)
        outliers=[outliers i];        
        remove(devices,deviceKeys{i});
    end;
end;
deviceKeys = keys(devices);
[~,m]=size(deviceKeys);
%clustering and reconstruction
centerCount=3;
iterationCount=50;
exponent=2;
[center,coeff,cycleError] = fuzzyClustering21Centers(devices, centerCount,exponent,iterationCount, rowDataLength);
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