function run_compute_bias(DATA_DIR_LIST)
% an example function dispatched to runner machine.
% used to get pilot results in Kim et al 2016, JNP 
global gD
% DATA_DIR_LIST = ...
%     {'.\FigData3\0_0_1_bimodal_hvest_a\', '.\FigData3\0_0_1_bimodal_hvest_b\','.\FigData3\0_0_1_bimodal_hvest_c\','.\FigData3\0_0_1_bimodal_hvest_d\' };
DATA_DIR_LIST = {'.\FigData3\0_0_1_allcong\'};

% DATA_DIR_LIST={'.\FigData2\0_0_1_bimodal_varyamp_c\'};

% MergeMNRWeights(DATA_DIR_LIST);
close all;

for iDL=1:length(DATA_DIR_LIST)
DATA_DIR = DATA_DIR_LIST{iDL}

load([DATA_DIR  'pref_dist']);

gD.AMP_METHOD='ConstParams'; % no meaning..
gD.strWMultiplier = 'Same';
gD.est.nTrial = 100;

gD.est.roc_area = 1;
gD.tr.LL_x = 0:5:355;

% Now, compare it with vestibular tuning
% GenAllCombSelfObjDir('MergedByVest',1, DATA_DIR, 'CombRsp_St1WideTC');
% GenAllCombSelfObjDir('MergedByVestmeanLH',1, DATA_DIR, 'CombRsp_St5WideTC');
GenAllCombSelfObjDir('MergedByVest',1, DATA_DIR, 'CombRsp');
GenAllCombSelfObjDir('MergedByVestmeanLH',1, DATA_DIR, 'CombRsp');
GenAllCombSelfObjDir('MergedByVisual',1, DATA_DIR, 'CombRsp');
GenAllCombSelfObjDir('MergedByVisualmeanLH',1, DATA_DIR, 'CombRsp');

close all
end
