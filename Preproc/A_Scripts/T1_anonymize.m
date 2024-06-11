function participants_test = T1_anonymize(BASE_BIDS_DIR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here


%% Paths
% BIDS util
addpath(genpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/bids-matlab'));

% Defacing package
addpath(genpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/defacing'));

% Misc 
addpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/FTLDMEGfind/Misc');

% Fieldtrip
addpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/fieldtrip')

ft_defaults()


%% Setup

%Path to BIDS derivs dir
BIDSDIR_deriv = [BASE_BIDS_DIR '/' 'derivatives' '/' 'meg_derivatives' '/'];


%Participants
participants = bids.util.tsvread([BASE_BIDS_DIR '/' 'participants.tsv']);

n_subjs = length(participants.participant_id);


MRI_bname = '_ses-meg1_T1w';

nat2talstr = '/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/defacing/nat2tal.sh';


%Template dir (for defacing)
deface_tempdir = '/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Misc/';

%Test
participants_test_idx = randi(n_subjs, 1, 10);

participants_test = participants.participant_id(participants_test_idx);



%% Deface

% parfor subj = 1:length(participants_test)
% 
%     
%     subj_id = participants_test{subj};
%     
%     subj_BIDSDIR = [BASE_BIDS_DIR '/' subj_id '/' 'ses-meg1' '/' 'anat' '/'];
%     
%     orig_fname = [subj_BIDSDIR '/' subj_id '' MRI_bname '.nii.gz'];
%     
%     
%     %For now add in df postfix (will revert back later)
%     
%     out_fname = [subj_BIDSDIR '/' subj_id '' MRI_bname '_df' '.nii.gz'];
%     
%     
%     if isfile(orig_fname)
%         
%         deface_str = sprintf('pydeface %s', orig_fname);
%         
%         %deface_str = sprintf('mri_deface %s %s/talairach_mixed_with_skull.gca %s/face.gca %s', orig_fname, deface_tempdir, deface_tempdir, out_fname);
%         
%         system(deface_str);
%         
%         %delete(orig_fname);
%         
%     end
%     
% end


%% Trim

%Need to first perform transformation first


for subj = 1:length(participants_test)
    
    subj_id = participants_test{subj};
    
    subj_BIDSDIR_deriv = [BIDSDIR_deriv '' subj_id '/' 'ses-meg1' '/' 'anat' '/'];
    
    orig_fname = [subj_BIDSDIR_deriv '/' subj_id '' MRI_bname '.nii.gz'];
    
    
    %Create transform to talariach space
    %see https://github.com/AlistairPerry/defacing#2-transformation-to-tailarach-space)
    if isfile(orig_fname)
        
        nat2tal_subjstr = [nat2talstr ' ' subj_BIDSDIR_deriv];
        
        system(nat2tal_subjstr);
        
        %Deface
        %Catch to see if above completed
        
        if isfile([subj_BIDSDIR_deriv '' subj_id '' MRI_bname '_nat2tal' '.xfm'])
            
            s1_defaceMRI_onlytrim(subj_BIDSDIR_deriv);
            
        end
        
    end
    
    
end


end