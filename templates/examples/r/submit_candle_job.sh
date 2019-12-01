#!/bin/bash

# Please see https://cbiit.github.com/sdsi/candle for a guide to the required and optional variables to be set here

export MODEL_SCRIPT="$(pwd)/feature-reduction.R"
export DEFAULT_PARAMS_FILE="$(pwd)/feature-reduction-R_default_params.txt"
export WORKFLOW_SETTINGS_FILE="grid_workflow-feature-reduction-R.txt"
export NGPUS=1
export GPU_TYPE="k20x"
export WALLTIME="02:20:00"

export EXEC_R_MODULE="R/3.6"
export SUPP_R_LIBS="/data/BIDS-HPC/public/software/R/3.6/library"


################ MODIFY ONLY ABOVE; DO NOT MODIFY BELOW ####################################################################
$CANDLE/wrappers/templates/scripts/run_workflows.sh
