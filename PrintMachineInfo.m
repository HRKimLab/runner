function PrintMachineInfo()
% print machine information participating in runner environment
% 2014 HRK
RunnerDefs;

disp('Destination directories: ');
for iM=1:length(JOB_DIR)
    fprintf('[%.0f] %s\n', iM,JOB_DIR{iM});
end
return;