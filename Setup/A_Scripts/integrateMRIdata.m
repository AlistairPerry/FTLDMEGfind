function integrateMRIdata(BIDS_BASEDIR)


MEGsubjlist = '/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Misc/MEGsubjlist_wBIDS.csv';


%Ensure MRI_ID is read as string
opts = detectImportOptions(MEGsubjlist);
opts = setvartype(opts, 'MRI_ID', 'string');  %or 'char' if you prefer
MEGsubjlist_tab = readtable(MEGsubjlist, opts);


new_bids_fname_pfix = '_ses-meg1_T1w.nii.gz';

%MEGsubjlist_tab.found_MRI =

%MEGsubjlist_tab.BIDS_fname_MRI =

%MEGsubjlist_tab.MRI_scanner =


%% Setup dir paths

dir_path1 = '/imaging/rowe/users/lh01/MEG_PSP/Structurals/PSPStrucs_2';

dir_path2 = '/imaging/rowe/users/lh01/FTD2010/MRIscans_MMN';

dir_path3 = '/imaging/rowe/users/lh01/FTD2010/MRIscans/Patients/FTD';

dir_path4 = '/imaging/rowe/users/lh01/FTD2010/MRIscans/PSP_Controls';

dir_path5 = '/imaging/rowe/users/lh01/FTD2010/MRIscans';


for subj = 1:length(MEGsubjlist_tab.BIDS_ID)
    
    MRI_path = [];
    
    
    %For now only include those with dir
    if strcmp(MEGsubjlist_tab.MRI_ID(subj), "")
        
        continue
        
    else
        
        
        %need to find files according to rules
        
        if strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path1)
            
            MRI_path = [dir_path1 '/' MEGsubjlist_tab.MRI_ID(subj) '_structural.nii'];
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path2)
            
            subjfolder = strjoin([MEGsubjlist_tab.MRI_Dir(subj) '/' MEGsubjlist_tab.MRI_ID(subj)], '');
            
            if isfolder(subjfolder)
                
                S = dir(subjfolder, '*.nii');
                
                S(startsWith({S.name},'y_')) = [];
                
                
                MRI_path = fullfile(subjfolder, S.name);
                
            end
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path3)
            
            subjfolder = strjoin([MEGsubjlist_tab.MRI_Dir(subj) '/' MEGsubjlist_tab.MRI_ID(subj)], '');
            
            if isfolder(subjfolder)
                
                S = dir(subjfolder, '*.nii');
                
                S(startsWith({S.name},'y_')) = [];
                
                
                MRI_path = fullfile(subjfolder, S.name);
                
            end
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path4)
            
            
            S = dir(fullfile(dir_path4,  strjoin([MEGsubjlist_tab.MRI_ID(subj) '*.nii'], '')));
            
            MRI_path = fullfile(dir_path4, S.name);
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path5)
            
            subjfolder = strjoin([dir_path5 '/' MEGsubjlist_tab.MRI_ID(subj)], '');
            
            
            if isfolder(subjfolder)
                
                S = dir(subjfolder, '**/*.nii');
                
                
                if contains(MEGsubjlist_tab.MRI_ID(subj), 'CBU')
                    
                    S(~startsWith({S.name}, 'sCBU')) = [];
                    
                    MRI_path = fullfile(S.folder(1), S.name(1));
                    
                else
                    
                    S(~startsWith({S.name}, MEGsubjlist_tab.MRI_ID(subj))) = [];
                    
                    MRI_path = fullfile(S.folder(1), S.name(1));
                    
                    
                end
                
            end
            
            
            
        end
        
        
    end
    
    
end



end