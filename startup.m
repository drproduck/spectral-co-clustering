%fire things up
addpath(genpath('/home/drproduck/spectralclustering-coclustering/'));
ok = true;
if max(size(strfind(path, 'dummy-coclustering'))) == 0
    ok = false;
end
    
if ok
    disp('startup ok')
else 
    disp('something may be wrong when starting up')
end