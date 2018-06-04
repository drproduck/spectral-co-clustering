clear;
n=1000;
m=10000;

d=rand(m,1);
B=rand(n,m);
A=rand(n,n);
A(A<0.99)=0;
A=sparse(A);
% B(B<0.99)=0;
% B=sparse(B);

a=[diag(d),B';B,A];

% a=[5,0,0,8,5;
%     0,4,0,7,4;
%     0,0,3,6,3;
%     8,7,6,10,0;
%     5,4,3,0,10];
% as=sparse(a);

D=diag(sum(a,2)+sum(a(:))/(n+m));
a=D-a;
d=diag(a(1:m,1:m));
A=a(m+1:end,m+1:end);
B=a(m+1:end,1:m);

as=sparse(a);
spy(as)
drawnow

% tic;
% [x,y]=svds(a);
% toc
tic;
[x1,y1]=eigs(as,20);
toc
tic;
[E]=blockArrowCholesky(B,A,d);
toc
tic;
[x2,y2]=svds(E,20);
toc
% tic;
% F=chol(a);
% [x3,y3]=svds(F);
% toc



% 
% [x,y]=eigs(a,5,'la')

% f=[1,0,0,0,0;
%     0,1,0,0,0;
%     0,0,1,0,0;
%     8/5,7/4,6/3,1,0;
%     1,1,1,0.5421,1];
% d=diag([5,4,3,-35.05,-0.7004]);

% af=f*d*f'

% [x,y,z]=svds(af,3)
% [x1,y1,z1]=svds(a,3)
% % a=p*a*p';
% % [L,D]=ldl(a);