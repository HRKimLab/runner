function ret = run_train(DATA_DIR)
% an example function dispatched to runner machine.
% used to get pilot results in Kim et al 2016, JNP 
global gD
global tc_gain_ext

% tc_gain_ext = 1;
tc_gain_ext = 1;

% DATA_DIR = '.\Data_decByVest_gain1\N320_bimodal_hVestVAmp_r1\';
% DATA_DIR = '.\Data_decByVest_gain1\N320_equalstep_CAmp_r1\';
load([DATA_DIR 'pref_dist'])
% train network and get weights
% nTrain = 50000; % ? - 3/28/2014
nTrain = 200000;
% nTrain = 10000;
sObject = 'wObj';
gD.tr = [];
gD.tr.dSelfMode = 'Multi_fine'; %'Two_fine'; %'Random' % 'Two'%;, 'Uniform', 
[gD.tr.Coh gD.tr.answer gD.tr.choice gD.w] = TrainWeightArray3(gD.pref, nTrain, sObject, 1, 1);  % use v3. HRK 8/8/2014
weight_data = CompareWeight_LLRatioContrib();
% plot performance over time
[gD.tr.threshold gD.tr.lapse_rate] = PlotBehPerf(gD.tr.answer, gD.tr.choice, gD.tr.Coh);
fname = ['train_t' num2str(nTrain) '_' gD.tr.dSelfMode '_' sObject '.mat'];
save([DATA_DIR fname], 'gD');


sObject = 'woObj';
gD.tr = [];
gD.tr.dSelfMode = 'Multi_fine'; %'Two_fine'; %'Random' % 'Two'%;, 'Uniform', 
[gD.tr.Coh gD.tr.answer gD.tr.choice gD.w] = TrainWeightArray3(gD.pref, nTrain, sObject, 1, 1);  % use v3. HRK 8/8/2014
weight_data = CompareWeight_LLRatioContrib();
% plot performance over time
[gD.tr.threshold gD.tr.lapse_rate] = PlotBehPerf(gD.tr.answer, gD.tr.choice, gD.tr.Coh);
fname = ['train_t' num2str(nTrain) '_' gD.tr.dSelfMode '_' sObject '.mat'];
save([DATA_DIR fname], 'gD');
