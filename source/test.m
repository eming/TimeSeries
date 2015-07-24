m=884;
threshold=10;
forecastingError=nan*ones(1,m);
reconstructionError=nan*ones(1,m);
forecastingErrorToPlot=[];
reconstructionErrorToPlot=[];
countOfBadToShow=5;
fLength=672;
tLength=672;
for i=1:m
    forecastingError(i) = 100*mean(abs(coeff(i,:,1)*forecastedCenters - data(i,8065:(8064+fLength))))/(max(data(i,:))-min(data(i,:)));
    reconstructionError(i) = 100*mean(abs(coeff(i,:,1)*center(:,1:tLength,1) - data(i,1:tLength)))/(max(data(i,:))-min(data(i,:)));
    if forecastingError(i)>15 && countOfBadToShow>0
        forecastingErrorToPlot = [forecastingErrorToPlot forecastingError(i)];
        reconstructionErrorToPlot=[reconstructionErrorToPlot reconstructionError(i)];
%         countOfBadToShow=countOfBadToShow-1;
%         figure('name','forecasting error','NumberTitle','off');
%         hold on;
%         plot(data(i,8065:8156));
%         plot(abs(coeff(i,:,1)*forecastedCenters));
%         hold off;
    end;
end;
% figure('name','forecasting error','NumberTitle','off');
% hold on;
% plot(sort(forecastingError(satisfying)));
% plot(1:length,ones(1,length)*5);
% plot(1:length,ones(1,length)*10);
% plot(1:length,ones(1,length)*15);
% plot(1:length,ones(1,length)*20);
% hold off;

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
corrplot(corrData)

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
corrplot(corrData)

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

j=1;
data1=[];
for i=1:1003
    if ~ismember(i,outliers)
        data1(j,:)=data(i,:);
        j=j+1;
    end;
end;
data=data1;
return;

figure;
hold on;
for i=1:centerCount
    plot(center(i,:));
end;
hold off;
return;

csvread


data1=[];
for i=1:2184
    data1(:,i)=sum(data(:,((i-1)*4+1):i*4),2);
end;
return;

plot(deviceError(1:900));
return;

devicesKeys = keys(devices);
[n, m] = size(devicesKeys);
for i=1:m
    deviceData = devices(devicesKeys{i});
    for j=1:13
        weekData = deviceData{j};
        [n1,m1] = size(weekData);
        if n1~= 672
            disp(['points - ' num2str(n1) ', device - ' num2str(devicesKeys{i}) ', week - ' num2str(j) ', first point - ' num2str(weekData(1, 1))]);
        end;
    end;
end;
