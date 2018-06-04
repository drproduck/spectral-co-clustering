function fea = getRegularizedBipartite(fea,gnd,params)

if ~exist('params','var')
    params=[];
end
ratio=params.ratio;
lmda=params.lmda;
nm=size(fea,1)+size(fea,2);
if isfield(params,'link')
    r1=params.link(:,1);
    c1=params.link(:,2);
    v1=params.link(:,3);
else
    [r1,c1,v1]=getsamelink(gnd,ratio,params.beven,false);%get even same-links in each cluster
end
[r,c,v]=bipartize(fea);
r=[r1;r];
clear r1
c=[c1;c];
clear c1
v=[v1*lmda;v];
clear v1
fea=sparse(r,c,v,nm,nm);
fea(1:nm+1:end)=0;
end

function [rr,cc,vv] =  bipartize(fea)
[r,c,v]=find(fea);
[n,~]=size(fea);
rr=[r;n+c];
cc=[c+n;r];
vv=[v;v];
end