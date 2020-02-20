#!/bin/bash

#Get the hyperparameters from CANDLE
batch_size=$(candle_get_param batch_size)
epochs=$(candle_get_param epochs)
activation=$(candle_get_param activation)
optimizer=$(candle_get_param optimizer)

#Load any modules on Biowulf
ml python/3.6

#Execute your program
#script_dir="$( cd "$( dirname "${BASH_SOURCE[0]}" )" >/dev/null 2>&1 && pwd )"
python $(pwd)/mnist_mlp.py --batch_size="$batch_size" --epochs="$epochs" --activation="$activation" --optimizer="$optimizer"

#Return a value to CANDLE 
#export CANDLE_VAL_TO_RETURN=$(cat results.txt)
candle_val_to_return=$(cat results.txt) # no need to export as tail.sh will be appended to this file
