% make resolution and slices of cycle data
function [devices]=cycleMeanData(devices, stepForResolution, cycleLength)
    devicesKeys = keys(devices);
    [~, m] = size(devicesKeys);
    for i=1:m
        deviceData = devices(devicesKeys{i});
        [~, dataLength] = size(deviceData);
        slicesCount = dataLength / cycleLength;
        slicedDeviceData = nan*ones(cycleLength, slicesCount);
        for j=1:slicesCount
            slicedDeviceData(:,j)=deviceData((j-1)*cycleLength+1:j*cycleLength)';
        end;
        sumData = nan*ones(cycleLength/stepForResolution, slicesCount);
        for j=1:(cycleLength/stepForResolution)
           sumData(j,:) = sum(slicedDeviceData((j-1)*stepForResolution+1:j*stepForResolution,:),1);
        end;
        sumData(:,slicesCount + 1) = mean(sumData, 2);
        devices(devicesKeys{i}) = sumData;
    end;
%     plot(1:cycleLength/stepForResolution, sumData(:,1),'g',1:cycleLength/stepForResolution, sumData(:,slicesCount + 1),'r');
%     figure;
%     plot(1:cycleLength/stepForResolution, 100*(sumData(:,1) - sumData(:,slicesCount + 1))/sumData(:,1));
end