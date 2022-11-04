function T1_anonymize(BASE_BIDS_DIR)

%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%% Paths
% BIDS functions
addpath(genpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/bids-matlab'));

% Defacing package
addpath(genpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/defacing'));

% Misc 
addpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/FTLDMEGfind/Misc');


%% Setup

BIDSDIR_deriv = [BASE_BIDS_DIR '/' 'derivatives' '/' 'meg_derivatives' '/'];


participants = bids.util.tsvread([BASE_BIDS_DIR '/' 'participants.tsv']);

n_subjs = length(participants.participant_id);

MRI_bname = '_ses-meg1_T1w';


nat2talstr = '/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Code/defacing';


%% Deface

parfor subj = 1:n_subjs
    
    subj_id = participants.participant_id{subj}
    
    subj_BIDSDIR = [BASE_BIDS_DIR '/' subj_id '/' 'ses-meg1' '/' 'anat' '/'];
    
    orig_fname = [subj_BIDSDIR '/' subj_id '' MRI_bname '.nii.gz'];
    
    
    %For now add in df postfix (will revert back later)
    
    out_fname = [subj_BIDSDIR '/' subj_id '' MRI_bname '_df' '.nii.gz'];
    
    
    if isfile(orig_fname)
        
        rik_eval(sprintf('mri_deface %s talairach_mixed_with_skull.gca face.gca %s', orig_fname, out_fname));
        
        delete(orig_fname);
        
    end
    
end


%% Trim

%Need to

parfor subj = 1:n_subjs
    
    subj_id = participants.participant_id{subj}

    subj_BIDSDIR_deriv = [BIDSDIR_deriv '' subj_id '/' 'ses-meg1' '/' 'anat' '/'];

    %Create transform to talariach space 
    %see https://github.com/AlistairPerry/defacing#2-transformation-to-tailarach-space)
    nat2tal_subjstr = [nat2talstr ' ' subj_BIDSDIR_deriv];
    rik_eval(nat2tal_subjstr)
    
    %Deface
    %Catch to see if above completed
    
    if isfile([subj_BIDSDIR_deriv '' subj_id '' MRI_bname '_nat2tal' '.xfm'])
        
        s1_defaceMRI_onlytrim(subj_BIDSDIR_deriv);
        
    end
   
    
end


end

