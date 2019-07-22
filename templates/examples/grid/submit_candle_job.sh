#!/bin/bash

# Please see https://cbiit.github.com/sdsi/candle for a guide to the required and optional variables to be set here

# Required variables
export MODEL_SCRIPT="$(pwd)/mnist_mlp.py"
export DEFAULT_PARAMS_FILE="$(pwd)/mnist_default_params.txt"
export WORKFLOW_SETTINGS_FILE="$(pwd)/grid_workflow-mnist.txt"
export NGPUS=2
export GPU_TYPE="k80"
export WALLTIME="00:20:00"


################ MODIFY ONLY ABOVE; DO NOT MODIFY BELOW ####################################################################
$CANDLE/wrappers/templates/scripts/run_workflows.sh
