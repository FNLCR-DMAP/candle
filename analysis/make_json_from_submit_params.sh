#!/bin/bash

# Write a function to output the key-value pairs
output_json_format() {
    params=("$@")
    for var in "${params[@]}"; do
        echo -n "\"$var\": \"${!var}\", "
    done
}

# These are variables from the module .lua files
params1=(CANDLE SITE TURBINE_HOME)

# This is the result from:
#   submit_script="/data/BIDS-HPC/public/candle-dev/Supervisor/templates/scripts/submit_candle_job.sh"
#   params=( $(grep "^export " $submit_script | grep -v "export USE_CANDLE=" | awk -v ORS=" " '{split($2,arr,"="); print arr[1]}'))
params2=(MODEL_SCRIPT DEFAULT_PARAMS_FILE PYTHON_BIN_PATH EXEC_PYTHON_MODULE SUPP_MODULES SUPP_PYTHONPATH WORKFLOW_TYPE WORKFLOW_SETTINGS_FILE EXPERIMENTS MODEL_NAME OBJ_RETURN PROCS WALLTIME GPU_TYPE)

# These are variables from run_workflows.sh
params3=(CPUS_PER_TASK MEM_PER_NODE PPN)

# Write the dictionary in JSON format
tmp="$(output_json_format "${params1[@]}")$(output_json_format "${params2[@]}")$(output_json_format "${params3[@]}")"
echo "{${tmp:0:${#tmp}-2}}" > metadata.json