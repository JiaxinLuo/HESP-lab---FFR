function [CCACscore] = CCAC(data,stim,Fs,DataLabel,plotStat)
%CCAC normalized dot product of data's Autocorrelation score of and stim's Autocorrelation score

[HarmonicsLoc,HarmonicsOvernonH,HnHstd,LIA,halfCorrScore] = HnHAutoCorr(data,Fs,DataLabel,plotStat);
[HarLoc_stim,HnH_stim,HnHstd_stim,LIA_stim,halfCorrScore_stim] = HnHAutoCorr(stim,Fs,DataLabel,plotStat);

CCACscore = LockInAmp(halfCorrScore,halfCorrScore_stim,Fs,DataLabel,plotStat);

end