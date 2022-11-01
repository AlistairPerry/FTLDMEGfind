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

dir_path2 = '/imaging/rowe/users/lh01/MEG_PSP/MEG_PSP_BMLD';

dir_path3 = '/imaging/rowe/users/lh01/FTD2010/MRI_VBM_FTDnm';

dir_path4 = '/imaging/rowe/users/lh01/FTD2010/MRIscans/PSP_Controls';

dir_path5 = '/imaging/rowe/users/lh01/FTD2010/MRIscans';



for subj = 1:length(MEGsubjlist_tab.BIDS_ID)
   
    %For now only include those with dir
    if strcmp(MEGsubjlist_tab.MRI_ID(subj), "")
      
        continue
        
    else
        
        
       %need to find files according to rules     
       
       if strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path1)
           
           MRI_path = [dir_path1 '/' MEGsubjlist_tab.MRI_ID(subj) '_structural.nii'];
              
           
       elseif strcmp(MEGsubjlist_tab.MRI_Dir(subj), dir_path2)
           
           
           
       end
       
       
        
    end
    
    
end


'/imaging/rowe/users/lh01/MEG_PSP/MEG_PSP_BMLD'
    
    look recurvisely based on id and nii file
    
    
'/imaging/rowe/users/lh01/FTD2010/MRI_VBM_FTDnm'
    
    look in folder 
    
'/imaging/rowe/users/lh01/FTD2010/MRIscans/PSP_Controls' and con
    
   in one folder - structural_reordered.nii 
   
   

    
    


end