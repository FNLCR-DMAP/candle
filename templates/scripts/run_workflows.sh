#!/bin/bash

# This script is a wrapper that prepares multiple things for use at FNLCR prior to running the workflows; it is basically a "hidden settings" file

# Write a function to output the key-value pairs
output_json_format() {
    params=("$@")
    for var in "${params[@]}"; do
        echo -n "\"$var\": \"${!var}\", "
    done
}

# Variables
#### WORKFLOW_TYPE EXPERIMENTS DEFAULT_PYTHON_MODULE MODEL_PYTHON_DIR MODEL_PYTHON_SCRIPT OBJ_RETURN USE_CANDLE
export WORKFLOW_TYPE=$(echo $WORKFLOW_SETTINGS_FILE | awk -v FS="/" '{split($NF,arr,"_workflow-"); print(arr[1])}')
export EXPERIMENTS="$(pwd)/experiments"
export DEFAULT_PYTHON_MODULE="$MODULES_FOR_BUILD" # for now set the default Python module for execution to be the same as that used for the CANDLE/Swift/T build. We assume that the modules for the build are a single Python module
export MODEL_PYTHON_DIR="$CANDLE_WRAPPERS/templates/scripts" # these are constants referring to the CANDLE-compliant wrapper Python script
export MODEL_PYTHON_SCRIPT="candle_compliant_wrapper"
export OBJ_RETURN="val_loss"
export USE_CANDLE=1 # if not already set, as in e.g. by run_without_candle.sh, set to 1 to use CANDLE or 0 to run using the default parameters outside of CANDLE

# Constants
export MODEL_NAME="candle_job"
export PPN="1" # run one MPI process (GPU process) per node on Biowulf
export TURBINE_OUTPUT_SOFTLINK="last-exp" # this is more descriptive than the default turbine-output symbolic link

# Set a proportional number of processors to use on the node
#### CPUS_PER_TASK MEM_PER_NODE
if [ -z "$CPUS_PER_TASK" ]; then
    export CPUS_PER_TASK=14
    if [ "x$(echo $GPU_TYPE | awk '{print tolower($1)}')" == "xk20x" ]; then
        export CPUS_PER_TASK=16
    fi
fi
# Set a proportional amount of memory to use on the node
if [ -z "$MEM_PER_NODE" ]; then
    if [ "x$(echo $GPU_TYPE | awk '{print tolower($1)}')" == "xk20x" ] || [ "x$(echo $GPU_TYPE | awk '{print tolower($1)}')" == "xk80" ]; then
        export MEM_PER_NODE="60G"
    else
        export MEM_PER_NODE="30G"
    fi
fi

# Create the experiments directory if it doesn't already exist
if [ ! -d $EXPERIMENTS ]; then
    mkdir -p $EXPERIMENTS && echo "Experiments directory created: $EXPERIMENTS"
fi

# For running the workflows themselves, load the module with which Swift/T was built
module load $MODULES_FOR_BUILD

# If a restart is requested for a UPF job, then overwrite the WORKFLOW_SETTINGS_FILE accordingly
#### WORKFLOW_TYPE WORKFLOW_SETTINGS_FILE
if [ -n "$RESTART_FROM_EXP" ]; then
    export WORKFLOW_TYPE="upf"
    # Ensure the metadata JSON file from the experiment from which we're restarting exists
    metadata_file=$EXPERIMENTS/$RESTART_FROM_EXP/metadata.json
    if [ ! -f $metadata_file ]; then
        echo "Error: metadata.json does not exist in the requested restart experiment $EXPERIMENTS/$RESTART_FROM_EXP"
        exit
    fi
    # Create the new restart UPF
    upf_new="upf_workflow-restart.txt"
    python $CANDLE_WRAPPERS/analysis/restart.py $metadata_file > $upf_new
    # If the new UPF is empty, then there's nothing to do, so quit
    if [ -s $upf_new ]; then # if it's NOT empty...
        export WORKFLOW_SETTINGS_FILE="$(pwd)/$upf_new"
    else
        echo "Error: Job is complete; nothing to do"
        rm -f $upf_new
        exit
    fi
fi

# Do some workflow-dependent things
#### R_FILE PROCS
if [ "x$WORKFLOW_TYPE" == "xupf" ]; then # if doing the UPF workflow...
    # If a restart job is requested...
    export R_FILE="NA"
    export PROCS=$((NGPUS+1))
elif [ "x$WORKFLOW_TYPE" == "xmlrMBO" ]; then # if doing the mlrMBO workflow...
    export R_FILE="mlrMBO-mbo.R"
    export PROCS=$((NGPUS+2))
fi

# Write the dictionary of the metadata in JSON format
# These are variables from the module .lua files
params1=(CANDLE SITE TURBINE_HOME)
# This is the result from:
params2=(MODEL_SCRIPT DEFAULT_PARAMS_FILE PYTHON_BIN_PATH EXEC_PYTHON_MODULE SUPP_MODULES SUPP_PYTHONPATH WORKFLOW_TYPE WORKFLOW_SETTINGS_FILE EXPERIMENTS MODEL_NAME OBJ_RETURN PROCS WALLTIME GPU_TYPE)
# These are variables from run_workflows.sh
params3=(CPUS_PER_TASK MEM_PER_NODE PPN)
tmp="$(output_json_format "${params1[@]}")$(output_json_format "${params2[@]}")$(output_json_format "${params3[@]}")"
echo "{${tmp:0:${#tmp}-2}}" > metadata.json

# If we want to run the wrapper using CANDLE...
if [ "${USE_CANDLE:-1}" -eq 1 ]; then
    if [ "x$WORKFLOW_TYPE" == "xupf" ]; then
        "$CANDLE/Supervisor/workflows/$WORKFLOW_TYPE/swift/workflow.sh" "$SITE" -a "$CANDLE/Supervisor/workflows/common/sh/cfg-sys-$SITE.sh" "$WORKFLOW_SETTINGS_FILE"
    elif [ "x$WORKFLOW_TYPE" == "xmlrMBO" ]; then
        "$CANDLE/Supervisor/workflows/$WORKFLOW_TYPE/swift/workflow.sh" "$SITE" -a "$CANDLE/Supervisor/workflows/common/sh/cfg-sys-$SITE.sh" "$WORKFLOW_SETTINGS_FILE" "$MODEL_NAME"
    fi

# ...otherwise, run the wrapper alone, outside of CANDLE
else
    python "$MODEL_PYTHON_DIR/$MODEL_PYTHON_SCRIPT.py"
fi
