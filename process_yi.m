clear
close all
clc
rampdur = 0.01; % 10ms on/off ramp
%%
[Da170,fs170] = audioread('DAbase_48khz_RMSAdjusted.wav');
RMS_Da170 = rms(Da170);
figure(1);
subplot(211)
spectrogram(Da170,128,127,'yaxis')
subplot(212)
plot(Da170);

%%
file_name = 'yi2.wav';
[yi2_raw, fs] = audioread(file_name);
yi2_48 = resample(yi2_raw, fs170, fs);      % resample to 48 kHz
% yi2_48_ramped = ramp(yi2_48,fs170,rampdur); % set on/off ramp
RMS_yi2 = rms(yi2_48);
yi2 = RMS_Da170/RMS_yi2*yi2_48;            % rms match calibrated Da170 stim
audiowrite('yi2_48khz_RMSadjusted.wav', yi2,fs170,'BitsPerSample',16);

t = 1/fs:1/fs:length(yi2)/fs;
figure(2);
subplot(211)
spectrogram(yi2,128,127,'yaxis')
subplot(212)
plot(yi2)
%%
file_name = 'yi4.wav';
[yi4_raw, fs] = audioread(file_name);
yi4_48 = resample(yi4_raw, fs170, fs);      % resample to 48 kHz
% yi4_48_ramped = ramp(yi4_48,fs170,rampdur); % set on/off ramp
RMS_yi4 = rms(yi4_48);
yi4 = RMS_Da170/RMS_yi4*yi4_48;            % rms match calibrated Da170 stim
audiowrite('yi4_48khz_RMSadjusted.wav', yi4,fs170,'BitsPerSample',16);

figure(4);
subplot(211)
spectrogram(yi4,128,127,'yaxis')
subplot(212)
plot(yi4)
