#!/bin/bash

module load tcl_tk/8.6.8_gcc-7.2.0 gcc/7.2.0 java/1.8.0_181

#suffix="-3"
#suffix="-mxm"
suffix="-no_slurm"

INSTALL="/data/BIDS-HPC/public/software/builds/mpich-3.3$suffix"
SRC="/data/BIDS-HPC/public/software/source/mpich-3.3"
BLD="/lscratch/$SLURM_JOB_ID/mpich-3.3$suffix"

mkdir $INSTALL $BLD

#config_options="--prefix=$INSTALL --enable-shared --with-pmi=slurm --with-pm=no --with-slurm=/usr/local/slurm --with-slurm-include=/usr/local/slurm/include --with-slurm-lib=/usr/local/slurm/lib"
#config_options="--prefix=$INSTALL --enable-shared --with-pmi=slurm --with-pm=no --with-slurm=/usr/local/slurm --with-slurm-include=/usr/local/slurm/include --with-slurm-lib=/usr/local/slurm/lib --with-device=ch3:nemesis:mxm"
config_options="--prefix=$INSTALL --enable-shared --with-slurm=/usr/local/slurm --with-slurm-include=/usr/local/slurm/include --with-slurm-lib=/usr/local/slurm/lib" # no SLURM

#   --with-slurm=[PATH]     specify path where slurm include directory and lib
#                           directory can be found
#   --with-slurm-include=PATH
#                           specify path where slurm include directory can be
#                           found
#   --with-slurm-lib=PATH   specify path where slurm lib directory can be found

# Do this per the configure script's recommendations:
export FC=$F90
unset F90

mypwd=$(pwd)
cd $BLD

env | grep -i mpi

# configure
export LD_LIBRARY_PATH=/usr/local/slurm/lib:$LD_LIBRARY_PATH
$SRC/configure $config_options |& tee $mypwd/mpich-3.3_configure$suffix.txt

# make
#make |& tee $mypwd/mpich-3.3_make$suffix.txt

# make install
#make install |& tee $mypwd/mpich-3.3_make_install$suffix.txt

# Notes from this step (in the output):
# ----------------------------------------------------------------------
# Libraries have been installed in:
#    /data/BIDS-HPC/public/software/builds/mpich-3.3/lib

# If you ever happen to want to link against installed libraries
# in a given directory, LIBDIR, you must either use libtool, and
# specify the full pathname of the library, or use the '-LLIBDIR'
# flag during linking and do at least one of the following:
#    - add LIBDIR to the 'LD_LIBRARY_PATH' environment variable
#      during execution
#    - add LIBDIR to the 'LD_RUN_PATH' environment variable
#      during linking
#    - use the '-Wl,-rpath -Wl,LIBDIR' linker flag
#    - have your system administrator add LIBDIR to '/etc/ld.so.conf'

# See any operating system documentation about shared libraries for
# more information, such as the ld(1) and ld.so(8) manual pages.
# ----------------------------------------------------------------------

# suffix="-3"

# # # To add to PATH for execution:
# export PATH=/data/BIDS-HPC/public/software/builds/mpich-3.3$suffix/bin:$PATH

# # # To add for compilation against this build:
# export LD_LIBRARY_PATH=/data/BIDS-HPC/public/software/builds/mpich-3.3$suffix/lib:$LD_LIBRARY_PATH
# export LIBDIR=/data/BIDS-HPC/public/software/builds/mpich-3.3$suffix/lib:$LIBDIR
# export CPATH=/data/BIDS-HPC/public/software/builds/mpich-3.3$suffix/include:$CPATH
