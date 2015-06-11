close all
clear all
load('devicesRowDataAndExternalRowData.mat');
load('dbScanCentersDaylyCycle.mat');
deviceKeys = keys(devices);
[~,m]=size(deviceKeys);
rowDataLength=8736;
cycleLength = 24*4;
stepForResolution = 4;
cycleCount=rowDataLength/cycleLength;
%normalization
for i=1:m
    deviceData = devices(deviceKeys{i}); 
    if cycleCount==1
        % if ten week cycle normalizing globally
        minValue=min(deviceData);
        maxValue=max(deviceData);
        deviceData = 100*(deviceData-minValue)/(maxValue-minValue);
    else           
        % else normalizing per week
        for j=1:rowDataLength/672
           minValue=min(deviceData((j-1)*672+1:j*672));
           maxValue=max(deviceData((j-1)*672+1:j*672));
           deviceData((j-1)*672+1:j*672) = 100*(deviceData((j-1)*672+1:j*672)-minValue)/(maxValue-minValue);
        end;
    end;
    devices(deviceKeys{i}) = deviceData;
end;
%make resolution&split row data to cycles
%last column for each device is mean cycle
devices = cycleMeanData(devices,stepForResolution,cycleLength);
% removing  outliers
P=NaN*ones(cycleLength/stepForResolution,m*cycleCount);
for i=1:m
    deviceData = devices(deviceKeys{i});
    P(:,((i-1)*cycleCount+1):i*cycleCount)=deviceData(:,1:cycleCount);
end;
%*1 for weeks and 10 weeks, *2 for days
% E=norm(P(:,1)-P(:,2));
% minPts=30;
% [C, ptsC, centres] = dbscan(P, E, minPts);
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
[~,m]=size(deviceKeys);
%clustering and reconstruction
centerCount=10;
iterationCount=100;
exponent=2;
isLeastSquareSolution = true;
[center,coeff,meanCycleError,cycleError,deviceParams] = fuzzyClustering(devices, centerCount,exponent,iterationCount,isLeastSquareSolution,cycleCount);
%plot centers
figure('name','centers','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
for i=1:centerCount
    subplot(ceil(centerCount/2),2,i);
    plot(center(i,:));
end;
%mean cycle error graph    
threshold=5;
meanCycleError = sort(meanCycleError);
figure('name','mean cycle error','NumberTitle','off');
logicalIndex=meanCycleError < threshold;
satisfying = find(logicalIndex);
size(satisfying)/size(meanCycleError)
plot(meanCycleError(satisfying));
%weekly cycle error graph
figure('name','cycle error','NumberTitle','off');
logicalIndex=cycleError < threshold;
satisfying = find(logicalIndex);
size(satisfying)/size(cycleError)
mean(cycleError)
plot(sort(cycleError(satisfying)));
%graphs of cycles with big error  
satisfying = find(~logicalIndex);
[~,l]=size(satisfying);
badDevices=[];
badExamplesToPlotCount=10;
for k=1:l
    i=ceil(satisfying(k)/cycleCount);
    if ~ismember(i,badDevices)
        badDevices=[badDevices i];
    end;
    if badExamplesToPlotCount>0
        badExamplesToPlotCount=badExamplesToPlotCount-1;
        key=deviceKeys{i};
        deviceData=devices(key);
        j=mod(satisfying(k),cycleCount);
        if j==0
            j=cycleCount;
        end;
        deviceParam=deviceParams{i};
        reconstructed=deviceParam(:,j)'*center;
        figure('name',strcat('key = ',num2str(key)),'NumberTitle','off');
        plot(1:cycleLength/stepForResolution,deviceData(:,j),'r',1:cycleLength/stepForResolution,reconstructed,'g');
        errorTitle = 100*mean(abs(reconstructed - deviceData(:,j)'))/(max(deviceData(:,j))-min(deviceData(:,j)));
        title(num2str(errorTitle));
    end;
end;
%make same resolution for externalData
[l,~]=size(externalData);
%row external data resolution is hourly not 15 min
externalDataStepForResolution=(cycleLength/4);
newLength=l/externalDataStepForResolution;
data=NaN*ones(newLength,5);
for j=1:newLength
   data(j,:)=mean(externalData((j-1)*externalDataStepForResolution+1:j*externalDataStepForResolution,:),1);
end;
externalData=data;
%3 cycles(one per device) with small errors
k=1;
goodDevicesToPlotCount=0;
if cycleCount~=1
    while goodDevicesToPlotCount>0 && k<=m
        if ismember(k,badDevices)
            k=k+1;
            continue;
        end;
        goodDevicesToPlotCount=goodDevicesToPlotCount-1;
        if cycleCount==13 || cycleCount==1
            step=1;
        else
            step=7;
        end;
        %if daylyCycle then show each day of week in seperate figure
        for t=1:step
            periodic=t:step:cycleCount;
            figure('name',num2str(t),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
            params=deviceParams{k};
            for i=1:centerCount
               subplot((centerCount/2)+3,2,i);
               plot(params(i,periodic));
               title(strcat(num2str(i),'-th center'));
            end;
            subplot((centerCount/2)+3,2,centerCount+1);
            plot(externalData(periodic,1));
            title('TEMP');
            subplot((centerCount/2)+3,2,centerCount+2);
            plot(externalData(periodic,2));
            title('HUMIDITY');
            subplot((centerCount/2)+3,2,centerCount+3);
            plot(externalData(periodic,3));
            title('PRESSURE');
            subplot((centerCount/2)+3,2,centerCount+4);
            plot(externalData(periodic,4));
            title('WIND SPEED');
            subplot((centerCount/2)+3,2,centerCount+5);
            plot(externalData(periodic,5));
            title('RAINFALL');
        end;
        k=k+1;
    end;
end;