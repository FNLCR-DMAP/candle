#!/bin/bash

# Please see https://cbiit.github.com/sdsi/candle for a guide to the required and optional variables to be set here

# Required variables
export MODEL_SCRIPT="$(pwd)/nt3_baseline_keras2.py"
export DEFAULT_PARAMS_FILE="$(pwd)/nt3_default_params.txt"
export WORKFLOW_SETTINGS_FILE="$(pwd)/bayesian_workflow-nt3_nightly.R"
export NGPUS=7
export GPU_TYPE="p100" # must be p100 or v100
export WALLTIME="00:45:00"

# Optional variables used only in the Bayesian workflows
export DESIGN_SIZE=9
export PROPOSE_POINTS=9
export MAX_ITERATIONS=3
export MAX_BUDGET=180

################ MODIFY ONLY ABOVE; DO NOT MODIFY BELOW ####################################################################
$CANDLE/wrappers/templates/scripts/run_workflows.sh
