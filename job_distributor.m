function job_distributor(machine_id, func_name, params, bFlushJobs)
% job_distributor(machine_id, func_name, params, bFlushJobs)
% params: cell array with parameters
% This enables users to dispatch a function with variable parameters that can be 
% determined at the job dispatch time, simply by writing a function file
% with the give arguments
%
% 2014 HRK
RunnerDefs;

if strcmp(machine_id, 'all'), machine_id = 1:length(MACHINE_ID); end;
if ~is_arg('bFlushJobs'); bFlushJobs = false; end;
    
JOB_DIR = JOB_DIR(machine_id);

run_status = NaN(size(params));
run_dirs = {};
while( any(any(isnan(run_status))) )
    % find job to distribute
    iJob = find(isnan(run_status), 1, 'first');
    fprintf(1, '%g/%g\n', iJob, length(run_status));
    % find empty machine
    cStrM = cellfun(@(x) fullfile(x, '*.m'), JOB_DIR,'UniformOutput',false);
    cDirM = cellfun(@dir, cStrM,'UniformOutput',false);
    % flush to machines with minimum jobs in the queue
    if bFlushJobs
        nJobPerMachine = cellfun(@length, cDirM);
        [tmp iIdleMachine] = min(nJobPerMachine);
    else % wait until a machine becomes idle
        bIdleMachine = cellfun(@isempty, cDirM);
        iIdleMachine = find(bIdleMachine ,1, 'first');
        if isempty(iIdleMachine)
            disp('All machines are busy');
%             run_status
            pause(10); continue;
        end
    end
    % distribute
    fprintf(1, 'job [%g|%s] => %s\n', iJob, params{iJob}, JOB_DIR{iIdleMachine});
    % create job file
    job_fname = sprintf('%s_%s_p%g', func2str(func_name), datestr(now,'HHMMSS'), iJob);
    job_fp = fullfile(JOB_DIR{iIdleMachine},[job_fname '.m']);
    fid=fopen( job_fp, 'w');
    fprintf(fid, 'function %s()\n', job_fname);
    fprintf(fid, '%s(''%s'');\n', func2str(func_name), params{iJob});
    fprintf(1, '%s(''%s'');\n', func2str(func_name), params{iJob});
    fclose(fid);
    % update run status
    run_status(iJob) = 0;
    pause(3);
end