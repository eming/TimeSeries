fid = fopen('inputs.csv','rt');
data = textscan(fid, '%q\n%f%f%f', 'delimiter',{','},'MultipleDelimsAsOne', true);
[count,~]=size(data{1});
fclose(fid);

titles=data{1};
a=data{2};
b=data{3};
c=data{4};
for i=1:count
    %process
    result= a(i) + b(i) + c(i);
    titles{i}
    result
end;