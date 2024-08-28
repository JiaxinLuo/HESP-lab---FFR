function [FFTMean,FFTSD,FFTPeakAmp,FFTPeakLoc] = FFRFFT170Da(data,L,SignalWindow,Fs,Prestim,PeakFreq,Initials)
%Fast Fourier Transform for signal
Signal = data(round(Fs*Prestim) + round(Fs*(SignalWindow)));
WindowName = inputname(3);
% Signal = dataSine % Use for calibration
Siglength = length(Signal);
HannWin = hanning(Siglength);
Signal = Signal.*HannWin';

[f,P1] = JasonFFT(Signal,Fs);

% P1 = abs(Y(1:L/2+1));

% % 95% confidence interval
% sortP1 = sort(P1(1:1000));
% Threshold = sortP1(end-50+1);

% figure;
% subplot(131)
% plot(f,P1);
% % histogram(P1(1:1000),1000);
% title(['Frequency Plot -- ' Initials WindowName])
% title('P1 over f')
% xlabel('Frequency (Hz)');
% ylabel('Amplitude');

% subplot(132)
% plot(P2); hold on
% title('P2')
% % line([Threshold, sortP1(end-50)], [0, 50], 'Color', 'r', 'LineWidth', 2);
% 
% subplot(133)
% plot(abs(Y));
% title('abs(Y)')
% hold off

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

titlename = ['FFT -- ', char(Initials),  '--', char(WindowName)]';
% figure('Name',titlename,'NumberTitle','off');
subplot(212)
title(titlename')
plot(f,P1,'b','LineWidth',1.5); box off
%histogram(P1(1:1000),1000);
    ax = gca;
    ax.FontSize = 18; 
xlabel('Frequency (Hz)');
ylabel('Magnitude');
% ylim([0 0.002]);
xlim([0 1000]);

FFTMean = mean(P1(PeakFreq-10:PeakFreq+10));
FFTSD = std(P1(PeakFreq-10:PeakFreq+10));
% [FFTPeakAmp,FFTPeakIdx] = max(P1(PeakFreq-10:PeakFreq+10));
% FFTPeakLoc = PeakFreq-12+FFTPeakIdx;

FFTPeakAmp = P1(PeakFreq+1);
FFTPeakLoc = f(PeakFreq+1);
end

