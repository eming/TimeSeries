function [center,coeff,meanCycleError,cycleError,deviceParams]=fuzzyClustering(devices, centerCount,exponent,iterationCount, cycleCount, dataLength, isOriginalsClustering, isLinearDependencesSkiped)
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
%      figure;
%      plot(objFunction);
    if isLinearDependencesSkiped
        i=1;
        if cycleCount==13 && cycleCount==1
            eps2=20;
        else
            eps2=10000;
        end;
        while i<centerCount
            deletingRows=[];
            for j=(i+1):centerCount
                diff=center(i,:)-center(j,:);
                dist2=diff*diff';
                dist2
                if dist2<eps2
                    deletingRows=[deletingRows j];
                end;
            end;
            center(deletingRows,:)=[];
            [centerCount,~]=size(center);
            i=i+1;
        end;
    end;
    %only for mean clustering
    coeff=NaN*ones(m,centerCount);
    for i=1:m
        coeff(i,:)=(center'\Y(i,:)')';
    end;

    meanCycleError=nan*ones(1,m);
    for i=1:m
        meanCycleError(i) = 100*mean(abs(coeff(i,:)*center - Y(i,:)))/(max(Y(i,:))-min(Y(i,:)));
    end;
    
    cycleError=nan*ones(1,m*cycleCount);
    deviceParams=cell(1,m);
    for i=1:m
        deviceParam=nan*ones(centerCount,cycleCount);
        deviceData = devices(devicesKeys{i});
        for j=1:cycleCount
            cycleCoeff = (center'\deviceData(:,j))';
            deviceParam(:,j) = cycleCoeff';
            cycleError((i-1)*cycleCount + j) = 100*mean(abs(cycleCoeff*center - deviceData(:,j)'))/(max(deviceData(:,j))-min(deviceData(:,j)));
        end;
        deviceParams{i}=deviceParam;
    end;
end