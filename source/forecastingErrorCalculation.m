clear all;
%load('3center12week15minOrigClustering.mat');
load('21center.mat');
m=884;
forecastedCenters = forecastedCenters3;
forecastingError=nan*ones(1,m);
reconstructionError=nan*ones(1,m);
forecastingErrorToPlot=[];
reconstructionErrorToPlot=[];
% countOfBadToShow=5;
fLength=96;
tLength=96;
center=center(1:2,:,1);
forecastedCenters=forecastedCenters(1:2,:);
for i=1:m
    deviceData = data(i,:);
    begin = 1;
    for weekNumber=1:12
        portion = deviceData(begin + (weekNumber - 1)*672:begin + (weekNumber - 1)*672 + 96 - 1);
        dat((weekNumber-1)*96+1:weekNumber*96) = portion;
    end;
    coe=(center'\dat')';
    forecastingError(i) = 100*mean(abs(coe*forecastedCenters - data(i,8065:(8064+fLength))))/(max(data(i,:))-min(data(i,:)));
    reconstructionError(i) = 100*mean(abs(coe*center(:,1:tLength) - data(i,1:tLength)))/(max(data(i,:))-min(data(i,:)));
end;


% fLength=672;
% tLength=672;
% % center=center(1:2,:);
% % forecastedCenters=forecastedCenters(1:2,:);
% for i=1:m
% %     coe=(center'\data(i,1:8064)')';
%     coe=coeff(i,:);
%     forecastingError(i) = 100*mean(abs(coe*forecastedCenters - data(i,8065:(8064+fLength))))/(max(data(i,:))-min(data(i,:)));
%     reconstructionError(i) = 100*mean(abs(coe*center(:,1:tLength,1) - data(i,1:tLength)))/(max(data(i,:))-min(data(i,:)));
% %     if reconstructionError(i)<15 
% %         forecastingErrorToPlot = [forecastingErrorToPlot forecastingError(i)];
% %     end;
% %     if forecastingError(i)>15 && countOfBadToShow>0
% %         forecastingErrorToPlot = [forecastingErrorToPlot forecastingError(i)];
% %         reconstructionErrorToPlot=[reconstructionErrorToPlot reconstructionError(i)];
% % %         countOfBadToShow=countOfBadToShow-1;
% % %         figure('name','forecasting error','NumberTitle','off');
% % %         hold on;
% % %         plot(data(i,8065:8156));
% % %         plot(abs(coeff(i,:,1)*forecastedCenters));
% % %         hold off;
% %     end;
% end;

mean(forecastingError)
mean(reconstructionError)
% figure('name','forecasting error','NumberTitle','off');
% hold on;
% plot(sort(forecastingError(satisfying)));
% plot(1:length,ones(1,length)*5);
% plot(1:length,ones(1,length)*10);
% plot(1:length,ones(1,length)*15);
% plot(1:length,ones(1,length)*20);
% hold off;

% [~,length]=size(forecastingErrorToPlot);
% figure('name','forecasting error','NumberTitle','off');
% hold on;
% [forecastingErrorToPlot,indexing]=sort(forecastingErrorToPlot);
% plot(forecastingErrorToPlot);
% reconstructionErrorToPlot=reconstructionErrorToPlot(indexing);
% plot(reconstructionErrorToPlot);
% plot(1:length,ones(1,length)*10);
% hold off;
% corrData=[forecastingErrorToPlot' reconstructionErrorToPlot'];
% corrplot(corrData)

forecastingErrorToPlot=forecastingError;
reconstructionErrorToPlot=reconstructionError;
[~,length]=size(forecastingErrorToPlot);
figure('name','forecasting error','NumberTitle','off');
hold on;
[forecastingErrorToPlot,indexing]=sort(forecastingErrorToPlot);
plot(forecastingErrorToPlot);
reconstructionErrorToPlot=reconstructionErrorToPlot(indexing);
plot(reconstructionErrorToPlot);
plot(1:length,ones(1,length)*10);
hold off;
corrData=[forecastingErrorToPlot' reconstructionErrorToPlot'];
corrplot(corrData);
[R,P,RLO,RUP]=corrcoef(corrData);

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
