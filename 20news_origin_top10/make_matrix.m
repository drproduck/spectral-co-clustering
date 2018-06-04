load('20newsorigin.mat')

idx=zeros(length(gnd),1);
g =[3,4,5];
for i = g
    idx=idx+(gnd==i);
end
idx=uint8(idx);
idx=find(idx==1);
size(idx)

fea=fea(idx,:);
gnd=gnd(idx,:);
j=1;
for i=g
    gnd(gnd==i)=j;
    j=j+1;
end

if sum(fea ~= 0, 1) == 0
    disp('null column exists')
end
if sum(fea ~= 0, 2) == 0
    disp('null row exists')
end

save('20newsorigin2group','fea','gnd','vocab','topic');