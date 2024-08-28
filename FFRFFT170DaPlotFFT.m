function [FFTMean, FFTSD, FFTPeakAmp, FFTPeakLoc] = FFRFFT170DaPlotFFT(data,L,SignalWindow,Fs,Prestim,F0,Initials)
%Fast Fourier Transform for signal
Signal = data(round(Fs*Prestim) + round(Fs*(SignalWindow)));
WindowName = inputname(3);
% Signal = dataSine % Use for calibration
Siglength = length(Signal);
% L should be siglength if no padding is applied to make freq bin=1Hz:
% L = Siglength; 
HannWin = hanning(Siglength);
%Signal = Signal.*HannWin';

[f,P1] = JasonFFT(Signal,Fs);

% % 95% confidence interval
% sortP1 = sort(P1(1:1000));
% Threshold = sortP1(end-50+1);
titlename = ['FFT -- ', char(Initials)]'%,' -- ', char(WindowName)]';
figure('Name',titlename,'NumberTitle','off');
fig = plot(f,P1,'b','LineWidth',1.5); box off
%histogram(P1(1:1000),1000);
    ax = gca;
    ax.FontSize = 18; 
% title(['FFT-', Initials, WindowName], 'FontSize', 24);
title(titlename')
xlabel('Frequency (Hz)');
ylabel('Magnitude');
ylim([0 0.012]);
xlim([0 1000]);

% saveas(fig,['FFT-' char(Initials) '.jpg']);
% 
% subplot(122)
% histogram(P1(1:1000),1000); hold on
% line([Threshold, sortP1(end-50)], [0, 50], 'Color', 'r', 'LineWidth', 2);
% 
% plot(P1(100+1), 30, 'r.');text(P1(100+1), 30, 'F0')
% plot(P1(200+1), 30, 'r.');text(P1(200+1), 30, '2F0')
% plot(P1(300+1), 30, 'r.');text(P1(300+1), 30, '3F0')
% plot(P1(400+1), 30, 'r.');text(P1(400+1), 30, '4F0')
% plot(P1(500+1), 30, 'r.');text(P1(500+1), 30, '5F0')
% plot(P1(600+1), 30, 'r.');text(P1(600+1), 30, '6F0')
% 
% title(['Histogram -- ' Initials WindowName])
% xlabel('Amplitude Bin');
% ylabel('Numbers of Value in Bin');

for n = 1:5
    PeakFreq = F0*n;
FFTMean(1,n) = mean(P1(PeakFreq-10:PeakFreq+10));
FFTSD(1,n) = std(P1(PeakFreq-10:PeakFreq+10));
[FFTPeakAmp(1,n),FFTPeakIdx] = max(P1(PeakFreq-10:PeakFreq+10));
FFTPeakLoc(1,n) = PeakFreq-12+FFTPeakIdx;
end

% FFTMean = FFTMean';
% FFTSD = FFTSD';
% FFTPeakAmp = FFTPeakAmp';
% FFTPeakLoc = FFTPeakLoc';

end

