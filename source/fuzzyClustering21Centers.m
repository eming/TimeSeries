%for each week day we are doing clustering with 3 cluster centers
%for each clustering we use concatanated corresponding week day data
%throughout 12 weeks(saving 13 week for validation of forecasting quality)of
%each device(for each device we have 4*24*12 length row data for
%clustering) as items to cluster. As result we return all centers, all
%reconstruction parameters for each item for clustering, all reconstruction
%errors.
function [center,coeff,cycleError]=fuzzyClustering21Centers(devices, centerCount, exponent, iterationCount, rowDataLength, weekCount, threshold)
    devicesKeys = keys(devices);
    [~, m] = size(devicesKeys);
    coeff=NaN*ones( m,centerCount,7);
    centerDataLength=rowDataLength/7;
    center=NaN*ones(centerCount, centerDataLength,7);
    cycleError=nan*ones(m,7);
    dayDataLength=rowDataLength/(7*weekCount);
    weekDataLength=rowDataLength/weekCount;
    for weekDay=1:7
        %Y is matrix each row is a device data for corresponding week day
        %therefore each item is 7 times shorter from row data for a device
        Y=NaN*ones(m,rowDataLength / 7);
        for i=1:m
            deviceData = devices(devicesKeys{i});
            begin = (weekDay - 1)*dayDataLength + 1;
            for weekNumber=1:weekCount
                data = deviceData(begin + (weekNumber - 1)*weekDataLength:begin + (weekNumber - 1)*weekDataLength + dayDataLength - 1);
                Y(i,(weekNumber-1)*dayDataLength+1:weekNumber*dayDataLength) = data;
            end;
        end;
        %csvwrite(strcat('weekday',num2str(weekDay),'.csv'),Y');
        [c,U,objFunction]=fcm(Y,centerCount,[exponent; iterationCount; nan; nan]);
        %[~,c]=kmeans(Y,centerCount);
        center(:,:,weekDay)=c;
%         [U,center,~]=myFcm(Y,iterationCount,centerCount,exponent); 
%         figure;
%         plot(objFunction);
        %each row of coeff(:,:,weekDay) corresponds for reconstruction coefficients
        %for the specific week day and specific device 
        for i=1:m
            coeff(i,:,weekDay)=(c'\Y(i,:)')';
        end;
        badExamplesToPlotCountForEachWeekDay=0;
        for i=1:m
%           If “RowData” is data serie for a spesific week day 
%           then device reconstruction error for one data point in rowData is 
%           (reconstructedRowData[i]-realRowData[i])/(maxRowData-minRowData) .Max and Min taken from RowData. 
%           Overall rowData reconstruction error is mean value of absolut values of all point errors multiplied by 100(interpretation of percentage)
            cycleError(i,weekDay) = 100*mean(abs(coeff(i,:,weekDay)*c - Y(i,:)))/(max(Y(i,:))-min(Y(i,:)));
            %just plot badExamplesToPlotCountForEachWeekDay number bad
            %reconstruction data for each week day clustering process
            if cycleError(i,weekDay)>threshold
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