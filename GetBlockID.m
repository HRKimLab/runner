function [block_fname block_id] = GetBlockID(prefix, id_candidate)
% search directory and acquire file id. if all blocks are run, return empty
% 2014 HRK
block_fname = []; block_id = NaN;

flist = dir([prefix '_*']);
[pathstr, name, ext] = fileparts(prefix);

block_id_list=NaN(size(flist));
for iF=1:length(flist)
    a = sscanf(flist(iF).name, [name '_%d']);
    if ~isempty(a)
        block_id_list(iF) = a;
    end
end

block_id_list = nonnans(block_id_list);

% take empty id
remaining_id = setdiff(id_candidate, block_id_list);

if isempty(remaining_id), return; end

% take the first one, make .running file
block_id = remaining_id(1);
block_fname = [prefix '_' num2str(block_id)];
dlmwrite([block_fname '.run'], block_id);

% show messagebox
msgbox(block_fname, 'GetBlockID','replace');
pause(1);

return;
