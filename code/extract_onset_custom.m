function o = extract_onset_custom(file,ext_params,outputlocation)
% o = extract_onset_custom(file,ext_params)
%
% extraction parameters:
% 1.  Contrast: A threshold value in which a given local
%            maximum will be considered as a peak if the difference of 
%            amplitude with respect to both the previous and successive 
%            local minima (when they exist) is higher than the threshold 
%            cthr.
% 2.  Threshold: A threshold value in which a 
%            given local maximum will be considered as a peak if its
%            normalized amplitude is higher than this threshold. 
% 3.  Resonance:A threshold value which removes peaks whose abscissa 
%            distance to one or several higher peaks is lower 
%            than a given threshold.
% 4.  Frequency cut-off upper in Hz (cut anything above this frequency)
% 5.  Frequency cut-off low in Hz (cut anything below this frequency)
%
% T. Eerola, 21/12/2017 for IEMP

disp(strcat('Processing: ',file))

if nargin<2,
    ext_params(1,:)=[0.1 0.125 0.06 900]; % default values
end
tic
a_low = mirfilterbank(file,'Manual',[-Inf ext_params(4)],'Hop',1);             % Frequency Filtering, default 900Hz (cut anything above)
a_low = mirenvelope(a_low,'Tau',0.01,'HalfwaveDiff','Smooth',2,'Normal');      % low-pass filtering for 0.01 + Halfwave differencing + Smoothing with average of order 2 .
o_low = mirpeaks(a_low,'Contrast',ext_params(1),'Threshold',ext_params(2),'Reso',ext_params(3),'Loose','Order','abscissa'); 
[time,ampl] = mirgetdata(o_low); b=[time ampl]; o = sortrows(b,1); o(1,:)=[];

%fn = fullfile(outputlocation,strcat(file,'_extracted_onsets.csv'))
dlmwrite(outputlocation, o,'precision','%.6f');
%% TIME
t = toc;
disp(strcat('Elapsed time: ',num2str(t)))
