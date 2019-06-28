#!/bin/bash

# Please see https://cbiit.github.com/sdsi/candle for a guide to the required and optional variables to be set here

export MODEL_SCRIPT="$CANDLE_WRAPPERS/templates/models/wrapper_compliant/mnist_mlp.py"
export DEFAULT_PARAMS_FILE="$CANDLE_WRAPPERS/templates/model_params/mnist1.txt"
export WORKFLOW_SETTINGS_FILE="$CANDLE_WRAPPERS/templates/workflow_settings/upf_workflow-3.txt"
export NGPUS=2
export GPU_TYPE="k80"
export WALLTIME="00:20:00"


################ MODIFY ONLY ABOVE; DO NOT MODIFY BELOW ####################################################################
$CANDLE_WRAPPERS/templates/scripts/run_workflows.sh
