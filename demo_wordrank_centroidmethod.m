%rank words by centroids of embedding clusters

%origin top 10: 10 distinct topics, all words included

clear;
rng(223);
colormap default
if exist('20news_origin_top10/20newsorigintop10tfidf.mat', 'file')
    load('20newsorigintop10tfidf')
else
    disp('producing tfidf-weighted feature')
    load('20newsorigintop10.mat')
    fea=tfidf(fea,'hard');
    fea=fea./sqrt(sum(fea.^2,2));
    save('20news_origin_top10/20newsorigintop10tfidf.mat','fea','gnd','vocab','topic')
end

nlabel=max(gnd);
[n,m] = size(fea);

if sum(fea ~= 0, 1) == 0
    disp('null column exists')
end
if sum(fea ~= 0, 2) == 0
    disp('null row exists')
end

% r=sum(sum(fea))/(n+m);
[L,D1,D2] = getLaplacian(fea, 1e-100, 'bipartite');
[u,s,v] = svds(L, nlabel);
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




function idx_rw = getMostCommon(fea, gnd, z, no_keep)
% get most common words based on column sums, tfidf weight, assuming ground
% truth (gnd) is known
col_sum = sum(fea(gnd==z,:), 1);
[~, idx_max] = sort(col_sum, 'descend');
idx_rw = idx_max(1:no_keep);
end