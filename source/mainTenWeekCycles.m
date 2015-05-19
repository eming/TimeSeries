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
    serie(i,:) = mergeData;
end;

centerCount = 10;
iterationCount=100;
exponent=2;
[center,U,J]=fcm(serie,centerCount,[exponent; iterationCount; nan; nan]);

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
    deviceError(i) = 100*mean(abs((coeff*center - serie(i,:))./serie(i,:)));
end;

threshold=20;
deviceError = sort(deviceError);
figure;
logicalIndex=deviceError<threshold;
satisfying=find(logicalIndex);
size(satisfying)
plot(deviceError(satisfying));