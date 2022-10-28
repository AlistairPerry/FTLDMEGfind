function BIDSmetadata(DATADIR)
%UNTITLED Summary of this function goes here
%   Detailed explanation goes here

%Will create necessary .json files
%Along with creating participants tsv file

%Credit: Delshad 


%% Setup

%Paths

addpath('/imaging/rowe/users/ap09/Toolbox/spm12_latest_local')

addpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Github/fieldtrip')

addpath(genpath('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Github/bids-matlab'))


ft_defaults()


%Data paths

MEGsubjlist = '/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Misc/MEGsubjlist_wBIDS.csv';

MEGsubjlist_tab = readtable(MEGsubjlist);


cd(DATADIR)


%% BIDS metadata basics

% Create sidecar settings for MEG part (which uses fieldtrip). 
% (8)
meg_sc = []; % we should add emptyroom, derivatevs, 
meg_sc.tasknames = {
    'Resting State'

    };

% MEG Task descriptions (9)
meg_sc.taskdesc = {
    'Resting state scan with eyes closed.'

    };

% Necessary field, but not really sure what is supposed to be in here.
meg_sc.instructions = {
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    ''
    };


meg_sc.InstitutionAddress ='15 Chaucer Road, Cambridge, CB2 7EF, England';
meg_sc.InstitutionName ='Medical Research Council (MRC) Cognition & Brain Sciences Unit (CBU)';
meg_sc.InstitutionalDepartmentName='Department of Psychiatry, University of Cambridge';


time_info = [];


%% Loop through individuals

n_subjs = length(MEGsubjlist_tab.BIDS_ID);


parfor subj = 1:n_subjs
    
    bidsmeg = strjoin([MEGsubjlist_tab.BIDS_rawdir(subj) '' 'ses-meg1' '/' 'meg' '/' MEGsubjlist_tab.BIDS_fname(subj)], ''); 

    % Setup data2bids
    
            cfg = [];
            cfg.dataset = bidsmeg;
            cfg.meg.PowerLineFrequency      = 50;

            % General BIDS options that apply to all data types are
            cfg.TaskName                    = 'Resting State';

            cfg.Manufacturer                = 'Elekta';
            cfg.ManufacturersModelName      = 'NeuroMag';
            %             cfg.DeviceSerialNumber          = '';
            cfg.SoftwareVersions            = '';
            
            % Apply to all functional data types
            cfg.TaskDescription             = meg_sc.taskdesc{1};
            cfg.Instructions                = meg_sc.instructions{1};
%             cfg.meg.ECGChannelCount         = 1; %test
%             cfg.meg.EOGChannelCount         = 2; %test
%             cfg.ECGChannelCount             = 1;
%             cfg.EOGChannelCount             = 2; 
            cfg.DewarPosition               = 'upright' ;
            cfg.SoftwareFilters             = 'Max Filter';%'';
            cfg.DigitizedLandmarks          = true;
            cfg.DigitizedHeadPoints         = true;


    %Run
    
    data2bids(cfg)
    
    
    
    

            
end


%Create participants .tsv file

participants_tsv = table;

for subj = 1:n_subjs
    
    participants_tsv.participant_id(subj) = MEGsubjlist_tab.BIDS_ID(subj);
    
    participants_tsv.group(subj) = MEGsubjlist_tab.Diag(subj);
    
end


%Write out

bids.util.tsvwrite([DATADIR 'participants.tsv'], participants_tsv);


end