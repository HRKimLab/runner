function run_mnr()
% an example function dispatched to runner machine.
% used to get pilot results in Kim et al 2016, JNP 
% 2014 HTK
global gD
MNR_DATAFILE_POSTFIX = '_MLR'
DATA_DIR = '.\FigData2\0_0_1_b\'
load([DATA_DIR 'uniform_random_pref_dist']);
% train weights while varying probably of having object in the scene
% warea_list = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1];
gD.warea_list = [0 .2 .4 .6 .8 1];
gD.strWMultiplier = 'Same';
gD.tr.dSelfMode = 'Uniform_Coarse'; %'Two_fine'; %'Random' % 'Two'%;, 'Uniform',
%gD.tr.LL_x = 0:2:359;
gD.tr.LL_x = 0:5:359;
gD.cw_glm={};

gD.unimodal_prop = [0 0 1]; % [0 0 1] [.1 .1 .8]  [.25 .25 .5] [.33 .33 .34] [.4 .4 .2]
NUM_TRAIN_BLOCK = 6;

PlotPrefDist(gD.pref(:,[1 2]));

% train with combined responses
prefix = [DATA_DIR gD.CELL_POP MNR_DATAFILE_POSTFIX];
fname = GetBlockID2(prefix, 1:NUM_TRAIN_BLOCK)
gD.cw_glm={};
while ~isempty(fname)

    iV=1;
    for v=gD.warea_list
        % cue combination effect (without object)
        gD.est.roc_area = v;

        % train weights
        [gD.tr.Coh gD.tr.answer gD.tr.choice gD.cw_glm{iV}] = TrainWeightArray_nmrfit(gD.pref, 50000, gD.unimodal_prop);  % simpler beta update

        iV=iV+1;

        close all; pause(1);
    end
    
    CompleteBlock(fname);
    save(fname, 'gD'); 
    fname = GetBlockID2(prefix, 1:NUM_TRAIN_BLOCK);
end

% train using vestibular response
gD.cw_glm={};
prefix = [DATA_DIR gD.CELL_POP MNR_DATAFILE_POSTFIX '_VestRsp' ];
fname = GetBlockID2(prefix, 1:NUM_TRAIN_BLOCK)
while ~isempty(fname)
    
    gD.w_vis=0; gD.w_obj = 0; gD.w_vest=1;
    gD.est.roc_area = 1.0;
    iV=1;
    [gD.tr.Coh gD.tr.answer gD.tr.choice gD.cw_glm{iV}] = TrainWeightArray_nmrfit(gD.pref, 50000);  % simpler beta update

    
    CompleteBlock(fname);
    save(fname, 'gD');
    fname = GetBlockID2(prefix, 1:NUM_TRAIN_BLOCK);

end
