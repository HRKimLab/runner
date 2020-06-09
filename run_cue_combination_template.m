function run_cue_combination_template(DATA_DIR_LIST)
% an example function dispatched to runner machine.
% used to get pilot results in Kim et al 2016, JNP 
% 2014 HTK
clear all;
DATA_DIR_LIST={'.\FigData2\0_0_1_ubamp_a\', '.\FigData2\0_0_1_bimodal_ubamp_a\'};
DATA_DIR_LIST={'.\FigData2\0_0_1_ubamp_a\', '.\FigData2\0_0_1_bimodal_ubamp_a\'};

global gD

DECODE_MODEL_LIST = {'MergedByVest', 'MergedByVestmeanLH', 'MergedByLearnedMNRmeanLH', 'MergedByLearnedMNR'};
TEST_HEADING_LIST = 0:45:315;

%  cue-combination effect using MNR lernaed weights
for iDL=1:length(DATA_DIR_LIST)
DATA_DIR = DATA_DIR_LIST{iDL}
load([DATA_DIR 'MNR_W_by_combR.mat']);

gD.est.nTrial = 100;
gD.strWMultiplier = 'Same';
if ~isfield(gD,'warea_list') && ~isempty(findstr(DATA_DIR, '\FigData\'))
    gD.warea_list = [0 .1 .2 .3 .4 .5 .6 .7 .8 .9 1];
end
warea_list = gD.warea_list;

for iMD=1:length(DECODE_MODEL_LIST)
 
strModel = DECODE_MODEL_LIST{iMD}
%strModel = 'MergedByVest';
% strModel = 'MergedByVestmeanLH';
%strModel = 'MergedByLearnedMNRmeanLH';
%strModel = 'MergedByLearnedMNR';

for iTH=1:length(TEST_HEADING_LIST)
    gD.est.dSelfMotion = TEST_HEADING_LIST(iTH);
%gD.est.dSelfMotion = 90;
dSelfMotion = gD.est.dSelfMotion;

% run
tot_bias_w_obj=[];
tot_sensitivity_ratio=[];
tot_pred_thres = []; tot_emp_thres = []; tot_std_wo_obj=[]; tot_arBias=[]; tot_arStd=[];
nT=10;
for iT=1:nT
    iT
% compute cue combination and bias effect
[warea_list bias_w_obj std_wo_obj sensitivity_ratio predicted_thres emperical_thres arBias arStd] = ...
    CompareCueComb_Bias_fWeight_MNR(strModel, dSelfMotion, 0, warea_list);
tot_bias_w_obj(iT,:) = bias_w_obj;
tot_sensitivity_ratio(iT,:) = sensitivity_ratio;
tot_pred_thres(iT,:) = predicted_thres;
tot_emp_thres(iT,:) = emperical_thres;
tot_std_wo_obj(:,:,iT) = std_wo_obj;
% [cong, opp, tot] * [vest, vis, comb) * obj_prob * session # (accumulated across sessions by callee)
tot_arBias(:,:,:,iT) = arBias;
tot_arStd(:,:,:,iT) = arStd;
end
% % test emperical threshold difference
% anova1(tot_emp_thres)
% anova1(tot_emp_thres(:, 2:end))
% % test cue combination effect difference
% [p at stats] = anova1(tot_sensitivity_ratio)
% multcompare(stats)
% % test bias effect
% [p at stats] = anova1(tot_bias_w_obj)
% multcompare(stats)

%dfile = [DATA_DIR 'Cuecomb_vs_WeightIdx_n' num2str(gD.nCell) '_' strModel '_n' num2str(gD.tr.nTrial) '.mat']
dfile = [DATA_DIR 'Cuecomb_' strModel '_d' num2str(dSelfMotion) '_n' num2str(gD.tr.nTrial) '.mat']
%dfile = [DATA_DIR 'Cuecomb_vs_WeightIdx_LearnByVestRsp_n' num2str(gD.nCell) '_' strModel '_n' num2str(gD.tr.nTrial) '.mat']
save(dfile, 'warea_list','tot_bias_w_obj','tot_sensitivity_ratio', 'tot_pred_thres', 'tot_emp_thres','tot_std_wo_obj', 'tot_arBias','tot_arStd');

end % TEST_HEADING_LIST

end % DECODE_MODEL_LIST

end % DATA_FILE_LIST