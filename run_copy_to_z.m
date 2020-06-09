% DATA_DIR
DEST_DIR = 'Z:\Users\HyungGoo\sim\mle_final_varying_amp\FigData3\';
% DATA_NAME = DATA_DIR(12:end-1);
% % check if there is same name in destination directory
% if exist([DEST_DIR DATA_NAME], 'dir')
%     error('Destination directory exists.');
% end
% % copy files
% copyfile([DATA_DIR '*'], [DEST_DIR DATA_NAME]);
mkdir(DEST_DIR);
copyfile('FigData3\*', DEST_DIR);
dispatcher('run_mnr_spd2.m', 3:7);

pause(10);
[a b]=system(['dir ' DEST_DIR '0_0_1_a\']);
fid=fopen('copy_to_z_output.txt','w');
fprintf(fid, b);
fclose(fid);