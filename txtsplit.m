function txtsplit(filename,fpath)
% function txtsplit(filename,fpath)
%
% Breaks up a .txt file with many recordings into separate files each with
% a single recording. 
%
% INPUTS:
%   Filename: a string containing the name of the text-file created from the 
%   AEPtoASCII program on the Biologic AEP computer. The extension (e.g. .Txt 
%   or .txt must be included in the filename string.
% 
%   fpath: a string containing the folder pathway where the new .txt files
%   created with this function willbe saved. 
%
% See example of default inputs below. Reset these as desired. 


lnN = linecount(filename);

out = fopen(filename);                      % Open function
counter = 0;                                % line counter (sloppy but works)
cnt = 1;


for n=1:lnN                                 
    tline = fgetl(out);                     % read a line
    
    if ~isempty(tline)                        % if the line is not empty
        counter = counter + 1;                % count the non-empty line 
    
        U = strfind(tline, 'Patient');      % where the string start (if at all)
        if isfinite(U) == 1                % if it is a number actually
            Index(cnt) = counter;
            cnt = cnt+1;
        end
     end
end


CStr  = importdata(filename,',', lnN);
Index = [Index size(CStr,1)+1];

% test date


qind     = strfind(CStr{4},'"');
testdate = CStr{4}(qind(3)+1:qind(4)-1);
ind      = strfind(testdate,' ');
testdate = testdate(1:ind-1);
ind      = strfind(testdate,'/');
testdate(ind) = '';

% make new folder (if necessary) and filename for subject
str   = CStr{Index(1)+1};
i     = strfind(str,'"');
IDstr = str(i(1)+1:i(2)-1);
ind      = strfind(IDstr,'_');
IDstr(ind) = '';


IDpath = fullfile(fpath, IDstr);
if exist(IDpath,'dir')==0
    mkdir(IDpath)
end
svfname = fullfile(IDpath, [IDstr,'-']);

existingNumber = 0;
numberFound = 0;
filesInIDPath = dir(IDpath);


for i = 1:length(filesInIDPath)
    [fPath, fName, fExt] = fileparts(filesInIDPath(i).name);
    
    fSplit = strsplit(fName, '-');
    if strcmpi(fExt, '.txt') && strcmpi(fSplit{end-1}, testdate)
        numberFound = str2num(fSplit{end});
        if numberFound > existingNumber
            existingNumber = numberFound;
        end
    end
end
    
for iP = 1:length(Index)-1
  numstr=sprintf('%03d', iP+existingNumber);

  FID = fopen([svfname, testdate,'-',numstr, '.txt'], 'w');
  if FID == - 1, error('Cannot open file for writing'); end
  
  fprintf(FID,'%s\n', CStr{Index(iP):Index(iP+1)-1});
  fclose(FID);
end




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