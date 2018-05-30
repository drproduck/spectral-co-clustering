%try to svd full bipartite matrix instead of partial one

%origin top 10: 10 distinct topics, all words included

clear;
rng(223);
% colormap default
% if exist('20news_origin_top10/20newsorigintop10tfidf.mat', 'file')
%     load('20newsorigintop10tfidf')
% else
%     load('20newsorigintop10.mat')
%     fea=tfidf(fea,'hard');
%     fea=fea./sqrt(sum(fea.^2,2));
%     save('20news_origin_top10/20newsorigintop10tfidf.mat','fea','gnd','vocab','topic')
% end

load('20newsorigin.mat')
fea=tfidf(fea,'hard');

nlabel=max(gnd);
[n,m] = size(fea);

if sum(fea ~= 0, 1) == 0
    disp('null column exists')
end
if sum(fea ~= 0, 2) == 0
    disp('null row exists')
end

% s=sum(sum(fea));
% r=[s/n,s/m];
% d1 = sum(fea, 2)+r(1);
% d2 = sum(fea, 1)+r(2);
% d1 = max(d1, 1e-100);
% d2 = max(d2, 1e-100);
% D1 = sparse(1:n,1:n,d1.^(-0.5));
% D2 = sparse(1:m,1:m,d2.^(-0.5));
% fea = D1*fea*D2;

%make bipartite matrix from fea
[r,c,v]=find(fea);
rr=[r;n+c];
cc=[c+n;r];
vv=[v;v];
nm=n+m;
fea=sparse(rr,cc,vv,nm,nm);

s=sum(sum(fea));
r=s/(m+n);
d=sum(fea,2)+r;
D=sparse(1:n+m,1:n+m,d.^(-0.5));
fea=D*fea*D;
clear D;
D1=sparse(1:n,1:n,d(1:n).^(-0.5));
D2=sparse(1:m,1:m,d(n+1:end).^(-0.5));

[uu,s,~] = eigs(fea, nlabel*2,'lr');

u=uu(1:n,1:nlabel);
v=uu(n+1:end,1:nlabel);

for t=0
    if t==0
        U = D1 * u;
        V = D2 * v;
    elseif t>=0
        U=D1*u*s.^t;
        V=D2*v*s.^t;
    end
    U(:,1) = [];
    V(:,1) = [];
    %try to avoid underflow
    U=norm2(U);
    V=norm2(V);
end
if sum(isnan(U(:))) || sum(isinf(U(:)))
    warning('U contains nan or inf')
end
if sum(isnan(V(:))) || sum(isinf(V(:)))
    warning('V contains nan or inf')
end

nlabel=max(gnd);
n=size(U,1);

d_label = litekmeans(U, nlabel, 'Distance', 'cosine', 'MaxIter', 100, 'Replicates',10);
[d_label,map]=bestMap(gnd,d_label);
figure(1)
cm=confusionmat(gnd, d_label);
imagesc(cm)
ac=sum(d_label==gnd)/length(gnd);
fprintf('accuracy = %.2f%%\n', ac*100);
center=zeros(10,size(U,2));

nw=1;
figure(2)
color=distinguishable_colors(9);
for i=1:9
    c=mean(U(d_label==i,:),1);
    center(i,:)=norm2(c);
    dist=center(i,:)*V';
    [v,id]=sort(dist,'descend');
    fprintf('cluster %s\n',topic{i})
    for j=1:40
        fprintf('%s (%.2f) | ',vocab{id(j)},v(j));
    end
    fprintf('\n')
    subplot(3,3,i)
    hold on
    scatter3(U(d_label==i,1),U(d_label==i,2),U(d_label==i,3),5,color(i,:),'Marker','.')
    scatter3(center(i,1),center(i,2),center(i,3),20,'Marker','o')
%     scatter3(V(id(1:nw),1),V(id(1:nw),2),V(id(1:nw),3),3)
    text(V(id(1:nw),1),V(id(1:nw),2),V(id(1:nw),3),vocab(id(1:nw)),'FontSize',10)
    drawnow
end

figure(3)
scatter3(U(:,1),U(:,2),U(:,3),3,gnd);


function idx_rw = getMostCommon(fea, gnd, z, no_keep)
% get most common words based on column sums, tfidf weight, assuming ground
% truth (gnd) is known
col_sum = sum(fea(gnd==z,:), 1);
[~, idx_max] = sort(col_sum, 'descend');
idx_rw = idx_max(1:no_keep);
end