%# read and parse data file
fid = fopen('Circuit_Data_Summer_2011_prepared.txt','rt');
count = 1000;
devices = containers.Map('KeyType','int32','ValueType','any');

while ~feof(fid)
    C = textscan(fid, '%f%s%f%*[^\n]', count, 'delimiter',{','},'MultipleDelimsAsOne', true);
    %# convert date/time to serial date number
    dt = datenum(C{2}, 'yyyy-mm-dd HH:MM');
    %# combine all in one matrix
    allData = [C{1} dt C{3}];
    %start of time is zero minutes
    allData(:,2)=allData(:,2) - datenum('2011-06-01 00:00', 'yyyy-mm-dd HH:MM');
    
    ids = 0;
    [n, ~] = size(allData);
    condition = true;
    while condition
        deviceId = allData(ids(end) + 1,1);
        ids = find(allData(:,1) == deviceId);
        %skip devices with incomplete first week
        if deviceId == 1233468 || deviceId == 1519024
            condition = ids(end) < n;
            continue;
        end;
        deviceData = allData(ids, :);
        if ~isKey(devices, deviceId) 
            devices(deviceId) = {[] [] [] [] [] [] [] [] [] [] [] [] [] []};
        end;
        device = devices(deviceId);
        for border = ceil(deviceData(1,2)/7):ceil(deviceData(end,2)/7)
            weekDataIds = find(deviceData(:,2) > (border-1)*7 & deviceData(:,2) <= border*7);
            weekData = deviceData(weekDataIds, 2:3);
            device{border} = [device{border}; weekData];
        end;    
        devices(deviceId) = device;
        condition = ids(end) < n;
    end;
end;
%remove incomplete week(14th)
devicesKeys = keys(devices);
[n, m] = size(devicesKeys);
for i=1:m
    deviceData = devices(devicesKeys{i});
    deviceData(14) = [];
    devices(devicesKeys{i}) = deviceData;
end;
%values of map are matrixes now
for i=1:m
    deviceData = devices(devicesKeys{i});
    deviceDataMatrix = nan*ones(672,13); 
    for j=1:13 
        weekData = deviceData{j};
        deviceDataMatrix(:,j) = weekData(:,2);
    end;
    devices(devicesKeys{i}) = deviceDataMatrix;
end;