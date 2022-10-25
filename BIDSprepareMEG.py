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



input_file = '/Users/alistairperry/Documents/Cambridge/Project_3/AllMEGlist_Compiled.csv'


MEGdata = pd.read_csv(input_file)


MEGdata_wBIDs = MEGdata.copy()


BIDs_ID = []

for x in range(1, len(MEGdata_wBIDs['S_ID'])+1):
    
    BIDs_ID.append("sub-Sub{:04d}".format(x)) 
    

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



