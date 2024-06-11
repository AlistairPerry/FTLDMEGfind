function integrateMRIdata(BASE_BIDS_DIR)


MEGsubjlist = '/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Misc/MEGsubjlist_wBIDS.csv';


%Ensure MRI_ID is read as string
opts = detectImportOptions(MEGsubjlist);
opts = setvartype(opts, 'MRI_ID', 'string');  %or 'char' if you prefer

MEGsubjlist_tab = readtable(MEGsubjlist, opts);

new_bids_fname_pfix = '_ses-meg1_T1w.nii';

anat_deriv_DIR = [BASE_BIDS_DIR '' 'derivatives' '/' 'meg_derivatives'];


%% Setup dir paths

dir_path1 = '/imaging/rowe/users/lh01/MEG_PSP/Structurals/PSPStrucs_2';

dir_path2 = '/imaging/rowe/users/lh01/FTD2010/MRIscans_MMN';

dir_path3 = '/imaging/rowe/users/lh01/FTD2010/MRIscans/Patients/FTD';

dir_path4 = '/imaging/rowe/users/lh01/FTD2010/MRIscans/PSP_Controls';

dir_path5 = '/imaging/rowe/users/lh01/FTD2010/MRIscans';

dir_path6 = '/imaging/rowe/users/na01/STRUCTs/Michelle_1';



for subj = 1:length(MEGsubjlist_tab.BIDS_ID)
    
    MRI_path = [];
    
    new_BIDSDIR = [BASE_BIDS_DIR '' MEGsubjlist_tab.BIDS_ID{subj} '/' 'ses-meg1' '/' 'anat/'];
    
    new_BIDSDIR_deriv = [anat_deriv_DIR '/' MEGsubjlist_tab.BIDS_ID{subj} '/' 'ses-meg1' '/' 'anat/'];
    
    
    %For now only include those with dir
    if strcmp(MEGsubjlist_tab.MRI_ID(subj), "")
        
        continue
        
        
    else
        
        try eval(sprintf('!mkdir -p %s', new_BIDSDIR)); end
        
        try eval(sprintf('!mkdir -p %s', new_BIDSDIR_deriv)); end
        
        
        %Need to find files according to dir rules
        
        if strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path1)
            
            MRI_path = strjoin([dir_path1 '/' MEGsubjlist_tab.MRI_ID(subj) '_structural.nii'], '');
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path2)
            
            subjfolder = strjoin([MEGsubjlist_tab.MRI_Dir(subj) '/' MEGsubjlist_tab.MRI_ID(subj)], '');
            
            
            if isfolder(subjfolder)
                
                S = dir(fullfile(subjfolder, '*.nii'));
                
                S(startsWith({S.name},'y_')) = [];
                
                
                MRI_path = strjoin([subjfolder '/' S.name], '');
                
            end
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path3)
            
            subjfolder = strjoin([MEGsubjlist_tab.MRI_Dir(subj) '/' MEGsubjlist_tab.MRI_ID(subj)], '');
            
            
            if isfolder(subjfolder)
                
                S = dir(fullfile(subjfolder, '*.nii'));
                
                S(startsWith({S.name},'y_')) = [];
                
                
                MRI_path = strjoin([subjfolder '/' S.name], '');
                
            end
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path4)
            
            
            S = dir(fullfile(dir_path4,  strjoin([MEGsubjlist_tab.MRI_ID(subj) '*.nii'], '')));
            
            MRI_path = [S.folder '/' S.name];
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path5)
            
            subjfolder = strjoin([dir_path5 '/' MEGsubjlist_tab.MRI_ID(subj)], '');
            
            
            if isfolder(subjfolder)
                
                S = dir(fullfile(subjfolder, '**/*.nii'));
                
                
                if contains(MEGsubjlist_tab.MRI_ID(subj), 'CBU')
                    
                    S(~startsWith({S.name}, 'sCBU')) = [];
                    
                    MRI_path = fullfile(S(1).folder, S(1).name);
                    
                else
                    
                    S(~startsWith({S.name}, MEGsubjlist_tab.MRI_ID(subj))) = [];
                    
                    MRI_path = fullfile(S(1).folder, S(1).name);
                    
                    
                end
                
            end
            
            
            
        elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path6)
            
            
            S = dir(fullfile(dir_path6,  strjoin([lower(MEGsubjlist_tab.MRI_ID(subj)) '*.nii'], '')));
            
            MRI_path = fullfile(S(1).folder, S(1).name);
            
            
        end
        
        
        
    end
    
    
    %Push to output
    
    %Push to data table
    
    if subj == 165
        
        MEGsubjlist_tab.found_MRI{subj} = [];
        
    else
        
        MEGsubjlist_tab.found_MRI{subj} = MRI_path;
        
        MEGsubjlist_tab.BIDS_fname_MRI{subj} = strjoin([MEGsubjlist_tab.BIDS_ID(subj) '' new_bids_fname_pfix], '');
        
        
        %Raw Dir
        
        source_MRI = [MEGsubjlist_tab.found_MRI{subj}];
        
        target_MRI = [new_BIDSDIR '' MEGsubjlist_tab.BIDS_fname_MRI{subj}];
        
        try transfer_files(source_MRI, target_MRI); end
        
        
        %Derivs Dir
        
        target_MRI = [new_BIDSDIR_deriv '' MEGsubjlist_tab.BIDS_fname_MRI{subj}];
        
        try transfer_files(source_MRI, target_MRI); end
        
    end
    
    
end


    function transfer_files(source, target)
        
        
        %Copy file to BIDS dir
        
        copyfile(source, target);
        
        
        %Gzip and remove (as orig file is kept)
        
        gzip(target);
        
        delete(target);
        
    end


end