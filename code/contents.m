%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Onset detection evaluation
% IEMP onset detection
% T. Eerola 16-04-2017 09:57:37
% Durham University, UK
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

%% CLEAN WORKSPACE
clear all; clc; mirverbose(0); mirchunklim(1200000); mirwaitbar(0);
%fs = 44100;
%% FILE LOCATIONS
def.projectpath = '~/Dropbox/IEMP_onset_temporal_accuracy/'; cd(def.projectpath )
def.audiopath = 'audio';
def.codepath = 'code';
def.GTpath='groundtruth';
def.output = 'output';
def.audio_ext='.wav';
def.GT_ext='.csv';
ext_params=[];
params = be_params % evaluation parameters, these are from MIREX
addpath(fullfile(def.projectpath,def.codepath));
%% LIST OF FILES
clear f F
% FILENAME                                              PARAMETERS 
f{1} = '20160531_item3_take2_track4_guitarDI_38_72';    ext_params(1,:) = [0.20 0.200 0.25 210 -Inf];
f{2} = 'Guitar_fast';                                   ext_params(2,:) = [0.10 0.100 0.06 900 -Inf];
f{3} = 'Debashish_Malhar_guitar_730-830';               ext_params(3,:) =[0.20 0.200 0.25 900 -Inf];
f{4} = 'Sarod_fast';                                    ext_params(4,:) = [0.10 0.125 0.06 900 -Inf];
f{5} = 'PrattyushB_Jhinjhoti_2Gats_Sarod_Sept17';       ext_params(5,:) = [0.03 0.030 0.09 900 -Inf];
f{6} = 'Sarod_slow';                                    ext_params(6,:) = [0.10 0.125 0.06 900 -Inf];
f{7} = 'Sitar_fast';                                    ext_params(7,:) = [0.10 0.125 0.06 900 -Inf];
f{8} = 'Sitar_slow';                                    ext_params(8,:) = [0.20 0.200 0.06 900 -Inf];
f{9} = 'ShujaatKh_Jhinjhoti_Sitar_Sept17';              ext_params(9,:) = [0.05 0.090 0.09 900 -Inf];

%% EXTRACT
for i=1:length(f)
    disp(strcat(num2str(i),'/',num2str(length(f))))                       % Print diagnostics
    onsets = extract_onset_custom(strcat(fullfile(def.audiopath,f{i}), ...
        def.audio_ext),ext_params(i,:),strcat(fullfile(def.output,f{i}), ...
        def.GT_ext));                                                     % EXTRACT ONSETS AND WRITE ESTIMATED ONSETS TO OUTPUT FOLDER
    annotations = dlmread(strcat(fullfile(def.GTpath,f{i}),def.GT_ext));  % READ ANNOTATIONS
    [F(i),p,r,as] = be_fMeasure(annotations,onsets(:,1),params);          % CALCULATE F RATIO  (with a loose temporal buffer)
end
%
T = table(f',F','VariableNames', {'Filename','F'})
writetable(T,'Accuracy.csv')
