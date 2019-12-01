# Ensure that above you DEFINE the history object (as in, e.g., the return value of model.fit()) or val_to_return (a single number) in your model; below we essentially RETURN those values

# Import relevant module
#import json # Actually, this is done in head.py

# This is Nick's JSON dumping class he gave me during the Nov 2019 hackathon
class FromNPEncoder(json.JSONEncoder):
    def default(self, obj):
        import numpy as np
        if isinstance(obj, np.integer):
            return int(obj)
        elif isinstance(obj, np.floating):
            return float(obj)
        elif isinstance(obj, np.ndarray):
            return obj.tolist()
        else:
            return super(FromNPEncoder, self).default(obj)

try: history
except NameError:
    try: val_to_return
    except NameError:
        print("Error: Neither a history object nor a val_to_return variable was defined upon running the model on the current hyperparameter set; exiting")
        exit
    else:
        # Make a history.history dictionary from a return value and write it to a JSON file
        with open('val_to_return.json', 'w') as outfile:
            json.dump({'val_loss': [val_to_return], 'val_corr': [val_to_return], 'val_dice_coef': [val_to_return]}, outfile)
else:
    # Write the history.history dictionary to a JSON file
    with open('val_to_return.json', 'w') as outfile:
        json.dump(history.history, outfile, cls=FromNPEncoder)
