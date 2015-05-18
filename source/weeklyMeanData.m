function [devices]=weeklyMeanData(devices, stepForResolution)
    devicesKeys = keys(devices);
    [~, m] = size(devicesKeys);
    for i=1:m
        deviceData = devices(devicesKeys{i});
        sumData = nan*ones(672/stepForResolution, 14);
        for j=1:(672/stepForResolution)
            sumData(j,:) = sum(deviceData((j-1)*stepForResolution+1:j*stepForResolution,:),1);
        end;
        sumData(:,14) = mean(sumData, 2);
        devices(devicesKeys{i}) = sumData;
    end;
%     plot(1:672/stepForResolution, sumData(:,1),'g',1:672/stepForResolution, sumData(:,14),'r');
%     figure;
%     plot(1:672/stepForResolution, 100*(sumData(:,1) - sumData(:,14))/sumData(:,1));
end