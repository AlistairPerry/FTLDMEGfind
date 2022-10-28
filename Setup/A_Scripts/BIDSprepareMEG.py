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
import numpy as np
import os
from multiprocessing import Pool
from pathlib import Path

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


    new_bidsfile = targbidsdir + "ses-meg1/" + "meg/" + targbidsfile

	
    #Find file
    
    if not os.path.exists(new_bidsfile):

    	os.chdir(rawdir)
    
    	if os.path.exists(rawdir + rawmegfile):
        
        	shutil.copyfile(str(rawdir) + str(rawmegfile), str(new_bidsdir) + str(targbidsfile))
        

        	file_exists = 1
        
    
    	else:   
    
        	rawfile_lc = rawmegfile.lower()       
        
        	all_dirs = []; all_files = []
        
        
        	for root, dirs, files in os.walk(rawdir):
        
            		all_files.extend(files); all_dirs.extend(dirs)
                
        
        
        	#Need to lower-case
                
        
        	try:
                    
            		idx = all_files_lc.index(rawfile_lc)

        	except:
                    
            		print("File can't be found")
            
            		file_exists = 0
                    
            
        	else:	

                    print("Found elsewhere")

            
            		new_dir = rawdir + all_dirs[0] + "/"
                
            		new_file = all_files[idx]
                
                
            		shutil.copyfile(str(new_dir) + str(new_file), str(new_bidsdir) + str(targbidsfile))
                
            		file_exists = 1
   
            
            
    	return file_exists
        
        

#items = [(MEG_df_wBIDS.loc[i, 'Dir'], MEG_df_wBIDS.loc[i, 'File'], [MEG_df_wBIDS.loc[i, 'BIDS_rawdir'] + MEG_df_wBIDS.loc[i, 'BIDS_fname']]) for i in range(len(BIDs_ID))]        


items =  [(MEG_df_wBIDS.loc[i, 'Dir'], MEG_df_wBIDS.loc[i, 'File'], MEG_df_wBIDS.loc[i, 'BIDS_rawdir'], MEG_df_wBIDS.loc[i, 'BIDS_fname']) for i in range(len(BIDs_ID))] 


out_find = []


# entry point for the program
if __name__ == '__main__':
    
    # create the process pool
    with Pool() as pool:      
            
        # call the same function with different data in parallel
        for result in pool.starmap(copy_megfile_toBIDS, items_test):
            # report the value to show progress
            
            out_find.append(result)


