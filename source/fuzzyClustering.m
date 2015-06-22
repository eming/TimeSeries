function [center,coeff,meanWeekError,weekError,deviceParams]=fuzzyClustering(devices, centerCount,exponent,iterationCount, isLeastSquareSolution, cycleCount, dataLength, isOriginalsClustering)
    devicesKeys = keys(devices);
    [~, m] = size(devicesKeys);
    if isOriginalsClustering
        Y=NaN*ones(m*cycleCount,dataLength);
    else
        Y=NaN*ones(m,dataLength);
    end;
    for i=1:m
        deviceData = devices(devicesKeys{i});
        if isOriginalsClustering
            Y((i-1)*cycleCount+1:i*cycleCount,:) = deviceData(:,1:cycleCount)';
        else
            Y(i,:) = deviceData(:,cycleCount+1);
        end;
    end;

    [center,U,objFunction]=fcm(Y,centerCount,[exponent; iterationCount; nan; nan]);
%     [U,center,~]=myFcm(Y,iterationCount,centerCount,exponent);   
     figure;
     plot(objFunction);
    
    if isLeastSquareSolution
        coeff=NaN*ones(m,centerCount);
        for i=1:m
            coeff(i,:)=(center'\Y(i,:)')';
        end;
    else
        coeff=U';
    end;
    
    meanWeekError=nan*ones(1,m);
    for i=1:m
        meanWeekError(i) = 100*mean(abs(coeff(i,:)*center - Y(i,:)))/(max(Y(i,:))-min(Y(i,:)));
    end;
    
    weekError=nan*ones(1,m*cycleCount);
    deviceParams=cell(1,m);
    for i=1:m
        deviceParam=nan*ones(centerCount,cycleCount);
        deviceData = devices(devicesKeys{i});
        for j=1:cycleCount
            weekCoeff = (center'\deviceData(:,j))';
            deviceParam(:,j) = weekCoeff';
            weekError((i-1)*cycleCount + j) = 100*mean(abs(weekCoeff*center - deviceData(:,j)'))/(max(deviceData(:,j))-min(deviceData(:,j)));
        end;
        deviceParams{i}=deviceParam;
    end;
end