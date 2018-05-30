
%POST remark: the vectors are different by only a multiplicative scalar

clear;
load('20newsorigintop10tfidf.mat')

[n,m]=size(fea);
[r,c,v]=find(fea);
rr=[r;n+c];
cc=[c+n;r];
vv=[v;v];
nm=n+m;
bigfea=sparse(rr,cc,vv,nm,nm);

[u1,s1,v1]=svds(fea,40);
[u2,s2] = eigs(bigfea,40);
% figure(1)
% subplot(221)
% imagesc(fea)
% subplot(222)
% imagesc(bigfea)
% subplot(223)
% image(u1)
% subplot(224)
% image(u2)

figure(2)
subplot(211)
scatter3(u1(:,1),u1(:,2),u1(:,3),3,bestColor(gnd));
subplot(212)
scatter3(u2(1:n,1),u2(1:n,2),u2(1:n,3),3,bestColor(gnd));
