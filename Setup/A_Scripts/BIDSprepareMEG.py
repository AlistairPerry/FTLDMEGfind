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
import os
from multiprocessing import Pool
from pathlib import Path


import fiff_date_time


input_file = '/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Misc/AllMEGlist_Compiled.csv'


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
                        'BIDS_fname': BIDs_fname}), MEG_df]
    
MEG_df_wBIDS = pd.concat(frames, axis=1)    
    
MEG_df_wBIDS['Dir'] = MEG_df_wBIDS['Dir'].apply(lambda x: x + "/")




''' Here comes hard part '''

def copy_megfile_toBIDS(rawdir, rawmegfile, targbidsdir, targbidsfile):
    
    import shutil
    

    #Define and create new dir

    new_bidsdir = targbidsdir + "ses-meg1/" + "meg/"

    Path(new_bidsdir).mkdir(parents=True, exist_ok=True)


	
    #Find file
    
    os.chdir(rawdir)
        
    if os.path.exists(rawdir + rawmegfile):
        
        shutil.copyfile(str(rawdir) + str(rawmegfile), str(new_bidsdir) + str(targbidsfile))
        

        file_exists = 1
        
    
    else:   
    
        rawfile_lc = rawmegfile.lower()       
        
        #Check
        
        
        
        
        all_dirs = []; all_files = [] 
            
                
        for root, dirs, files in os.walk(rawdir):
                
            all_files.extend(files)
            all_dirs.extend(dirs)
                
        
        
        #Need to lower-case
                
        all_files_lc = list(map(str.lower, all_files))
        
        
        try:
                
                
            idx = all_files_lc.index(rawfile_lc)
			

        except:
                    
            print(rawfile_lc, ": Can't be found")
            
            file_exists = 0
                    
            
        else:	

            print(rawfile_lc, ": Found elsewhere")

            new_dir = rawdir + all_dirs[0] + "/"
                
            new_file = all_files[idx]
                
                
            shutil.copyfile(str(new_dir) + str(new_file), str(new_bidsdir) + str(targbidsfile))
                
            file_exists = 1
   
            
            
    return file_exists
        

''' Run '''        

items =  [(MEG_df_wBIDS.loc[i, 'Dir'], MEG_df_wBIDS.loc[i, 'File'], MEG_df_wBIDS.loc[i, 'BIDS_rawdir'], MEG_df_wBIDS.loc[i, 'BIDS_fname']) for i in range(len(BIDs_ID))] 


out_find = []


run_search = 1

while run_search == 1:

    # entry point for the program
    if __name__ == '__main__':
    
        # create the process pool
        with Pool() as pool:      
            
            # call the same function with different data in parallel
            pool.starmap(copy_megfile_toBIDS, items)



''' Extract time date info '''

items =  [MEG_df_wBIDS.loc[i, 'BIDS_rawdir'] + 'ses-meg1/meg/' + MEG_df_wBIDS.loc[i, 'BIDS_fname'] for i in range(len(BIDs_ID))]


time_day_all = []
ym_all = []

if __name__ == '__main__':
    
    # create the process pool
    with Pool() as pool:      
            
        # call the same function with different data in parallel
        for time_day, ym in pool.map(fiff_date_time.run_date_time, items):
            #Extract subject timedate iteratively
            
            time_day_all.append(time_day)
            ym_all.append(ym); 


#Pull into one df

MEGtd_df = pd.DataFrame({'BIDS_ID': MEG_df_wBIDS['BIDS_ID'], 'Recording_time': time_day_all, 
                        'Recording_yearmonth': ym_all})

frames = [MEG_df_wBIDS, MEGtd_df]

MEG_df_wBIDS_fin = pd.concat(frames, axis=1)

MEG_df_wBIDS_fin.to_csv('/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Misc/MEGsubjlist_wBIDS.csv', index=False)



''' Anonymize '''


def anonymize_meg(megfile):
    
    import subprocess

    import shlex
    
    
    #Setup command argument structure
    
    script_dir = "/home/ap09/Documents/Project_3/FTLDMEGfind/Setup/A_Scripts"
    #script_dir = 'U:\\Documents\\Project_3\\FTLDMEGfind\\Setup\\A_Scripts'
    
    full_arg = f'{script_dir}/mne_anonymize --his --dateback 24855 --file {megfile}'
    
    command_split = shlex.split(full_arg)

    
    #Call function
    
    subprocess.Popen(command_split)
   
    
if __name__ == '__main__':
    
    # create the process pool
    with Pool() as pool:      
            
        # call the same function with different data in parallel
        pool.map(anonymize_meg, items)