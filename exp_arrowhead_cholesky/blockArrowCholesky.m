function [E] = blockArrowCholesky(B,A,d)

%fast ll factorization of a large but highly sparse block arrowhead matrix
%The matrix assumes this form:
%[diag(d)    B^t
% B          A]
%where A is symmetric positive definite and sparse
%d is COLUMN vector > 0

%SOLUTION
%D1=diag(sqrt(d))
%L =    [D1             (B*D1.^-1)'
%        B*D1.^-1       chol(A-B*D.^(-2)*B')]


d=reshape(d,[length(d),1]); %make sure it is column
n=length(d);
m=size(B,1);
D1=sparse(1:n,1:n,sqrt(d));
D2=sparse(1:n,1:n,1./sqrt(d));
C=B*D2;

clear B;

E=chol(A-C*C','lower');

%re-reusing the var to save space
E=[D1,sparse(n,m);C,E];
assert(issparse(E));

