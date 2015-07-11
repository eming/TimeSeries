function [center,coeff,cycleError]=fuzzyClustering21Centers(devices, centerCount, exponent, iterationCount, rowDataLength)
    devicesKeys = keys(devices);
    [~, m] = size(devicesKeys);
    coeff=NaN*ones( m,centerCount,7);
    center=NaN*ones(centerCount, rowDataLength/7,7);
    cycleError=nan*ones(m,7);
    dayDataLength=rowDataLength/(7*12);
    weekDataLength=rowDataLength/12;
    for weekDay=1:7
        Y=NaN*ones(m,rowDataLength / 7);
        for i=1:m
            deviceData = devices(devicesKeys{i});
            begin = (weekDay - 1)*dayDataLength + 1;
            for weekNumber=1:12
                data = deviceData(begin + (weekNumber - 1)*weekDataLength:begin + (weekNumber - 1)*weekDataLength + dayDataLength - 1);
                Y(i,(weekNumber-1)*dayDataLength+1:weekNumber*dayDataLength) = data;
            end;
        end;

        [c,U,objFunction]=fcm(Y,centerCount,[exponent; iterationCount; nan; nan]);
        center(:,:,weekDay)=c;
    %     [U,center,~]=myFcm(Y,iterationCount,centerCount,exponent); 
    %      figure;
    %      plot(objFunction);

        for i=1:m
            coeff(i,:,weekDay)=(c'\Y(i,:)')';
        end;
        threshold=10;
        badExamplesToPlotCountForEachWeekDay=0;
        badDevices=[];
        for i=1:m
            cycleError(i,weekDay) = 100*mean(abs(coeff(i,:,weekDay)*c - Y(i,:)))/(max(Y(i,:))-min(Y(i,:)));
            if cycleError(i,weekDay)>threshold
                if ~ismember(i,badDevices)
                    badDevices=[badDevices i];
                end;
                if badExamplesToPlotCountForEachWeekDay>0
                    badExamplesToPlotCountForEachWeekDay=badExamplesToPlotCountForEachWeekDay-1;
                    key=devicesKeys{i};
                    figure('name',strcat('bad device #',num2str(key),' week day #',num2str(weekDay)),'NumberTitle','off');
                    hold on;
                    plot(Y(i,:));
                    plot(coeff(i,:,weekDay)*c);
                    title(num2str(cycleError(i)));
                    hold off;
                end;
            end;    
            
        end;
    end;
end