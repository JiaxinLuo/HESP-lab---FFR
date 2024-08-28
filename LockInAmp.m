function [LIA] = LockInAmp(data,stim,Fs,Initials,plotStatus)
% Inspired by Lock-In Amplifier
% https://dsp.stackexchange.com/questions/30069/finding-the-amplitude-of-a-sinusoid-in-noise
time = 1/Fs:1/Fs:((length(data))/Fs);
data = data/max(data);
stim = stim/max(stim);
% LIA = dot(data,stim);
LIA = dot(data,stim)/dot(stim,stim);
% LIA = sum(data.*stim)/sqrt(sum(data.^2)*sum(stim.^2));
% LIA = dot(data,stim)/dot(data,data);
% LIA = mean(data.*stim)/mean(stim.*stim);

%% plot
[f_data,P1_data] = JasonFFT(data,Fs);
[f_stim,P1_stim] = JasonFFT(stim,Fs);

if strcmp(plotStatus,'plot')
figurename = ['CCAC-', char(Initials)]';
titlename = ['AC-', char(Initials)]';
    figure('Name',figurename,'NumberTitle','off');

    subplot(221)
    fig = plot(time,data,'b','LineWidth',1.5); hold on
    hold off;
    ax = gca;
    ax.FontSize = 15;
    title([titlename']);
    xlabel('time shift(s)');ylabel('AutoCorrelationScore');
    ylim([-1 1]);

    subplot(223)
    plot(time,stim,'b','LineWidth',1.5);
    ax = gca;
    ax.FontSize = 15;
    title([titlename','-Stim']);
    xlabel('time shift(s)');ylabel('AutoCorrelationScore');
    ylim([-1 1]);

    subplot(222);
    plot(f_data,P1_data,'b','LineWidth',1.5); hold on
    hold off;
    ax = gca;
    ax.FontSize = 15;
    title(['FFT: ',titlename']);
xlabel('frequency (Hz)'); ylabel('Magnitude');    
    subplot(224);
    plot(f_stim,P1_stim,'b','LineWidth',1.5); hold on
    hold off;
    ax = gca;
    ax.FontSize = 15;
    title(['FFT: ',titlename','-stim']);
xlabel('frequency (Hz)'); ylabel('Magnitude');
end
end

