function [block_id_list] = FindBlockID(prefix, id_candidate)
% search directory and acquire file id. 
% if all blocks are run, return empty string
% 2014 HRK
block_fname = []; block_id = NaN;
if prefix(end) == '_'
    prefix = prefix(1:end-1);
end

% this is for analysis. so only find .mat files. 
flist = dir([prefix '_*.mat']); 
[pathstr, name, ext] = fileparts(prefix);

block_id_list=NaN(size(flist));
for iF=1:length(flist)
    a = sscanf(flist(iF).name, [name '_%d']);
    if ~isempty(a)
        block_id_list(iF) = a;
    end
end

block_id_list = sort(nonnans(block_id_list));
block_id_list = block_id_list(:)';

return;
