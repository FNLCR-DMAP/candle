# Call this like, e.g., "python study_hp_differences.py experiments/*/metadata.json"

# design size is in parentheses
# Expt 06 ( 9): Downloading multiple times + bfc_allocator.cc / OOM
# Expt 07 (15): SUCCESSFUL
# Expt 08 (15): Couldn't write JSON
# Expt 09 (15): Returned a list, not a number
# Expt 10 (15): Probably successful (killed it prior to second iteration but don't see any errors)
# Expt 11 ( 9): bfc_allocator.cc / OOM
# Expt 12 ( 9): SUCCESSFUL
# EXPT 13 ( 9): SUCCESSFUL

import sys, json
import numpy as np

myrange = range(7,len(sys.argv))
excluding_keys = ['DEFAULT_PARAMS_FILE', 'IGNORE_ERRORS', 'MODEL_NAME', 'SH_TIMEOUT', 'WALLTIME']
results = ['oom', 'GOOD', 'json issue', 'returned list', 'probably good', 'oom', 'GOOD', 'GOOD']

def get_keys(myfile):
    with open(myfile) as infile:
        metadata = json.load(infile)
    return(metadata.keys())

def get_value(myfile, key):
    with open(myfile) as infile:
        metadata = json.load(infile)
    try: metadata[key]
    except KeyError:
        return('NA')
    else:
        return(metadata[key])

for key in get_keys(sys.argv[-1]):    
    mylist = []
    for ind in myrange:
        mylist.append(get_value(sys.argv[ind], key))
    if (len(np.unique(mylist)) != 1) and (key not in excluding_keys):
        print('\n----' + key + '----')
        for ind, val, result in zip(myrange, mylist, results):
            print('Exp {:02d} ({:13s}): '.format(ind-1, result), val)
