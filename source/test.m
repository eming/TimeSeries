
hold on;
%plot(center(1,:,1));
plot(center(2,:,1));
plot(center(3,:,1));
hold off;
return;

figure('name','centers','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
hold on;
plot(smooth(data(3,:),21));
plot(smooth(data(2,:),21));
hold of;
return;

figure('name','centers','NumberTitle','off','units','normalized','outerposition',[0 0 1 1]);
for i=1:1003
    if ismember(i,outliers)
        color='r';
    else
        color='b';
    end;
    d=smooth(data(i,:),21);
    plot(1:8736, d, color);
    pause(0.5);
end;
return;

error=[];
for i=1:1003
    error=[error mean(abs(data(i,2:8736)-data(i,1:8735)))/(max(data(i,:))-min(data(i,:)))];
end;
mean(error)
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
