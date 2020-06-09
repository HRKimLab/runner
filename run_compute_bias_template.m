function run_compute_bias(DATA_DIR_LIST)
% an example function dispatched to runner machine.
% used to get pilot results in Kim et al 2016, JNP 
DATA_DIR_LIST={'.\Data_decByVest_gain1_spdtuning\N320_bimodal_hVestVAmp_r1\', ...
    '.\Data_decByVest_gain1_spdtuning\N320_bimodal_hVestVAmp_r2\'};

MergeMNRWeights(DATA_DIR_LIST);
close all;

for iDL=1:length(DATA_DIR_LIST)
DATA_DIR = DATA_DIR_LIST{iDL}

compute_bias(DATA_DIR);

close all
end
