function [dBSNR,SNR,RMSNoise,RMSSignal] = FFRSNR(data,SignalWindow,Fs,Prestim)
%Compute the Signal to Noise ratio for FFR vs. Noise Floor
Signal = data(round(Fs*Prestim) + round(Fs*(SignalWindow)));
RMSSignal = rms(Signal);
Noise = data(1:round((Prestim)*Fs));
RMSNoise = rms(Noise);

SNR = RMSSignal/RMSNoise;
dBSNR = 20*log10(SNR);

end

