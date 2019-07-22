#!/bin/bash

# Please see https://cbiit.github.com/sdsi/candle for a guide to the required and optional variables to be set here

# Required variables
export MODEL_SCRIPT="$CANDLE/wrappers/templates/models/mnist_mlp.py"
export DEFAULT_PARAMS_FILE="$CANDLE/wrappers/templates/model_params/mnist.txt"
export WORKFLOW_SETTINGS_FILE="$CANDLE/wrappers/templates/workflow_settings/grid_workflow-mnist.txt"
export NGPUS=2
export GPU_TYPE="k80"
export WALLTIME="00:20:00"


################ MODIFY ONLY ABOVE; DO NOT MODIFY BELOW ####################################################################
$CANDLE/wrappers/templates/scripts/run_workflows.sh
