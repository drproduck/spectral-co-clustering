function [label,U,V] = SCM(fea,k,C1,C2,lmda)

%Spectral Constraint Modeling.
%Efficient Semi-supervised Spectral Co-clustering with Constraints. 
%X. Shi and W. Fan and P. S. Yu

%assume fea has been normalized (tfidf, L2norm) properly before passed

[n,m]=size(fea);
D1=sparse(1:n,1:n,sum(fea,2));
D2=sparse(1:m,1:m,sum(fea,1));

%assert(size(C,1)==size(C,2))
nC1=size(C1,1);
S1=sparse(1:nC1,1:nC1,sum(C1,2));
Dr=D1+lmda*(S1-C1);
if isempty(C2)
    Dc=D2;
else
    nC2=size(C2,1);
    S2=sparse(1:nC2,1:nC2,sum(C2,1));
    Dc=D2+lmda*(S2-C2);
end

fea=Dr.^(-0.5) * fea * Dc.^(-0.5);
[u,s,v]=svds(fea,k+1);

U=Dr.^(-0.5)*u;
V=Dc.^(-0.5)*v;

U(:,1)=[];
V(:,1)=[];

label=litekmeans(U, nlabel, 'Distance', 'cosine', 'MaxIter', 100, 'Replicates',10);

end

    
