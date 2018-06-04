clear;
rng(200);
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

lsa(fea,20);


function [d,w] = lsa(fea, k)

% latent semantic analysis. Assuming fea has been normalized (tfidf, L2
% norm). 

[u,s,v]=svds(fea,k);

d=u*s;
w=v*s;