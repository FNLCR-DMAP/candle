#!/bin/bash

#SBATCH --partition=gpu
#SBATCH --mem=20G
#SBATCH --gres=gpu:k80:1
#SBATCH --time=00:05:00
#SBATCH --job-name=mnist_test_no_candle

# Set the file that the Python script below will read in order to determine the model parameters
export DEFAULT_PARAMS_FILE="$CANDLE/wrappers/templates/model_params/mnist1.txt"

# Run the model
module load $DEFAULT_PYTHON_MODULE
python $CANDLE/wrappers/templates/models/mnist/mnist_mlp.py
