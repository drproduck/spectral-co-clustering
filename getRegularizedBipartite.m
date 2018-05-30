function fea = getRegularizedBipartite(fea,gnd,params)

if ~exist('params','var')
    params=[];
end
ratio=params.ratio;
lmda=params.lmda;
nm=size(fea,1)+size(fea,2);
[r1,c1,v1]=getsamelink(gnd,ratio,params.beven,false);%get even same-links in each cluster
[r,c,v]=bipartize(fea);
r=[r1;r];
c=[c1;c];
v=[v1*lmda;v];
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