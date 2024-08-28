function [HarmonicsLoc,HarmonicsOvernonH,HnHstd,LIA,halfCorrScore] = HnHAutoCorr(dataOrg,Fs,Initials,plotStatus)
%AutoCorr auto-correlation of the signal

NormFactor = sum(dataOrg.*dataOrg);
% NormFactor = 1;
time = 1/Fs:1/Fs:((length(dataOrg))/Fs);
corrScore = nan(size(dataOrg));

for i = 1:length(dataOrg)
    c = i-1;
    dataCopy = [dataOrg((end-c+1):end),dataOrg(1:(end-c))];
%     dataCopy = [dataOrg((end-i+1):end),dataOrg(1:(end-i))];
    corrScore(i) = sum(dataCopy.*dataOrg)/NormFactor;
%     corrScore(i) = abs(sum(dataCopy.*dataOrg)/NormFactor); % take the abs value of autocorrelation
%     figure(1);
% %     yyaxis left
%     plot(time,dataCopy,'r','LineWidth',1.5); hold on
%     plot(time,dataOrg,'b','LineWidth',1);
% %     ylabel('Amplitude');
% %     ylim([-3 1])
% %     yyaxis right
%     plot(time,corrScore-2,'k');
%     legend('Sliding data Copy','Original Data','AutoCorrScore-2')
%     title(['Auto Correlation', Initials]);
%     xlabel('time shift(s)');ylabel('Amplitude');
%     hold off
%     ylim([-3,1])
%     exportgraphics(gcf,[Initials, '_AC_Animated.gif'],'Append',true);
end

% corrScore = highpass(corrScore,70,Fs); % filter out the large AC value for small Tau

halfCorrScore = corrScore(1:round(length(corrScore)/2+1));
[pksmax,pksidx] = findpeaks(halfCorrScore);
[dataMax,idx] = max(corrScore(pksidx));

% LIAcos = cos(2*pi*100*time(1:length(halfCorrScore)));
% LIA = LockInAmp(halfCorrScore,LIAcos,Fs,);
LIA = nan(1);
%% Plot
if strcmp(plotStatus,'plot')
    titlename = ['AutoCorr-', char(Initials)]';
    figure('Name',titlename,'NumberTitle','off');
    fig = plot(time,corrScore,'b','LineWidth',1.5); hold on
%     peaksplot = plot(time(pksidx),corrScore(pksidx),'ro');
%     maxplot = plot(time(pksidx(idx)),corrScore(pksidx(idx)),'ko','LineWidth',2);
    hold off;
    ax = gca;
    ax.FontSize = 15;
    title(titlename');
    xlabel('time shift(s)');ylabel('AutoCorrelationScore');
    ylim([-1 1]);
end
%% FFT and take Har/nonHar
[HarmonicsLoc,HarmonicsOvernonH,HnHstd] = HnHFFR(halfCorrScore,Fs,Initials,'Auto Correlation',plotStatus);

end