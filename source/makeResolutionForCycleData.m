% make resolution
function [devices]=makeResolutionForCycleData(devices, stepForResolution)
    devicesKeys = keys(devices);
    [~, m] = size(devicesKeys);
    for i=1:m
        deviceData = devices(devicesKeys{i});
        [~, dataLength] = size(deviceData);
        
        sumData = nan*ones(1,dataLength/stepForResolution);
        for j=1:(dataLength/stepForResolution)
           sumData(j) = sum(deviceData((j-1)*stepForResolution+1:j*stepForResolution));
        end;
        devices(devicesKeys{i}) = sumData;
    end;
end