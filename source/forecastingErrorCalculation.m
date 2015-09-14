clear all;
close all;    
load('21center.mat');
badNumber=0;
threshold = 10;
fLength=96;
centersToUse=[1,2,3];
% data=data(outliers,:);
% data(outliers,:)=[];
[m,~]=size(data);
finalOutliers=[];
for weekDay=1:7
    centerIndex=weekDay;
    forecastingError=nan*ones(1,m);
    reconstructionError=nan*ones(1,m);
    centerDay=center(centersToUse,:,centerIndex);
    forecastedCentersDay=forecastedCenters(centersToUse,:,centerIndex);
    for i=1:m
        deviceData = data(i,:);
        begin = 1 + (weekDay-1)*96;
        for weekNumber=1:12
            portion = deviceData(begin + (weekNumber - 1)*672:begin + (weekNumber - 1)*672 + 96 - 1);
            dat((weekNumber-1)*96+1:weekNumber*96) = portion;
        end;
        coe=(centerDay'\dat')';
%         coe=coeff(i,:,weekDay);
        forecastingError(i) = 100*mean(abs(coe*forecastedCentersDay - data(i,(8064 + begin):(8064 + begin + fLength - 1))))/(max(data(i,:))-min(data(i,:)));
        reconstructionError(i) = 100*mean(abs(coe*centerDay - dat))/(max(data(i,:))-min(data(i,:)));
%         reconstructionError(i)=cycleError(i,weekDay);
        if forecastingError(i) > threshold
            if ~ismember(i,finalOutliers)
%                 figure('name',strcat(num2str(reconstructionError(i)),' reco error,', num2str(forecastingError(i)), ' fore error'),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
%                 plot(dat);
                finalOutliers = [finalOutliers i];
                badNumber=badNumber+1;
            end;
        end;
    end;
    disp(mod((1 + weekDay),7)+1);
%     disp(badNumber)
    disp(mean(forecastingError));
    disp(mean(reconstructionError));

%     [~,length]=size(forecastingError);
%     figure('name','forecasting error','NumberTitle','off');
%     hold on;
%     [forecastingError,indexing]=sort(forecastingError);
%     plot(forecastingError);
%     reconstructionError=reconstructionError(indexing);
%     plot(reconstructionError);
%     plot(1:length,ones(1,length)*10);
%     hold off;
%     corrData=[forecastingError' reconstructionError'];
%     corrplot(corrData);
end;
%[R,P,RLO,RUP]=corrcoef(corrData);

% figure('name','forecasting error','NumberTitle','off');
% mean(forecastingError)
% hold on;
% plot(sort(forecastingError));
% plot(1:m,ones(1,m)*5);
% plot(1:m,ones(1,m)*10);
% plot(1:m,ones(1,m)*15);
% plot(1:m,ones(1,m)*20);
% hold off;
return;

clear all;
close all;
load('3center12week15minOrigClustering.mat');
fLength=672;
m=884;
badNumber=0;
threshold = 30;
data(outliers,:)=[];
% center=center(1:2,:);
% forecastedCenters=forecastedCenters(1:2,:);
for i=1:m
%     coe=(center'\data(i,1:8064)')';
    coe=coeff(i,:);
    forecastingError(i) = 100*mean(abs(coe*forecastedCenters - data(i,8065:(8064+fLength))))/(max(data(i,:))-min(data(i,:)));
    reconstructionError(i) = 100*mean(abs(coe*center(:,1:8064,1) - data(i,1:8064)))/(max(data(i,:))-min(data(i,:)));
    if forecastingError(i) > threshold
%         figure('name',strcat(num2str(reconstructionError(i)),' reco error,', num2str(forecastingError(i)), ' fore error'),'NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
%         plot(dat);
        badNumber=badNumber+1;
    end;
end;
disp(badNumber)
disp(mean(forecastingError));
disp(mean(reconstructionError));
return;
    