function dispatcher(run_fpath, machine_id)
% dispatcher(run_fpath, machine_id)
% dispatch a function to a list of runner machines
% e.g., dispatcher('run_mnr_spd2.m', 3:7);
% 2014 HRK
RunnerDefs;

% print machine info
if ~is_arg('run_fpath'), 
    PrintMachineInfo(); return;
end;

% append .m if missing
if isempty(findstr(run_fpath, '.m')), run_fpath = [run_fpath '.m']; end;

if strcmp(machine_id, 'all')
    machine_id = 1:length(JOB_DIR);
end

if ~isempty(dir(run_fpath))
    [tmp run_fname] = fileparts(run_fpath);

    for iM=machine_id
        disp(['Dispatch a job to ' JOB_DIR{iM}]);
        % copy file to the job foler with datetime postfix
        copyfile(run_fpath, fullfile(JOB_DIR{iM}, [run_fname datestr(now,'_MMDD_HHmmss') '.m']));
        if iM ~= machine_id(end)
            pause(7);
        end
    end
else
    switch(run_fpath)
        case 'clear.m'
            for iM=machine_id
                runner(JOB_DIR{iM}, 'clear');
            end
        case 'delete.m'
            for iM=machine_id
                runner(JOB_DIR{iM}, 'delete');
            end
        case 'listrun.m'
            for iM=machine_id
                fprintf('[%g] %s\n', iM, JOB_DIR{iM}); runner(JOB_DIR{iM}, 'listrun');
            end
        case 'listfail.m'
            for iM=machine_id
                fprintf('[%g] %s\n', iM, JOB_DIR{iM}); runner(JOB_DIR{iM}, 'listfail');
            end
        otherwise
            error('Unknown command: ', run_fpath);
    end
end