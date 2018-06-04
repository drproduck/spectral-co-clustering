%experiment with semi-supervised coclustering

%origin top 10: 10 distinct topics, all words included

clear;
rng(223);
colormap default
% if exist('20news_origin_top10/20newsorigintop10tfidf.mat', 'file')
%     load('20newsorigintop10tfidf')
% else
%     load('20newsorigintop10.mat')
%     fea=tfidf(fea,'hard');
%     fea=fea./sqrt(sum(fea.^2,2));
%     save('20news_origin_top10/20newsorigintop10tfidf.mat','fea','gnd','vocab','topic')
% end

load('20newsorigintop10.mat')
fea=tfidf(fea,'hard');
fea=norm2(fea);

nlabel=max(gnd);
[n,m]=size(fea);

% s=sum(sum(fea));
% r=[s/n,s/m]
% r=[repmat(r(1),n,1);repmat(r(2),m,1)];

tic;
params.ratio=0.1;
params.lmda=1;
params.beven=1;
fea=getRegularizedBipartite(fea,gnd,params);

fprintf('Took %.2f seconds to create matrix\n',toc)

if sum(fea ~= 0, 1) == 0
    disp('null column exists')
end
if sum(fea ~= 0, 2) == 0
    disp('null row exists')
end

[L,d] = getLaplacian(fea, 1e-100, 'symmetric');
[uu,s,~] = eigs(L, nlabel,'lr');

U=uu(1:n,1:nlabel);
V=uu(n+1:end,1:nlabel);
D1=sparse(1:n,1:n,d(1:n));
D2=sparse(1:m,1:m,d(n+1:end));

U = D1 * U;
V = D2 * V;

U(:,1) = [];
V(:,1) = [];
%try to avoid underflow
U=norm2(U);
V=norm2(V);

if sum(isnan(U(:))) || sum(isinf(U(:)))
    warning('U contains nan or inf')
end
if sum(isnan(V(:))) || sum(isinf(V(:)))
    warning('V contains nan or inf')
end


d_label = litekmeans(U, nlabel, 'Distance', 'cosine', 'MaxIter', 100, 'Replicates',10);
[d_label,map]=bestMap(gnd,d_label);
figure(1)
cm=confusionmat(gnd, d_label);
imagesc(cm)
ac=sum(d_label==gnd)/length(gnd);
fprintf('accuracy = %.2f%%\n', ac*100);

figure(2)
scatter3(U(:,1),U(:,2),U(:,3),3,gnd)
