function [all_corrs,all_lags,Cmax,CmaxLag] = FFRsrcorr(Stim,Signal,Prestim,WinStart,WinEnd,MaxTau,Fs)
%FFRCrossCorrelation measures the absolute time shift Tau/r for best phase-locking between stimulus and signal

% Fs = 12000;

startPt = round(((Prestim+WinStart)*Fs));
stopPt = round((Prestim+WinEnd)*Fs);

for n = 1:Fs*MaxTau+1
    SigWindow = Signal(startPt+(n-1) : stopPt+(n-1)-1)/max(Signal);
    StimWindow = Stim/max(Stim);
    all_corrs(n) = mean(SigWindow.*StimWindow);
%     all_corrs(n) = mean(fisher(SigWindow).*fisher(StimWindow));
    all_lags(n) =  (n-1)/(Fs/1000);
end

[Cmax,CmaxIdx] = max(all_corrs(0.005*Fs:0.011*Fs)); % Only find max corr in 5~11 ms range
CmaxLag = all_lags(CmaxIdx+round(0.005*Fs)); % put back the range boundary
% figure; plot(all_lags,all_corrs)
% figure(1000);
% plot(all_lags,all_corrs)

end
