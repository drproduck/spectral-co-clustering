function [r,c,v,varargout] = getsamelink(gnd, ratioknown, beven, bnorm)
% randomly get same link 

nlabel=max(gnd);
n=length(gnd);
if beven
    linkp=zeros(length(gnd),1);
    c=zeros(ceil(ratioknown*n)+nlabel,1); %since using ceil (to prevent null size), size can be less than needed
    r=c;
    v=r;
    clen=0;
    for i=1:nlabel
        id=find(gnd==i);
        ntake=ceil(ratioknown*length(id));
        idkp=randsample(id,ntake);
        linkp(idkp)=i;
        x=repmat(idkp,ntake,1);
        c(clen+1:clen+ntake^2)=x(:);
        r(clen+1:clen+ntake^2)=repmat(idkp',ntake,1);
        if bnorm
            v(clen+1:clen+ntake^2)=ones(ntake^2,1)/ntake;
        end
        clen=clen+ntake^2;
        
    end
    varargout{1}=linkp;
    r=r(1:clen);
    c=c(1:clen);
    if ~bnorm
        v=ones(clen,1);
    else
        v=v(1:clen); %default to all 1s
    end
else
    % wrong! dont use
    %TODO change this to sampling edge instead
    c=zeros(ceil(ratioknown*n)+nlabel,1); %since using ceil (to prevent null size), size can be less than needed
    r=c;
    ntake=ceil(ratioknown*n);
    idkp=randsample(n,ntake)';
    x=repmat(idkp,ntake,1);
    c(1:ntake^2)=x(:);
    r(1:ntake^2)=repmat(idkp',ntake,1);        
    r=r(1:ntake^2);
    c=c(1:ntake^2);
    v=ones(ntake^2,1);
end

end