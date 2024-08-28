function [HarmonicsLoc,NormHnH,HnHstd,P1] = HnHFFR(data,Fs,Initials,type,plotStatus)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here
Signal = data;
[f,P1] = JasonFFT(Signal,Fs);

Harmonics = 100:100:2300;

HarmonicsAmp = []; 
HarmonicsLoc = [];
nonHarExclude = [];
for i = 1:length(Harmonics)
    [c, idx] = min(abs(f-Harmonics(i)));
HarmonicsLoc(i) = f(idx);
HarmonicsAmp(i) = P1(idx);
nonHarExclude(i) = idx;

% idx = abs(f-Harmonics(i))<10;
% HarmonicsLoc = [HarmonicsLoc, f(idx)];
% HarmonicsAmp = [HarmonicsAmp, P1(idx)];

end
nonHarmonicsAmp = P1;
nonHarmonicsAmp(nonHarExclude) = [];

HarmonicsOvernonH = mean(HarmonicsAmp)/mean(nonHarmonicsAmp);
NormFactor = max(HarmonicsAmp)/mean(nonHarmonicsAmp);
NormHnH = HarmonicsOvernonH;
HnHstd = std(HarmonicsAmp/mean(nonHarmonicsAmp));

%% FFT plot
if strcmp(plotStatus,'plot')
        titlename = ['FFT of ', type, '--',char(Initials)]';
        figure('Name',titlename,'NumberTitle','off');
        fig = plot(f,P1,'b','LineWidth',1.5);
        ax = gca;
        ax.FontSize = 24;
        title(titlename')
        xlabel('Frequency (Hz)');
        ylabel('Amplitude');
        xlim([0 1000]);
        % ylim([0 0.01]);
%         set(gca,'xtick', 0:100:2400);
        grid on
end
end