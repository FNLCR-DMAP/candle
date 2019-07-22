#!/bin/bash

# Load the build environment; DO NOT MODIFY
module load $DEFAULT_PYTHON_MODULE


#### MODIFY ONLY BELOW ####################################################################
# Model specification
export MODEL_PYTHON_DIR="$CANDLE/wrappers/templates/models/mnist"
export MODEL_PYTHON_SCRIPT="mnist_mlp"
export DEFAULT_PARAMS_FILE="$CANDLE/wrappers/templates/model_params/mnist1.txt"

# Workflow specification
export WORKFLOW_TYPE="upf"
export WORKFLOW_SETTINGS_FILE="$CANDLE/wrappers/templates/workflow_settings/upf_workflow-3.txt"

# Job specification
export EXPERIMENTS="$(pwd)/experiments" # this will contain the job output; ensure this directory exists
export MODEL_NAME="mnist_upf_test"
export OBJ_RETURN="val_loss"

# Scheduler settings
export PROCS="4" # note that PROCS-1 and PROCS-2 are actually used for UPF and mlrMBO computations, respectively
export PPN="1"
export WALLTIME="00:10:00"
export GPU_TYPE="k80" # the choices on Biowulf are p100, k80, v100, k20x
export MEM_PER_NODE="20G"
#### MODIFY ONLY ABOVE ####################################################################


# Call the workflow; DO NOT MODIFY
export TURBINE_OUTPUT_SOFTLINK="last-exp"
if [ "x$WORKFLOW_TYPE" == "xupf" ]; then
    "$CANDLE/Supervisor/workflows/$WORKFLOW_TYPE/swift/workflow.sh" "$SITE" -a      "$CANDLE/Supervisor/workflows/common/sh/cfg-sys-$SITE.sh" "$WORKFLOW_SETTINGS_FILE"
elif [ "x$WORKFLOW_TYPE" == "xmlrMBO" ]; then
    export R_FILE="mlrMBO-mbo.R"
    "$CANDLE/Supervisor/workflows/$WORKFLOW_TYPE/swift/workflow.sh" "$SITE" -a      "$CANDLE/Supervisor/workflows/common/sh/cfg-sys-$SITE.sh" "$WORKFLOW_SETTINGS_FILE" "$MODEL_NAME"
fi
