function [L,D] = fastBlockArrowLDL(B,A,d)

%fast ldl factorization of a large but highly sparse block arrowhead matrix
%The matrix assumes this form:
%[diag(d)    B
% B^t        A]
%where A is symmetric positive definite and sparse
%d is ROW vector
[nb,mb]=size(B);
[na,ma]=size(A);
assert(na==nb);
assert(na==ma);
assert(mb==length(d));
n=na+mb;

assert(size(d,1)==1); %d is ROW vector
L1=B./d;

tA=A-L1.*d*L1';
% [F2,D2,x,y]=ldl(tA);
[F2,D2]=ldl(full(tA));
%F1=diag(ones(mb,1))
dd=[d';diag(D2)];
D=sparse(1:n,1:n,dd);

r=(1:mb)';
c=(1:mb)';
v=ones(mb,1);
[r1,c1,v1]=find(L1);
r=[r;r1+mb];
c=[c;c1];
v=[v;v1];
[r1,c1,v1]=find(F2);
r=[r;r1+mb];
c=[c;c1+mb];
v=[v;v1];

L=sparse(r,c,v,n,n);



