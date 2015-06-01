function [center,coeff,meanWeekError,weekError,deviceParams]=fuzzyClustering(devices, centerCount,exponent,iterationCount, isLeastSquareSolution)
    Y = [];
    devicesKeys = keys(devices);
    [~, m] = size(devicesKeys);
    for i=1:m
        deviceData = devices(devicesKeys{i});
        Y(i,:) = deviceData(:,14);
    end;

    %[center,U,~]=fcm(Y,centerCount,[exponent; iterationCount; nan; nan]);
    [U,center,~]=myFcm(Y,iterationCount,centerCount,exponent);
    
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
        meanWeekError(i) = 100*mean(abs((coeff(i,:)*center - Y(i,:))))/(max(Y(i,:))-min(Y(i,:)));
    end;
    
    weekError=nan*ones(1,m*13);
    deviceParams=cell(1,m);
    for i=1:m
        deviceParam=nan*ones(centerCount,13);
        deviceData = devices(devicesKeys{i});
        for j=1:13
            weekCoeff = (center'\deviceData(:,j))';
            deviceParam(:,j) = weekCoeff';
            weekError((i-1)*13 + j) = 100*mean(abs((weekCoeff*center - deviceData(:,j)')))/(max(deviceData(:,j))-min(deviceData(:,j)));
        end;
        deviceParams{i}=deviceParam;
    end;
end