%%
clc
clear
set(0,'DefaultFigureWindowStyle','docked') %Put all figures in docked mode
%% Stimulus sounds -- 250 ms Yi
yi = audioread('./yi4_48khz_RMSadjusted.wav');
% yi = audioread('./Stimulus/yi4_48khz_RMSadjusted.wav');

% Parameters
Fs250 = 3200; % Sampling Frequency
L250 = Fs250; % FFT signal length
Prestim = 0.040; % Prestimulus Noise Floor Length
PrestimWindow = (-Prestim+1/Fs250):1/Fs250:0; % Time window for Prestim
EntireResponse = 0.005:1/Fs250:0.270; % Time window for Entire Response (5~270ms)
Transition = 0.020:1/Fs250:0.060; % Time window for Transition (20~60ms)
SteadyState = 0.060:1/Fs250:0.170; % Time window for Steady State (60~170ms)Fs170 = 4800;
% Process stimulus
FilteredYi250 = bandpass(yi',[70 1000],48000); 
ResampledFilteredYi250 = resample(FilteredYi250,Fs250,48000);
figure('Name','Stim:250msYi','NumberTitle','off');
plot(1000/Fs250:1000/Fs250:250,ResampledFilteredYi250);grid on
xlim([-40 280])

%% Data Extraction -- 250 ms Yi
[subjs,datafilepathBlockOne,datafilepathBlockTwo] = FFRsplitBiologic('./Mandarin_data/Yi4'); % function input: study folder path  

dataBlockOne = [];
dataBlockTwo = [];
for i = 1:length(subjs)
    subjs{i,2} = ReadAEP2ASCII(datafilepathBlockOne{i});
    subjs{i,3} = ReadAEP2ASCII(datafilepathBlockTwo{i});
    dataBlockOne(i,:) =  detrend(subjs{i,2}.data.avg);
    dataBlockTwo(i,:) =  detrend(subjs{i,3}.data.avg);
end
Block1avg = mean(dataBlockOne);
Block2avg = mean(dataBlockTwo);
DATAavg = mean([Block1avg;Block2avg]);
%% Plot Individual for 250 ms Yi peak picking
time_Plot = 1000*subjs{1,2}.data.time;
for num = 1:size(subjs,1)
    Initial = subjs{num,1};
    %data = FdataBlockTwo(num,:); % Check single block
    data = mean([dataBlockOne(num,:);dataBlockTwo(num,:)]);
    % [TableOutput,Peaks] = FFRpeaks(data,Fs,0.0158);
    figure('Name',Initial,'NumberTitle','off');% Plot
    plot(time_Plot,data,'b');
    ax = gca;    ax.FontSize = 24;
    title(Initial);    xlabel('Time (ms)');    ylabel('Amplitude (\muV)');
    xlim([-40 280]);    ylim([-1 1]);
end
%%
Yi250data = DataAnalysis250Yi(subjs,ResampledFilteredYi250,Fs250,L250,Prestim,PrestimWindow,EntireResponse,Transition,SteadyState);

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
