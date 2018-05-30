%see if kmeans fail by producing a group of only words/unbalanced ratio of
%words and docs

%origin top 10: 10 distinct topics, all words included
% visualizing word and doc embedding in bipartite Laplacian, 20news 
clear;
rng(100);
colormap default
if exist('20news_origin_top10/20newsorigintop10tfidf.mat', 'file')
    load('20newsorigintop10tfidf')
else
    load('20newsorigintop10.mat')
    fea=tfidf(fea,'hard');
    fea=fea./sqrt(sum(fea.^2,2));
    save('20news_origin_top10/20newsorigintop10tfidf.mat','fea','gnd','vocab','topic')
end
nlabel=max(gnd);
[n,m] = size(fea);
% idx = [find(gnd==1);find(gnd==2);find(gnd==3);find(gnd==4);find(gnd==5)];
idx=[find(gnd==1);find(gnd==2);find(gnd==10);find(gnd==13);find(gnd==14)];
gnd1 = gnd(idx,:);


if sum(fea ~= 0, 1) == 0
    disp('null column exists')
end
if sum(fea ~= 0, 2) == 0
    disp('null row exists')
end


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
    U=U./sqrt(sum(U.^2,2));
    V=V./sqrt(sum(V.^2,2));
end

nlabel=max(gnd);
n=size(U,1);
W = [U;V];
all_label = litekmeans(W, nlabel, 'Distance', 'cosine', 'MaxIter', 100, 'Replicates',10);
label = all_label(1:n);
[d_label,map]=bestMap(gnd,label);
figure(1)
cm=confusionmat(gnd, d_label);
imagesc(cm)
ac=sum(d_label==gnd)/length(gnd);
w_label=all_label(n+1:end);
for i=1:length(map)
    w_label(w_label==map(i,1))=map(i,2);
end
fprintf('cluster doc-word ratio:\n')
for i=1:10
    a=sum(d_label==i);
    b=sum(w_label==i);
    fprintf('group%d | %d | %d | %.2f |\n',i,a,b,a/b)
end
    


function idx_rw = getMostCommon(fea, gnd, z, no_keep)
% get most common words based on column sums, tfidf weight, assuming ground
% truth (gnd) is known
col_sum = sum(fea(gnd==z,:), 1);
[~, idx_max] = sort(col_sum, 'descend');
idx_rw = idx_max(1:no_keep);
end