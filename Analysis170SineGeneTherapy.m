%%
clear
set(0,'DefaultFigureWindowStyle','docked') %Put all figures in docked mode
%% Stimulus sounds -- 170ms Sine
Sine170 = audioread('./170msRampedSine.wav');
% Parameters
Fs170 = 4800; % Sampling Frequency
L170 = Fs170; % FFT signal length
Prestim170 = 0.020; % Prestimulus Noise Floor Length
PrestimWindow = (-Prestim170+1/Fs170):1/Fs170:0; % Time window for Prestim
EntireResponse170Sine = 1/Fs170:1/Fs170:0.170; % Time window for Entire Response (5~180ms)
Transition = 0.020:1/Fs170:0.060; % Time window for Transition (20~60ms)
SteadyState = 0.060:1/Fs170:0.170; % Time window for Steady State (60~170ms)Fs170 = 4800;
% Process stimulus
% FilteredSine170 = bandpass(Sine170,[70 1000],48000); 
ResampledSine170 = resample(Sine170,Fs170,48000)';
% figure('Name','Stim:170Sine','NumberTitle','off');
% plot(1/4.8:1/4.8:170,ResampledSine170);grid on
% xlim([-20 200])
%% Data Extraction -- 170ms Sine
[SINEsubjs,SINEdatafilepathBlockOne,SINEdatafilepathBlockTwo,Conditions,subjID] = FFRsplitBiologic('./Fudan 100Hz'); % function input: study folder path  

SINEdataBlockOne = [];
SINEdataBlockTwo = [];
for i = 1:length(SINEsubjs)
    SINEsubjs{i,2} = ReadAEP2ASCII(SINEdatafilepathBlockOne{i});
    SINEsubjs{i,3} = ReadAEP2ASCII(SINEdatafilepathBlockTwo{i});
    SINEdataBlockOne(i,:) =  detrend(SINEsubjs{i,2}.data.avg);
    SINEdataBlockTwo(i,:) =  detrend(SINEsubjs{i,3}.data.avg);    
end
BOneSINEavg = mean(SINEdataBlockOne);
BTwoSINEavg = mean(SINEdataBlockTwo);
SINEavg = mean([BOneSINEavg;BTwoSINEavg]);
%% Plot Individual for SINE peak picking
for num = 1:size(SINEsubjs,1)
    Initial = SINEsubjs{num,1};
    data = mean([SINEdataBlockOne(num,:);SINEdataBlockTwo(num,:)]);
    % [TableOutput,Peaks] = FFRpeaks(data,Fs,0.020);
    %FilteredData = bandpass(data,[70 2000],Fs);
    figure('Name',Initial,'NumberTitle','off');% Plot
    plot(1000*SINEsubjs{1,2}.data.time,data,'b','LineWidth',1.5);
    ax = gca;
    ax.FontSize = 24; 
    title(Initial, 'FontSize', 24);
    xlabel('Time (ms)', 'FontSize', 24);
    ylabel('Amplitude (\muV)', 'FontSize', 24);
    ylim([-0.7 0.7]);
    xlim([-20 200]);
end

% Sine170data = DataAnalysis170Sine(SINEsubjs,ResampledSine170,Fs170,L170,Prestim170,PrestimWindow,EntireResponse170Sine,Transition,SteadyState);
[Yi250data,ProcessedDataAvg] = DataAnalysis170Sine(SINEsubjs,ResampledSine170,Fs170,L170,Prestim170,PrestimWindow,EntireResponse170Sine,'100 Hz PureTone');

% %% Plot Average subject
% Nsubj = length(subjID);
% Ncondition = length(Conditions);
% AvgSubjs = Conditions';
% for num = 1:Ncondition
%     Initial = Conditions(num);
%     AvgSubjs{num,2} = mean(SINEdataBlockOne(((num-1)*Nsubj+1):(num*Nsubj),:));
%     AvgSubjs{num,3} = mean(SINEdataBlockTwo(((num-1)*Nsubj+1):(num*Nsubj),:));
%     data = mean([SINEdataBlockOne(((num-1)*Nsubj+1):(num*Nsubj),:);SINEdataBlockTwo(((num-1)*Nsubj+1):(num*Nsubj),:)]);
%     % [TableOutput,Peaks] = FFRpeaks(data,Fs,0.020);
%     %FilteredData = bandpass(data,[70 2000],Fs);
%     figure('Name',char(Initial),'NumberTitle','off');% Plot
%     plot(1000*SINEsubjs{1,2}.data.time,data,'b','LineWidth',1.5);
%     ax = gca;
%     ax.FontSize = 24; 
%     title(Initial, 'FontSize', 24);
%     xlabel('Time (ms)', 'FontSize', 24);
%     ylabel('Amplitude (\muV)', 'FontSize', 24);
%     ylim([-0.7 0.7]);
%     xlim([-20 200]);
% end
% Sine170dataAvgSubjs = DataAnalysis170SineAvgSubjs(AvgSubjs,ResampledSine170,Fs170,L170,Prestim170,PrestimWindow,EntireResponse170Sine,Transition,SteadyState);
%% Data Analysis and Compiling into Excel

%% Save Figure
% 
% FolderName = './FFR-170DaVsSine';   % destination folder
% FigList = findobj(allchild(0), 'flat', 'Type', 'figure');
% FigHandle = [];
% FigName = [];
% for iFig = 1:length(FigList)
%   FigHandle(iFig) = FigList(iFig);
% %   FigName(iFig)   = get(FigHandle(iFig), 'Name');
% end
%   savefig(FigHandle, '170DaVsSine.fig');
