#!/bin/bash

#SBATCH --partition=gpu
#SBATCH --mem=20G
#SBATCH --gres=gpu:k80:1
#SBATCH --time=00:05:00
#SBATCH --job-name=mnist_test_no_candle

# Load desired Python version or Conda environment
module load $MODULES_FOR_BUILD

# Set the file that the Python script below will read in order to determine the model parameters
export DEFAULT_PARAMS_FILE="$CANDLE_WRAPPERS/templates/model_params/mnist1.txt"

# Run the model
python $CANDLE_WRAPPERS/templates/models/mnist/mnist_mlp.py