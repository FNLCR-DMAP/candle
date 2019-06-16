#!/bin/bash

# This is based on instructions at https://github.com/ECP-CANDLE/Supervisor/tree/master/workflows as of 1/18/19.
# Files to pull to Github: set_up_candle_on_biowulf.sh (this file), hello.c, swift-t-settings.sh, everything else in this directory!
# Compilation/testing done on compute nodes using command "sinteractive -n 3 -N 3 --gres=gpu:k20x:1 --mem=20G --no-gres-shell"
# --> actually now it's done using "sinteractive -n 2 -N 2 --gres=gpu:k20x:1 --no-gres-shell"

# Set up environment
#module load R/3.5.0 gcc/7.4.0 openmpi/3.1.3/gcc-7.4.0-pmi2 tcl_tk/8.6.8_gcc-7.2.0 python/3.6 ant/1.10.3 java/1.8.0_181
module load R/3.5.0 gcc/7.3.0 openmpi/3.1.2/cuda-9.0/gcc-7.3.0-pmi2 tcl_tk/8.6.8_gcc-7.2.0 python/3.6 ant/1.10.3 java/1.8.0_181
CANDLE=/data/BIDS-HPC/public/candle
export R_LIBS=$CANDLE/R/libs/

# At least with only openmpi module loaded, confirm that everything's working correctly (note per Wolfgang Resch's email srun must be used instead of mpirun or mpiexec):
#weismanal@cn0613:~/notebook/2019-01-17 $ mpicc hello.c
#weismanal@cn0613:~/notebook/2019-01-17 $ srun -n 3 a.out
#[snip]
#Hello from node cn0613, rank 0 / 3 (CUDA_VISIBLE_DEVICES=1)
#Hello from node cn0614, rank 1 / 3 (CUDA_VISIBLE_DEVICES=0)
#Hello from node cn0615, rank 2 / 3 (CUDA_VISIBLE_DEVICES=0)

#### BUILD ####
if [ 0 -eq 1 ]; then
    # (1) Update CANDLE software
    pushd $CANDLE/Supervisor
    git pull; popd
    pushd $CANDLE/Candle
    git pull; popd;
    pushd $CANDLE/Benchmarks
    git pull; popd

    # (2) Install the CANDLE R packages --> don't forget to create $CANDLE/R/libs first!!
    $CANDLE/Supervisor/workflows/common/R/install-candle.sh |& tee -a candle-r_installation_out_and_err.txt

    # (3) Update Swift/T
    pushd $CANDLE/swift-t
    git pull; popd

    # (4) Set up the Swift/T installation
    mv $CANDLE/swift-t/dev/build/swift-t-settings.sh $CANDLE/swift-t/dev/build/swift-t-settings-orig.sh
    ln -s $(pwd)/swift-t-settings.sh $CANDLE/swift-t/dev/build/swift-t-settings.sh

    # (5) Build and install Swift/T
    $CANDLE/swift-t/dev/build/build-swift-t.sh -v |& tee -a swift-t_installation_out_and_err.txt

    # (6) Save the build environment
    env > final_build_environment.txt

    # (7) Build EQ-R per the instructions /data/BIDS-HPC/public/candle/Supervisor/workflows/common/ext/EQ-R/eqr/COMPILING.txt
    cd /data/BIDS-HPC/public/candle/Supervisor/workflows/common/ext/EQ-R/eqr
    source settings.sh #|& tee -a eqr_installation_out_and_err.txt
    ./bootstrap |& tee -a eqr_installation_out_and_err.txt
    ./configure --prefix=$PWD/.. |& tee -a eqr_installation_out_and_err.txt
    make install |& tee -a eqr_installation_out_and_err.txt
    env > final_build_environment-after_eqr.txt
    
fi


#### TEST ####
# Testing done on "sinteractive -n 3 -N 3 --gres=gpu:k20x:1 --mem=20G --no-gres-shell"

export OMPI_MCA_btl_openib_if_exclude="mlx4_0:1"
export PATH=$PATH:$CANDLE/swift-t-install/stc/bin
export PATH=$PATH:$CANDLE/swift-t-install/turbine/bin
export TURBINE_LOG=1
export ADLB_DEBUG_RANKS=1
export ADLB_DEBUG_HOSTMAP=1

if [ 0 -eq 1 ]; then

    # (1) Test MPI
    srun -n 1 python $CANDLE/Benchmarks/Pilot1/P1B3/p1b3_baseline_keras2.py

    # (2)
    mpicc hello.c
    srun -n 3 a.out

    # (3) Test Swift/T
    swift-t -n 3 mytest2.swift

    # (4)
    swift-t -n 3 -r $(pwd) myextension.swift

fi
