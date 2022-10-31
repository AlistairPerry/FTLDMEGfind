# -*- coding: utf-8 -*-
"""
Created on Mon Oct 31 11:53:18 2022

@author: ap09
"""

import json


BIDS_DIR = '/imaging/rowe/users/ap09/Projects/FTD-MEG-MEM_3/Release/'


#Dataset description

Name = "Resting-state MEG (+T1) FTLD-syndromes"
BIDSVersion = "1.4.0"
DatasetType = "raw"
Authors = ["Alistair Perry", "James B Rowe"]

ds_json = {"Name": Name, "BIDSVersion": BIDSVersion, "Authors": Authors}


# output 
with open(BIDS_DIR + "dataset_description.json", 'w') as f:
    json.dump(ds_json, f)
    
# Closing file
f.close()


#Participant information

