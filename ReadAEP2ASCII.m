function abr = ReadAEP2ASCII(filename)
% function abr = ReadAEP2ASCII(filename)
%
% INPUT: This function takes the single input filename, which is a string containing 
% the name of the text-file created from the AEPtoASCII program on the Biologic
% AEP computer. The extension (e.g. .Txt or .txt must be included in the 
% filename string. 
%
% OUTPUT: The output of this function is a structure called abr. abr contains
% several sub-structures with all of the data saved from the Biologic AEP
% system. The sub-structures include: 
% 
% abr.subjinfo  - Information such as Patient Name, Birth date 
% abr.testpars  - Information such as Intensity, Polarity, Epoch time (ms) 
% abr.collected - Information such as # of averages, Low/High-pass filter settings
% abr.latdata   - Latency data for all peaks that were selected in the AEP program
% abr.ampdata   - Amplitude data for all peaks that were selected in the AEP program
% abr.data      - Averaged waveforms (including rarefaction and condensation if these 
%                 were used). Also contains a time vector to help with plotting
%
% Enter these lines into the Command Window to access all of the available 
% fields/data contained within these sub-structures. 
%
% Example:
% >> abr.data
% 
% ans = 
% 
%      avg: [1x512 double]
%     cond: [1x512 double]
%     diff: [1x512 double]
%       fs: 4.8030e+04
%     rare: [1x512 double]
%     time: [1x512 double]
%
% To plot the data you would type: plot(abr.data.time,abr.data.avg)



%--------------------------------------------------------------------------
if nargin<1, filename = 'KT PT test.txt'; end


delimiterIn = ',';
[D] = importdata(filename,delimiterIn);

% Clean-up text
textdata = D.textdata(1:end-2,1);

for i=1:size(textdata,1)
    textline = textdata{i};
    qind     = strfind(textline,'"');
    textline(qind) = [];
    qind     = strfind(textline,' ');
    textline(qind) = [];
    qind     = strfind(textline,'(');
    textline(qind) = [];
    qind     = strfind(textline,')');
    textline(qind) = [];
    qind     = strfind(textline,'ms');
    if ~isempty(qind)
        for ii=1:length(qind)
            textline(qind(ii):qind(ii)+1) = 'Ms';
        end
    end
    textdata{i} = textline;
end
qind     = strfind(textdata,'Pre/Post');
i        = find(not(cellfun('isempty',qind)));
textline = textdata{i};
textline(qind{i}+3) = [];
textdata{i}         = textline;


% Subject info 
idx  = find(not(cellfun('isempty',strfind(textdata,'PatientID'))));
for i=idx
    c1 = textscan(textdata{i},'%s','delimiter',',');
    c1 = c1{:,:} ;
    
    c2 = textscan(textdata{i+1},'%s','delimiter',',');
    c2 = c2{:,:} ;
    for ii=1:size(c1,1)
        abr.subjinfo.(c1{ii,1}) = c2{ii,1};
    end
end

% Testing Pars
idx(1,1)  = find(not(cellfun('isempty',strfind(textdata,'TestType'))));
idx(1,2)  = find(not(cellfun('isempty',strfind(textdata,'Ear,Transducer'))));
for i=idx
    c1 = textscan(textdata{i},'%s','delimiter',',');
    c1 = c1{:,:} ;
    
    c2 = textscan(textdata{i+1},'%s','delimiter',',');
    c2 = c2{:,:} ;
    for ii=1:size(c2,1)
        abr.testpars.(c1{ii,1}) = c2{ii,1};
    end
end

% Collection Pars - get labels
idxCol  = find(not(cellfun('isempty',strfind(textdata,'Channel,Bank'))));
c1   = textscan(textdata{idxCol},'%s','delimiter',',');
c1   = c1{:,:} ;
abr.collected.collabels = c1(:,:)';

% Latency Data - get labels
idxLat  = find(not(cellfun('isempty',strfind(textdata,'LatencyMs'))));
c1   = textscan(textdata{idxLat},'%s','delimiter',',');
c1   = c1{:,:} ;
abr.latdata.collabels = c1(2:end,:)';

% Amplitude Data - get labels
idxAmp  = find(not(cellfun('isempty',strfind(textdata,'AmplitudeuV'))));
c1   = textscan(textdata{idxAmp},'%s','delimiter',',');
c1   = c1{:,:} ;
abr.ampdata.collabels = c1(2:end,:)';

% Collection Pars - get data
n = 1;
for i=idxCol+1:idxLat-2
    d1 = textscan(textdata{i},'%s','delimiter',',');
    d1 = d1{:,:}';
    d1 = str2double(d1);
    abr.collected.collectdata(n,:) = d1;
    
    n = n+1;
end

% Latency Data - get data
n = 1;
lns = idxLat+1:idxAmp-2;
abr.latdata.data = nan(length(lns),length(abr.latdata.collabels));
for i=lns
    d1 = textscan(textdata{i},'%s','delimiter',',');
    d1 = d1{:,:}';
    d1 = str2double(d1(2:end));
    abr.latdata.data(n,1:length(d1)) = d1;
    
    n = n+1;
end

% Amplitude Data - get data
n = 1;
lns = idxAmp+1:size(textdata,1);
abr.ampdata.data = nan(length(lns),length(abr.ampdata.collabels));
for i=lns
    d1 = textscan(textdata{i},'%s','delimiter',',');
    d1 = d1{:,:}';
    d1 = str2double(d1(2:end));
    abr.ampdata.data(n,1:length(d1)) = d1;
    
    n = n+1;
end

% Convert select strings to numbers
abr.testpars.Channels       = str2double(abr.testpars.Channels);
abr.testpars.EpochMs        = str2double(abr.testpars.EpochMs);
abr.testpars.Rate           = str2double(abr.testpars.Rate);
abr.testpars.Points         = str2double(abr.testpars.Points);
abr.testpars.PrePostTimeMs  = str2double(abr.testpars.PrePostTimeMs);
abr.testpars.BlockedTimeMs  = str2double(abr.testpars.BlockedTimeMs);

% Get sample rate and time vector
fs            = 1e3*(abr.testpars.Points/abr.testpars.EpochMs); 
abr.data.time = [0+(1/fs) : (1/fs) : (abr.testpars.EpochMs*1e-3)];
abr.data.time = abr.data.time - .001+((1/fs)*4) + (abr.testpars.PrePostTimeMs*1e-3);  % adjust time vector to match biologic plots closely as possible
abr.data.fs   = fs;

% Averaged Signals
if length(D.colheaders)==8
    abr.data.rare(1,:) = D.data(:,1)';
    abr.data.cond(1,:) = D.data(:,2)';
    abr.data.rare(2,:) = D.data(:,3)';
    abr.data.cond(2,:) = D.data(:,4)';
    abr.data.avg(1,:)  = D.data(:,5)';
    abr.data.diff(1,:) = D.data(:,6)';
    abr.data.avg(2,:)  = D.data(:,7)';
    abr.data.diff(2,:) = D.data(:,8)';
    abr.latdata.rowlabels   = {'CH1rare';'CH1cond';'CH2rare';'CH2cond';'CH1avg';'CH1diff';'CH2avg';'CH2diff'};
    abr.ampdata.rowlabels   = {'CH1rare';'CH1cond';'CH2rare';'CH2cond';'CH1avg';'CH1diff';'CH2avg';'CH2diff'};
    abr.collected.rowlabels = {'CH1rare';'CH1cond';'CH2rare';'CH2cond';'CH1avg';'CH1diff';'CH2avg';'CH2diff'};
elseif length(D.colheaders)==4
    abr.data.rare = D.data(:,1)';
    abr.data.cond = D.data(:,2)';
    abr.data.avg  = D.data(:,3)';
    abr.data.diff = D.data(:,4)';
    abr.latdata.rowlabels   = {'rare';'cond';'avg';'diff'};
    abr.ampdata.rowlabels   = {'rare';'cond';'avg';'diff'};
    abr.collected.rowlabels = {'rare';'cond';'avg';'diff'};
elseif length(D.colheaders)==1 && strcmpi(abr.testpars.Polarity,'Rarefaction')
    abr.data.rare = D.data(:,1)';
    abr.data.cond = [];
    abr.data.avg  = [];
    abr.data.diff = [];  
    abr.latdata.siglab   = {'rare'};
    abr.ampdata.siglab   = {'rare'};
    abr.collected.siglab = {'rare'};
elseif length(D.colheaders)==1 && strcmpi(abr.testpars.Polarity,'Condensation')
    abr.data.rare = [];
    abr.data.cond = D.data(:,1)';
    abr.data.avg  = [];
    abr.data.diff = [];  
    abr.latdata.siglab   = {'cond'};
    abr.ampdata.siglab   = {'cond'};
    abr.collected.siglab = {'cond'};
end

% Order the fields in the structure
abr.subjinfo  = orderfields(abr.subjinfo);
abr.testpars  = orderfields(abr.testpars);
abr.collected = orderfields(abr.collected);
abr.latdata   = orderfields(abr.latdata);
abr.ampdata   = orderfields(abr.ampdata);
abr.data      = orderfields(abr.data);

%--------------------------------------------------------------------------
function n = linecount(filename)
n = 0;
fid   = fopen(filename);
tline = fgetl(fid);
while ischar(tline)
  tline = fgetl(fid);
  n = n+1;
end
n = n+1;