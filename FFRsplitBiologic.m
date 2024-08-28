function [subjs_condition,BlockOne,BlockTwo,nonEmptyConditionNames,subjInitials] = FFRsplitBiologic(StudyFolderPath)
%FFRsplitBiologic Splits all Biologic Collected txt files into blocks

% path_prefix = './FFR-ABR-data/Nicotine Study/Nicotine'; %original data folder

%folder_name = type;
%%
% Remove previously constructed BlockedFFR folder
Prev = fullfile(StudyFolderPath,'BlockedFFR');
[status, message, messageid] = rmdir(Prev,'s');

subFolderConditionNames = getSubfolder(StudyFolderPath);

% Save split blocks into new folder
for k = 1:size(subFolderConditionNames,2)
folder_name_full = char(fullfile(StudyFolderPath,subFolderConditionNames(k))); % folder for newly saved data
files = dir(folder_name_full);
target_folder =  fullfile(StudyFolderPath,'BlockedFFR', char(subFolderConditionNames(k))); % folder to write processed split data
for i = 1:length(files)
    [fPath, fName, fExt] = fileparts(files(i).name);
    switch lower(fExt)
        case '.txt'
        % A Text file
            txtsplit(fullfile(folder_name_full, files(i).name),target_folder);
    end
end
end
%%
% After save file, get conditions with subjects
nonEmptyConditionNames = getSubfolder(fullfile(StudyFolderPath,'BlockedFFR'));
subjs_condition = [];
BlockOne = [];
BlockTwo = [];
current = 1;
for m = 1:size(nonEmptyConditionNames,2)
    subjInitials = getSubfolder(fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m))));
    for n = 1:size(subjInitials,2)
        BlockNames = dir(fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m)),char(subjInitials(n))));
        subjs_condition{current,1} = [char(nonEmptyConditionNames(m)),' + ',char(subjInitials(n))];
        BlockOne{current,1} = fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m)),char(subjInitials(n)),BlockNames(end-1).name);
        BlockTwo{current,1} = fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m)),char(subjInitials(n)),BlockNames(end).name); %single block dirty solution 
        
        current = current + 1;
    end
    
end

%%
end