#!/bin/bash

# Run this script in an interactive MPI session, e.g.,
#
#   sinteractive -n 3 -N 3 --ntasks-per-core=1 --cpus-per-task=16 --gres=gpu:k20x:1,lscratch:400 --mem=60G --no-gres-shell
#
# by calling, from a fast network-shared directory (such as on the /data drive; calling it $SHARED_DIR below), e.g.,
#
#   /data/BIDS-HPC/public/software/checkouts/fnlcr-bids-sdsi/candle/build/build_candle_on_biowulf.sh <SECTION>
#
# Things to set:
#
#   (1) Assume new (or old) candle module is created and loaded as usual (take reference from fnlcr-bids-sdsi/candle/lmod_modules/{main.lua,dev.lua})
#   (2)
        section=${1:-0} # set this to 1, 2, 3, etc. sequentially to build CANDLE incrementally
#


# Load the build Python environment; always do this
module load $MODULES_FOR_BUILD

#0: General setup steps
if [ $section -eq 0 ]; then

    # Setup
    source $CANDLE/Supervisor/workflows/common/sh/env-biowulf.sh
    module list
    BUILD_SCRIPTS_DIR=$(cd $(dirname $0); pwd)
    LOCAL_DIR="/lscratch/$SLURM_JOB_ID"
    SHARED_DIR=$(pwd)

#1: Directory and code setup section
elif [ $section -eq 1 ]; then

    # Set up the main CANDLE directory structure
    mkdir $CANDLE
    cd $CANDLE
    mkdir {checkouts,builds}

    # Check out all necessary source code
    cd checkouts
    git clone https://github.com/ECP-CANDLE/Supervisor; cd Supervisor; git checkout fnlcr; cd ..
    git clone https://github.com/ECP-CANDLE/Benchmarks; cd Benchmarks; git checkout fnlcr; cd ..
    git clone https://github.com/ECP-CANDLE/Candle
    git clone https://github.com/swift-lang/swift-t
    cd ..

    # Create the build directories
    cd builds
    mkdir -p R/libs
    mkdir swift-t-install
    cd ..

    # Create symbolic links in the main CANDLE directory
    ln -s checkouts/Supervisor
    ln -s checkouts/Benchmarks
    ln -s checkouts/Candle
    ln -s checkouts/swift-t
    ln -s builds/R
    ln -s builds/swift-t-install

    # Load the CANDLE environment to make sure no errors, except that in the line below, occur
    # When building, the "which swift-t" command should throw and error as expected, because we haven't yet built Swift/T!
    source Supervisor/workflows/common/sh/env-biowulf.sh

#2: Test MPI communications
elif [ $section -eq 2 ]; then

    # Setup
    source $CANDLE/Supervisor/workflows/common/sh/env-biowulf.sh
    module list
    BUILD_SCRIPTS_DIR=$(cd $(dirname $0); pwd)
    SHARED_DIR=$(pwd)

    mpicc $BUILD_SCRIPTS_DIR/hello.c
    echo -e "\nSRUN\n"
    srun -n 3 $SHARED_DIR/a.out
    echo -e "\nMPIRUN\n"
    mpirun -n 3 $SHARED_DIR/a.out
    echo -e "\nMPIEXEC\n"
    mpiexec -n 3 $SHARED_DIR/a.out

#3: Build CANDLE R modules
elif [ $section -eq 3 ]; then

    # Setup
    source $CANDLE/Supervisor/workflows/common/sh/env-biowulf.sh
    module list
    LOCAL_DIR="/lscratch/$SLURM_JOB_ID"
    SHARED_DIR=$(pwd)

    # Yes, it may appear that the wrong version of GCC is being used (probably due to the R paths) but so far we've found this is fine
    cd $LOCAL_DIR
    $CANDLE/Supervisor/workflows/common/R/install-candle.sh |& tee -a candle-r_installation_out_and_err.txt
    mv candle-r_installation_out_and_err.txt $SHARED_DIR

