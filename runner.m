function runner(fpath, cmd, run_hours)
% runner is a warpper program that runs in each machine and call the
% file dispatched by the control program
% 2014 HRK
RunnerDefs;

% cmd: listrun, listfail, redofail
LONG_DAYS = 365;
FIG_DIR = [Z_DIR 'figures\'];
% every 2 hours, signal that this runner is alive by writing a small file
PING_INTERVAL = 2/24;    
% assign inf to next_ping_time if you don't want to write regularly to Z drive.
next_ping_time = 0;

if ~is_arg('cmd'), cmd = 'run'; end;
if ~is_arg('run_hours'), run_days = LONG_DAYS;
else, run_days = run_hours / 24; end

[tmp hname] = system('hostname'); hname = strtok(hname);
if ~is_arg('fpath')
    fpath = find(cellfun(@(x) strcmp(x, hname), MACHINE_ID));
    if isempty(fpath), error('cannot identify the machine: %s', hname); end;
end; 
if isnumeric(fpath),
    sAns = input(['use directory ' regexprep(JOB_DIR{fpath},'\\','/') '? [y/n]'],'s');
    if sAns == 'y' || sAns == 'Y'
        fpath = JOB_DIR{fpath}; 
    else
        return;
    end;
end

% add the monitoring directory to path
if strcmp(cmd, 'run'), addpath(fpath,'-begin'); end;

if fpath(end) ~= '/' || fpath(end) ~= '\'
    fpath = [fpath '/'];
end

% make history directory
if ~exist([fpath 'history'],'dir')
    mkdir([fpath 'history']);
end
 
% get loop termination time
end_time = now;
end_time = end_time + run_days;

if strcmp(cmd, 'run'), fprintf(1, 'Running terminates at %s\n', datestr(end_time)); end;

while now() < end_time
    if strcmp(cmd,'run'), close all; end;
    
    bRunOK = true;
    
    switch cmd
        case 'listrun'
            fname = list_file(fpath, '*.m');
            return;
        case 'listfail'
            fname = list_file(fpath, '*.fail');           
            return;
        case 'listdone'
            fname = list_file(fpath, '*.done');
            return;
        case 'redofail'
            fname = list_file(fpath, '*.fail');           
            for iF=1:length(fname)
                movefile([fpath fname(iF).name], [fpath fname(iF).name(1:end-5) '.m']);
            end
            cmd='run';
            continue;
        case 'run'
        case 'clear'
            tmp = dir(fpath);
            if length(tmp) > 3
            disp(['delete files in ' fpath ' to history/']);
%             copyfile([fpath '*'], [fpath 'history/']);
            delete([fpath '*.log']);  delete([fpath '*.m']); delete([fpath '*.done']); delete([fpath '*.txt']); delete([fpath '*.fail']); 
            else
                disp([fpath ' is empty']);
            end
            return;
        otherwise
            error('Unknown command: %s', cmd);
    end

    % list .m files in the target directory
    fname = list_file(fpath, '*.m');
    
    if isempty(fname)
%         disp([fpath]); % save lines for history
        % ping
        if now() > next_ping_time
            ping_file = fullfile(fpath, 'im_running.txt');
            fid_ping = fopen(ping_file,'w');
            if fid_ping == -1, warning('cannot open ping file'); 
            else
                fprintf(1, 'PING OK. %s', datestr(now()) );
                fclose(fid_ping);
            end
           next_ping_time = now() +  PING_INTERVAL;
        end
        % wait 20 seconds
        pause(20);
        continue;
    end;
    
    % find oldest .m file
    job_filename = fname(1).name;
    
    % make .running file
    dlmwrite([fpath job_filename(1:end-2) '.log'], 1);
    % clear function 
    % clear(job_filename(1:end-2));
    % clear all global variables to avoid any interaction between runs
    clear global
    % rehash path. once runner runs, it often does not recognize new files
    % in the runner directory (it may be redundant to clear functions)
    rehash path
    pause(1);
    % clear functions enables runner to use updated function while runner is on
    clear functions
    % in case clear functinos works asynchronously, pause a bit to finish
    % the clearing process
    pause(1);
    % run
    sStart = clock();
    try
        % evaluate the filename
        feval(job_filename(1:end-2))
    catch
        bRunOK = false;
        le = lasterror;
        le.message
        fid=fopen([fpath job_filename(1:end-2) '.log'],'a');
        fprintf(fid, 'Error occured at %s, %s\r\n', datestr(now), hname);
        fprintf(fid, '%s\r\n', le.message);
        print_stack(fid, le.stack);
        fclose(fid);
    end
    sEnd = clock();
    sElapsed = etime(sEnd, sStart);
    
    if bRunOK
        fid=fopen([fpath job_filename(1:end-2) '.log'],'a');
        fprintf(fid, '%s succeeded. it took %.1fmin\r\n', job_filename, sElapsed/60);
        fclose(fid);
    end
    
    % change .log to .txt
    copyfile([fpath job_filename(1:end-2) '.log'], [fpath job_filename(1:end-2) '.txt']);
    pause(0.5);
    delete([fpath job_filename(1:end-2) '.log']);
    
    % change job_filename to .done, .fail if failed
    if bRunOK
        copyfile([fpath job_filename], [fpath job_filename(1:end-2) '.done']);
    else
        copyfile([fpath job_filename], [fpath job_filename(1:end-2) '.fail']);
       
        % also copy to figure/ directory
        copyfile([fpath job_filename], [Z_DIR 'figures/' job_filename]);
        copyfile([fpath job_filename(1:end-2) '.txt'], [Z_DIR 'figures/' job_filename(1:end-2) '.txt']);
    end
    pause(0.5);
    delete([fpath job_filename]);
    
    pause(2);
    
    % save figures
    global gSaveFig
    if is_arg('gSaveFig') && gSaveFig 
        fig2pdf('all', [Z_DIR 'figures/' hname '_' datestr(now, 'mmdd_HHMM') '_' job_filename '.pdf']);
    end
    
end

% if run_hours is manually set, terminate Matlab.
if run_days ~= LONG_DAYS
    disp('Matlab will be terminated');
    exit;
end


function print_stack(fid, st)
for iS=1:length(st)
    fprintf(1, '%s:%.0f \n', st(iS).name, st(iS).line);
    fprintf(fid, '%s:%.0f \n', st(iS).name, st(iS).line);
end

function fname = list_file(fpath, ext)

fname = dir([fpath ext]); 

if isempty(fname), return; end;

% lower version matlab doesn't have datenum field.
if ~isfield(fname, 'datenum')
    for iF=1:length(fname), fname(iF).datenum = datenum(fname(iF).date); end
end

% sort by ascending time
[tmp iS] = sort(cat(1,fname.datenum));
fname = fname(iS);
            
for iF=1:length(fname)
    fprintf(1, ' %s\n', fname(iF).name);
end