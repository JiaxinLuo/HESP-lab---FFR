function [subjs_condition,BlockOne,BlockTwo,nonEmptyConditionNames,subjInitials,SubjectAveragedTrial] = FFRsplitBiologic(StudyFolderPath)
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
Avg_Blk_current = 1;

for m = 1:size(nonEmptyConditionNames,2)
    subjInitials = getSubfolder(fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m))));
    
    for n = 1:size(subjInitials,2)
        BlockNames = dir(fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m)),char(subjInitials(n))));
        SubjectAveragedTrial{Avg_Blk_current,1} = [char(nonEmptyConditionNames(m)),'--',char(subjInitials(n))];
        for iBlk = 3:length(dir(fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m)),char(subjInitials(n))))) % first two blocks are place holders
        subjs_condition{current,1} = [char(nonEmptyConditionNames(m)),'--',char(subjInitials(n)),' blk-',num2str(iBlk-2)];
        BlockOne{current,1} = fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m)),char(subjInitials(n)),BlockNames(iBlk).name);
        BlockTwo{current,1} = fullfile(StudyFolderPath,'BlockedFFR',char(nonEmptyConditionNames(m)),char(subjInitials(n)),BlockNames(iBlk).name); %single block dirty solution
        Trial = ReadAEP2ASCII(BlockOne{current,1});
        TrialCount(iBlk,:) = Trial.collected.collectdata(3,3);
        Trialdata(iBlk,:) = Trial.data.avg(1,:)*TrialCount(iBlk,:);
        current = current + 1;
        end
        SubjectAveragedTrial{Avg_Blk_current,2}.data.time = Trial.data.time;
        SubjectAveragedTrial{Avg_Blk_current,2}.data.avg = sum(Trialdata)/sum(TrialCount);
        SubjectAveragedTrial{Avg_Blk_current,3}.data.avg = sum(Trialdata)/sum(TrialCount);
        SubjectAveragedTrial{Avg_Blk_current,1} = [SubjectAveragedTrial{Avg_Blk_current,1}, '--', num2str(sum(TrialCount)),' trials'];
        TrialCount = [];
        Avg_Blk_current = Avg_Blk_current + 1;
    end
    
end

%%
end