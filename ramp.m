function newSound = ramp(newSound,Fs,dur,rname)
% default ramp is cos
if nargin < 4
    rname = 'cos';
end

% check if newSound needs reshaped
sy = size(newSound);
if sy(1)>2
    rs = 1;
    newSound = newSound';
else
    rs = 0;
end
a = size(newSound);
nch = a(1);

%calculate number of samples in ramp
nsamp = round(dur*Fs);

% make ramp
switch rname
    case 'cos'
        tvec = [0:(pi/2)/(nsamp-1):pi/2];
        rpon = sin(tvec).^2;
        rpoff = cos(tvec).^2;
    case 'kaiser'
        rp = kaiser(2*nsamp);
        rpon = rp(1:nsamp)';
        rpoff = rp(nsamp+1:end)';
end

% apply ramp
for c = 1:nch
    newSound(c,1:nsamp) = rpon.*newSound(c,1:nsamp);
    newSound(c,end-nsamp+1:end) = rpoff.*newSound(c,end-nsamp+1:end);
end

% put newSOund back to old shape if needed
if rs==1
    newSound = newSound';
end