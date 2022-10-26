#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Tue Oct 25 16:33:50 2022

@author: alistairperry
"""

'''
Setup

'''


import pandas as pd



input_file = 'U:\Documents\Project_3\AllMEGlist_Compiled.csv'


MEG_df = pd.read_csv(input_file)


BIDS_basedir = "/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Release/"

sess = "ses-meg1"

megfname_pfix  = "task-Rest_meg.fif"




BIDs_ID = []

BIDs_rawdir = []

BIDs_fname = []


for x in range(1, len(MEG_df['S_ID'])+1):
    
    new_ID = "sub-Sub{:04d}".format(x)
    
    BIDs_ID.append(new_ID) 
    
    BIDs_rawdir.append(BIDS_basedir + new_ID + "/")
    
    BIDs_fname.append(new_ID + "_" + sess + "_" + megfname_pfix)



#Join together

frames = [pd.DataFrame({'BIDS_ID': BIDs_ID, 'BIDS_rawdir': BIDs_rawdir, 
                        'BIDS_fame': BIDs_fname}), MEG_df]
    
MEG_df_wBIDS = pd.concat(frames, axis=1)    
    


''' Here comes hard part '''



MEGdata_wBIDs['BIDs_ID'] = BIDs_ID





#bids raw dir

etc


#bids raw file name

add


#find file

#lower case all file names

see if file exits


if not:
    
    rsc1
    
    closed
    

if missing

add1

if exits:
    
parallelize     

#mne-python scan length



