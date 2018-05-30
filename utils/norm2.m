function A = norm2(A)

%normalizing rows of A to length 1, with code to prevent under/overflow

denom=max(abs(A),[],2);
denom=max(denom,1e-100);
A=A./denom;
A=A./sqrt(max(sum(A.^2,2),1)); % if sum(A.^2,2) is less than 1, it must be 0


