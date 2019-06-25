# Import relevant modules
import sys, os, json

# If it's defined in the environment, append $SUPP_PYTHONPATH to the Python path
supp_pythonpath = os.getenv('SUPP_PYTHONPATH')
if supp_pythonpath is not None:
    sys.path.append(supp_pythonpath)

# Load the hyperparameter dictionary stored in the JSON file params.json
with open('params.json') as infile:
    hyperparams = json.load(infile)
