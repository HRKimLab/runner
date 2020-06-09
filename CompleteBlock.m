function sTime = CompleteBlock(fname)
% search directory and acquire file id. if all blocks are run, return empty
% string
global gRunner
block_fname = []; block_id = NaN;

% get hostname
[tmp hname] = system('hostname');
hname = strtok(hname);

delete([fname '_' hname '.run']);

sEnd = clock();
sTime = etime(sEnd, gRunner);

[fpath fn] = fileparts(fname);
% if fname is a file in the current path, add '.'
if isempty(fpath), fpath = '.'; end;

fid = fopen([fpath '/run_log.txt'],'a');
fprintf(fid, '%s: %s (%.1fmin)\r\n', fn, hname, sTime/60);
fclose(fid);

return;
