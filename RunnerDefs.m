% global configuration file for runner and job dispatcher
% put the machne name (output of hostname command) here to register the 
% computer for runner
MACHINE_ID = {'MachineName1','MachineName2', 'MachineName3','MachineName4'};

% dispatch root directories - dropbox, Z drive
Z_DIR = 'Z:\Users\HyungGoo\sim\runner\';

% job directories
JOB_DIR = {[Z_DIR 'MachineName1'], [Z_DIR 'MachineName2'], ...
    [Z_DIR 'MachineName3'], [Z_DIR 'MachineName4'] };

% runner status
RUN_OK = 0;     % run completed. don't need to run again.
RUN_AGAIN = 1;  % prerequisite was not met. need to run again
RUN_ERROR = -1; % run-time error 
