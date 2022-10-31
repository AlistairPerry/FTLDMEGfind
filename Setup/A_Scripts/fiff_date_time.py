#!/imaging/local/software/anaconda/latest/x86_64/bin/python
"""
==========================================
Get measurement date and time for fiff-file
==========================================

OH January 2018
Modified by AP 2022

"""



import sys

from os import path as op
import numpy as np

from datetime import datetime

import mne

###############################################
### Parameters
###############################################

input = sys.argv


###############################################
### Processing
###############################################

def run_date_time(fname_fiff):

    # Read fiff-file
    info = mne.io.read_info(fname_fiff)

    # get date and time
    # d = datetime.fromtimestamp(info['meas_date'][0]) - 28/10/2022 bug now with orig code
    
    d = info['meas_date']


    year, month, day, hour, minute = d.year, d.month, d.day, d.hour, d.minute
    
    
    time_day = hour
    
    ym = [str(year-2000), ''f"{month:02}"]
    
    
    return time_day, ''.join(ym)


if len(sys.argv)==1:
    
    print('Prints acquisition date and time for fiff file.\n Usage: fiff_date_time.py <fiff_filename.fif>')

else:

    fname_fiff = sys.argv[1]

    time_day, ym = run_date_time(fname_fiff)