#4: Set up Swift/T and EQ-R settings
elif [ $section -eq 4 ]; then

    # Setup
    source $CANDLE/Supervisor/workflows/common/sh/env-biowulf.sh
    module list
    BUILD_SCRIPTS_DIR=$(cd $(dirname $0); pwd)

    cp -i $CANDLE/swift-t/dev/build/swift-t-settings.sh.template $CANDLE/swift-t/dev/build/swift-t-settings.sh
    echo "(1) Confirm there aren't any significant changes between $BUILD_SCRIPTS_DIR/swift-t-settings.sh and $CANDLE/swift-t/dev/build/swift-t-settings.sh (make those files the same!)"
    echo "(2) Confirm the settings in $CANDLE/swift-t/dev/build/swift-t-settings.sh are good"

    cp -i $CANDLE/Supervisor/workflows/common/ext/EQ-R/eqr/settings.template.sh $CANDLE/Supervisor/workflows/common/ext/EQ-R/eqr/settings.sh
    echo "(3) Confirm there aren't any significant changes between $BUILD_SCRIPTS_DIR/eqr_settings.sh and $CANDLE/Supervisor/workflows/common/ext/EQ-R/eqr/settings.sh (make those files the same!)"
    echo "(4) Confirm the settings in $CANDLE/Supervisor/workflows/common/ext/EQ-R/eqr/settings.sh are good"

#5: Build and install Swift/T
elif [ $section -eq 5 ]; then

    # Setup
    source $CANDLE/Supervisor/workflows/common/sh/env-biowulf.sh
    module list
    LOCAL_DIR="/lscratch/$SLURM_JOB_ID"
    SHARED_DIR=$(pwd)

    cd $LOCAL_DIR
    export NICE_CMD=""
    $CANDLE/swift-t/dev/build/build-swift-t.sh -v |& tee -a swift-t_installation_out_and_err.txt
    mv swift-t_installation_out_and_err.txt $SHARED_DIR

#6: Build EQ-R per the instructions $CANDLE/Supervisor/workflows/common/ext/EQ-R/eqr/COMPILING.txt
elif [ $section -eq 6 ]; then

    # Setup
    source $CANDLE/Supervisor/workflows/common/sh/env-biowulf.sh
    module list
    SHARED_DIR=$(pwd)

    cd $CANDLE/Supervisor/workflows/common/ext/EQ-R/eqr
    source settings.sh #|& tee -a eqr_installation_out_and_err.txt --> LEAVE THIS COMMENTED OUT; OTHERWISE THE SOURCE COMMAND DOES NOT WORK!
    ./bootstrap |& tee -a eqr_installation_out_and_err.txt
    ./configure --prefix=$PWD/.. |& tee -a eqr_installation_out_and_err.txt
    make install |& tee -a eqr_installation_out_and_err.txt
    mv eqr_installation_out_and_err.txt $SHARED_DIR

    # Save the final build environment and ensure permissions are correct
    env > $SHARED_DIR/final_build_environment.txt
    chmod -R o=u-w $CANDLE

#7: Test a model on a single node; you can kill it once it seems to be working
elif [ $section -eq 7 ]; then

    # Setup
    source $CANDLE/Supervisor/workflows/common/sh/env-biowulf.sh
    module list

    srun -n 1 python $CANDLE/Benchmarks/Pilot1/P1B3/p1b3_baseline_keras2.py

#8: Test simple Swift/T functionality
elif [ $section -eq 8 ]; then

    # Setup
    source $CANDLE/Supervisor/workflows/common/sh/env-biowulf.sh
    module list
    BUILD_SCRIPTS_DIR=$(cd $(dirname $0); pwd)

    # Test 1: output is a single line saying hello
    swift-t -n 3 $BUILD_SCRIPTS_DIR/mytest2.swift

    # Test 2: time-delayed printouts of some numbers
    swift-t -n 3 -r $BUILD_SCRIPTS_DIR $BUILD_SCRIPTS_DIR/myextension.swift

fi
