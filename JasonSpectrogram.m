function JasonSpectrogram(data,fs,subplot_pos,titledata)
%Jason's version of spectrogram
%   Detailed explanation goes here
ax = subplot(312);
[~,F,T,P] = spectrogram(data,128,120,3200,fs,'yaxis');
imagesc((T-0.040)*1000, F, 10*log10(P+eps)) % add eps like pspectrogram does
% xlim([0, 250]);
% ax(2).YDir = 'normal';
ax.Position = ax.Position + subplot_pos; 
axis xy; ylabel('Frequency (Hz)');
% h = colorbar; h.Label.String = 'Power/frequency (dB/Hz)'; h.Location = "westoutside";clim([-120 -40])
ylim([0,500]); %xticks([0 125 250]);
title(['Spectrogram: CCAC = ',num2str(titledata,'%.2f')]);
end