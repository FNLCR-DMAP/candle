#!/bin/bash

# NOTE: To run interactively, remember that --no-gres-shell must be present as an argument to sinteractive!

# Sample output using "sinteractive --cpus-per-task=1 --ntasks-per-node=1 --nodes=3 --mem=20G --gres=gpu:k20x:1 --no-gres-shell":
#
#weismanal@cn0612:~/notebook/2019-01-29 $ bash submit_hello.sh
#[+] Loading gcc  7.3.0  ... 
#[+] Loading openmpi 3.1.2/CUDA-9.0  for GCC 7.3.0 
#############################
#Hello from node cn0612, rank 0 / 3 (CUDA_VISIBLE_DEVICES=NoDevFiles)
#Hello from node cn0613, rank 1 / 3 (CUDA_VISIBLE_DEVICES=0)
#Hello from node cn0614, rank 2 / 3 (CUDA_VISIBLE_DEVICES=0)
#############################
#Hello from node cn0612, rank 0 / 3 (CUDA_VISIBLE_DEVICES=NoDevFiles)
#Hello from node cn0613, rank 1 / 3 (CUDA_VISIBLE_DEVICES=0)
#Hello from node cn0614, rank 2 / 3 (CUDA_VISIBLE_DEVICES=0)
#############################
#Hello from node cn0612, rank 0 / 3 (CUDA_VISIBLE_DEVICES=1)
#Hello from node cn0613, rank 1 / 3 (CUDA_VISIBLE_DEVICES=0)
#Hello from node cn0614, rank 2 / 3 (CUDA_VISIBLE_DEVICES=0)
#############################

module load openmpi/3.1.2/cuda-9.0/gcc-7.3.0-pmi2
export OMPI_MCA_btl_openib_if_exclude="mlx4_0:1"

mpicc hello.c

echo "############################"
mpirun a.out | sort
sleep 1
echo "############################"
mpiexec a.out | sort
sleep 1
echo "############################"
srun a.out | sort
sleep 1
echo "############################"
