%interpolation
clear all;
data = csvread('weekday7weather.csv',0,1);
newData=ones(312*4,5);
data=data(:,1:5);
oldIndex=1:312;
newIndex=0.25:0.25:312;
newData= (spline(oldIndex,data',newIndex))';
newData(:,5)=round(newData(:,5), 4);
csvwrite('interpolatedWeather.csv',newData);
return;