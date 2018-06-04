%experiment with fast block arrowhead decomposition

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

nlabel=max(gnd);
[n,m]=size(fea);

tic;
params.ratio=0.1;
params.lmda=1;
params.beven=1;
bigfea=getRegularizedBipartite(fea,gnd,params);
[L,d] = getLaplacian(bigfea, 1e-100, 'symmetric');

fprintf('Took %.2f seconds to create matrix and factorize\n',toc)
clear L bigfea
tic;
[r,c,v]=getsamelink(gnd,0.1,1,false);
A=sparse(r,c,v*1,n,n);
A(1:n+1:end)=0; %remove diagionals

tic;
D2=sparse(1:n,1:n,sum(fea,2)+sum(A,2));

E=blockArrowCholesky(-fea,D2-A,sum(fea,1));

fprintf('Took %.2f seconds to create matrix and factorize\n',toc)


