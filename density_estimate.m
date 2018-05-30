%given U - embeddings of doc, use kernel density estimation to estimate
%the density of each row in V -embeddings of word

%this script was used after running another demo script, which should leave
%the required variables below in workspace

if ~ exist('U','var')
    error('cannot find U in workspace')
elseif ~exist('V','var')
    error('cannot find U in workspace')
elseif ~exist('vocab','var')
    error('cannot find vocab in workspace')
elseif ~exist('topic','var')
    error('cannot find topic in workspace')
elseif ~exist('d_label','var')
    error('cannot find d_label in workspace')
end

d=3;

for i=1:10
    cl=U(gnd==i,:);
    n=length(cl);
    
    %compute bandwidth based on matlab suggestion
    mul=(4/(d+2)/n)^(1/(d+4));
    sgm=std(cl);
    bw=mul*sgm;
    
    dst=mvksdensity(cl,V,'Bandwidth',bw);
    [v,id]=sort(dst,'descend');
    figure(1)
    hold on
    scatter3(cl(:,1),cl(:,2),cl(:,3),3,'filled');
    text(V(id(1:5),1),V(id(1:5),2),V(id(1:5),3),vocab(id(1:5)));
    fprintf('cluster %s\n',topic{i})
    for j=1:40
        fprintf('%s (%.2f) | ',vocab{id(j)},v(j));
    end
    fprintf('\n')
    drawnow
end
