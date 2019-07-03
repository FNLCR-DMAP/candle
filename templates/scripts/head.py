# Import relevant modules
#import sys, os, json
import json

# ALW: On 6/29/19, moving this to model_wrapper.sh; not sure why I put it here but there may have been a reason!
# # If it's defined in the environment, append $SUPP_PYTHONPATH to the Python path
# supp_pythonpath = os.getenv('SUPP_PYTHONPATH')
# if supp_pythonpath is not None:
#     sys.path.append(supp_pythonpath)

# Load the hyperparameter dictionary stored in the JSON file params.json
with open('params.json') as infile:
    hyperparams = json.load(infile)
