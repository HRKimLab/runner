function ret = run_all(DATA_DIR)
% an example function dispatched to runner machine.
% used to get pilot results in Kim et al 2016, JNP 
ret = 0;
global gSaveFig
gSaveFig = 1;
% run_train(DATA_DIR);
nSim = 10;
global tc_gain_ext;
tc_gain_ext = 1;

% compute_mnr_weights(DATA_DIR, [.1 .45 .45], [0 .25 .5 .75 1], [0 1 1], 10);

% wait until we get all files
train_fname = 'CombRsp_MLR_';
while length( FindBlockID(fullfile(DATA_DIR, train_fname)) ) < nSim
   length( FindBlockID(fullfile(DATA_DIR, train_fname) )) 
   pause(5); 
end

MergeMNRWeights({DATA_DIR});
compute_bias(DATA_DIR); 
compute_cuecombination({DATA_DIR});

ret=0; return;