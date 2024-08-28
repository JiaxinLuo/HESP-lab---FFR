function [f,FFTdata,ComplexFFT] = JasonFFT(data,Fs)
% Jason's FFT setup
Win = hanning(length(data));
% Win = kaiser(length(data),2);
data = data.*Win';
Signal = [zeros(1,round((Fs-length(data))/2)),data,zeros(1,round((Fs-length(data))/2))];
% Signal = data;
L = length(Signal);% non-padded to match FFR
% L = Fs; % padded to have freq bin size=1Hz; Fs = 4800 for 170Da

f = linspace(0, Fs/2, L/2+1);
Y = fft(Signal,L);

P2 = abs(Y/length(Signal)); % was Siglength 07/14/2022
P2ComplexFFT = Y/length(Signal);
ComplexFFT = P2ComplexFFT(1:L/2+1);
% P2 = abs(Y);
P1 = P2(1:L/2+1);
% P1(2:end-1) = 2*P1(2:end-1);

FFTdata = P1;
end