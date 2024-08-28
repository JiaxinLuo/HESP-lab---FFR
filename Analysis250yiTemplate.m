%%
clc
clear
set(0,'DefaultFigureWindowStyle','docked') %Put all figures in docked mode
%% Stimulus sounds -- 250 ms Yi
% choose which yi .wav file to use:
StimTypeAll = {'yi2','yi4'}; % 'yi2' or 'yi4'
report = [];
for i = 1:2
    StimType = char(StimTypeAll{i});
yi = audioread(['./' StimType '_48khz_RMSadjusted.wav']);
% Parameters
Fs250 = 3200; % Sampling Frequency
L250 = Fs250; % FFT signal length
Prestim = 0.040; % Prestimulus Noise Floor Length
PrestimWindow = (-Prestim+1/Fs250):1/Fs250:0; % Time window for Prestim
EntireResponse = 1/Fs250:1/Fs250:0.250; % Time window for Entire Response (0~250ms)
% Process stimulus
ResampledYi250 = resample(yi',Fs250,48000);                 % resample signal
N = 2; [B,A] = butter(N,[80 1000]/(Fs250/2),'bandpass');    % set 2nd order butterworth filter
ResampledFilteredYi250 = filtfilt(B,A,ResampledYi250);      % filter resampled signal
% build stimulus for plotting:
Stimulus = [zeros(1,0.040*Fs250) ResampledFilteredYi250 zeros(1,0.030*Fs250)];
% %%
% Plot stimulus
figure('Name',['Stim:250msYi--',StimType],'NumberTitle','off');
ax(1) = subplot(311);
plot(-40+1000/Fs250:1000/Fs250:280,Stimulus);
xlim([-40 250]); ylim([-2 2]);title('Stimulus')
subplot_pos = [ax(1).Position(3)*0.04/0.290, 0, -ax(1).Position(3)*0.04/0.29, 0]; % set subplot size
% Spectrogram
JasonSpectrogram(Stimulus,Fs250,subplot_pos,0); title('Spectrogram');
h = colorbar; h.Label.String = 'Power/frequency (dB/Hz)'; h.Location = "westoutside";clim([-120 -40])

% F0 tracking parameters:
window_size = 0.04; % 40 ms
step_size = 0.01;   % 10 ms
start_time = -0.040;  % 10 ms
end_time = 0.280;    % 260 ms
lags = round([0e-3, 15e-3] * Fs250);  % Convert ms to samples
F0_lag_range = round([7e-3, 11e-3] * Fs250);  % Convert ms to samples
[F0_contour_stimulus,correlation_scores_stimulus] = F0tracking(Stimulus,Fs250,window_size,step_size,start_time,end_time,lags,F0_lag_range,'plot',subplot_pos,zeros(1,29));
h = colorbar; h.Label.String = 'Autocorrelation (r)'; h.Location = "westoutside";clim([-1 1])
title('Autocorrelogram');
%% Data Extraction -- 250 ms Yi
% [subjs,datafilepathBlockOne,datafilepathBlockTwo] = FFRsplitBiologic('./Mandarin_data/Yi4'); % function input: study folder path  
% function input: study folder path; Candidates:['./Fudan_TrialDataAuto/'  './Fudan_IncreasingIntensity/']
[subjs,datafilepathBlockOne,datafilepathBlockTwo,Cond,ID,SubjsAvgBlk] = FFRsplitBiologicYi(['./Fudan_TrialDataAuto/' StimType]); 
channel = 1;
dataBlockOne = [];
dataBlockTwo = [];
for i = 1:length(subjs)
    subjs{i,2} = ReadAEP2ASCII(datafilepathBlockOne{i});
    subjs{i,3} = ReadAEP2ASCII(datafilepathBlockTwo{i});
    dataBlockOne(i,:) =  detrend(subjs{i,2}.data.avg(channel,:));
    dataBlockTwo(i,:) =  detrend(subjs{i,3}.data.avg(channel,:));
%     audiowrite([subjs{i,1},'.wav'],(detrend(subjs{i,2}.data.avg)+detrend(subjs{i,3}.data.avg))/2,Fs250)
end
DATAavg = (dataBlockOne+dataBlockTwo)/2;
%%
% [Yi250data,ProcessedDataAvg] = DataAnalysis250Yi(subjs,ResampledFilteredYi250,Fs250,L250,Prestim,PrestimWindow,EntireResponse,StimType);
[Yi250data,ProcessedDataAvg] = DataAnalysis250Yi(SubjsAvgBlk,ResampledFilteredYi250,Fs250,L250,Prestim,PrestimWindow,EntireResponse,StimType);

report = [report,Yi250data'];
end