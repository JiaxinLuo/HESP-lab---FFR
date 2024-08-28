function [DataExcelFinal,ProcessedDataAvg] = DataAnalysis170Sine(data,Stim,Fs,L,Prestim,PrestimWindow,EntireResponse,StimType)
%DataAnalysis This function runs the analysis for all subjects in input and
%output all the values together
Initials = data(:,1);
Pre = round(Fs*Prestim) + round(Fs*(PrestimWindow));
ER = round(Fs*Prestim) + round(Fs*(EntireResponse));  % Entire Response 
% F0 tracking parameters:
window_size = 0.04; % 40 ms
step_size = 0.01;   % 10 ms
start_time = 1/Fs;  % 10 ms
end_time = 0.17;    % 260 ms
lags = round([0e-3, 15e-3] * Fs);  % Convert ms to samples
F0_lag_range = round([7e-3, 11e-3] * Fs);  % Convert ms to samples
%%
ProcessedDataAvg = [];
channel = 1;    
N = 12; [B,A] = butter(N,[80 1000]/(Fs/2),'bandpass');    % set 12th order butterworth filter
filteredStim = filtfilt(B,A,Stim);

for i = 1:size(data,1)
    DataAvg = mean([data{i,2}.data.avg(channel,:);data{i,3}.data.avg(channel,:)]);
%     DataAvg = filtfilt(B,A,DataAvg);    % apply bandpass filter
    ProcessedDataAvg(i,:) = DataAvg; % record processed data
    
    % SNR:
    [ERDataAlldBSNR(i),ERDataAllSNR(i),ERDataRMSNoise(i),ERDataRMSSignal(i)] = FFRSNR(DataAvg,EntireResponse,Fs,Prestim); % Entire Response (10~260 ms)

    time_Plot = 1000*data{1,2}.data.time;
    figure('Name',[char(StimType),'--', char(Initials(i))],'NumberTitle','off');% Plot
    ax(1) = subplot(311);
    plot(time_Plot(Pre),DataAvg(Pre),Color=[0.5 0.5 0.5]); hold on
    plot(time_Plot(round(Fs*Prestim):end),DataAvg(round(Fs*Prestim):end),'k')
    legend(['Noise RMS = ' num2str(ERDataRMSNoise(i),'%.3f')],['FFR RMS = ' num2str(ERDataRMSSignal(i),'%.3f')],'none',Location="northwest",box='off');
    Leg = legend; Leg.AutoUpdate = 'off';
    xline(0,'r--',LineWidth=2);
%     ax = gca;    ax.FontSize = 24;
%     xlabel('Time (ms)');     
    ylabel('Amplitude (\muV)'); 
    xlim([-20 200]);    ylim([-3 3]); title([char(Initials(i)),': SNR (dB) = ', num2str(ERDataAlldBSNR(i),'%.3f')]);    
    subplot_pos = [ax(1).Position(3)*0.04/0.290, 0, -ax(1).Position(3)*0.04/0.29, 0]; % set subplot size

    % FFT:
    % F0 (100Hz)
    %     [PF0Mean(i),PF0SD(i),PF0PeakAmp(i),PF0PeakLoc(i)] = FFRFFT170Da(DataAvg,L,PrestimWindow,Fs,Prestim,100,Initials(i));
    %     [ERF0Mean(i),ERF0SD(i),ERF0PeakAmp(i),ERF0PeakLoc(i)] = FFRFFT170Da(DataAvg,L,EntireResponse,Fs,Prestim,100,Initials(i));
    % CCAC:
    [CCACscore(i)] = CCAC(DataAvg(ER),filteredStim,Fs,Initials(i),'unplot');
    ax(2) = subplot(312);
    JasonSpectrogram(DataAvg,Fs,subplot_pos,CCACscore(i));

    % F0 tracking:
    [F0_contour_stimulus,correlation_scores_stimulus] = F0tracking(Stim,Fs,window_size,step_size,start_time,end_time,lags,F0_lag_range,'noplot',subplot_pos,ones(1,14));
    [F0_contour_FFR,correlation_scores_FFR] = F0tracking(DataAvg,Fs,window_size,step_size,start_time,end_time,lags,F0_lag_range,'plot',subplot_pos,F0_contour_stimulus);
    F0_tracking_accuracy(i) = corr(F0_contour_stimulus', F0_contour_FFR');

    % Cross-Correlation (R-S):
    [Datac,Datalags,DataCmax(i),DataCmaxLag(i)] = FFRsrcorr(filteredStim,DataAvg,Prestim,0.000,0.170,0.015,Fs);

    % Block-Correlation:
    %     ERDataPearsonrBC(i) = nancorrcoef(fisher(DataB1(ER)),fisher(DataB2(ER))); % Entire Response (10-260 ms) Pearson Correlation
    % Phase-Amplitude Coupling:
    %     PAC = PhaseAmplitudeCoupling(SteadyStateStim,DataAvg(SS),Fs,Initials(i));
    % Vector Strength:
    %     VS = VectorStrength(SteadyStateStim,DataAvg(SS),Fs,Initials(i));
    % AutoCorrelation H/nH:
%     [Harmonics,AC_HarOvernonH(i),AC_HnHstd(i)] = HnHAutoCorr(DataAvg(ER),Fs,Initials(i),'unplot');
%     [Noise_AC_Harmonics,AC_N_HarOvernonH(i),AC_HnHstd_Noise(i)] = HnHAutoCorr(DataAvg(Pre),Fs,['Noise-', char(Initials(i))],'unplot');
    % H/nH on FFR:
%     [FFR_HarmonicsLoc,FFR_HnH(i),FFR_HnHstd(i),FFTP1] = HnHFFR(DataAvg(ER),Fs,Initials(i),'FFR','unplot');
%     [Noise_FFR_HarmonicsLoc,FFR_N_HnH(i),FFR_HnHstd_Noise(i),FFTP1_Noise] = HnHFFR(DataAvg(Pre),Fs,Initials(i),'FFR prestim','unplot');
    % FFR&stim--LockInAmp:
%     [A(i)] = LockInAmp(DataAvg(ER),Stim,Fs,Initials(i),'unplot');

end

DataExcel = num2cell([ERDataRMSNoise;ERDataRMSSignal;ERDataAllSNR;CCACscore;F0_tracking_accuracy;DataCmaxLag;fisher(DataCmax)]);
DataNames = {'Initials','RMS:Baseline','RMS:FFR','SNR(dB)','CCAC','F0 tracking','R-S Lag','R-S Correlation Max'};

% Initials = data(:,1);
DataExcelFinal = [DataNames;Initials,DataExcel'];

end

