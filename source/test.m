

m=884;
threshold=10;
forecastingError=nan*ones(1,m);
for i=1:m
    forecastingError(i) = 100*mean(abs(coeff(i,:)*forecastedCenters - data(i,8065:8736)))/(max(data(i,:))-min(data(i,:)));
end;
figure('name','forecasting error','NumberTitle','off');
mean(forecastingError)
hold on;
plot(sort(forecastingError));
plot(1:m,ones(1,m)*5);
plot(1:m,ones(1,m)*10);
plot(1:m,ones(1,m)*15);
plot(1:m,ones(1,m)*20);
hold off;
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
