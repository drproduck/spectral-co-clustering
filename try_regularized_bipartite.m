clear;
load('20newsorigintop10tfidf.mat');
fea=getRegularizedBipartite(fea,gnd,0.01);
spy(fea)