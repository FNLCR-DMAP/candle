#!/bin/bash

mods="intel-mpi
mpich2/3.2.1/gcc-5.5.0
mvapich2/2.2/gcc-7.3.0
mvapich2/2.2/intel-2018.1.163
openmpi/3.1.2/cuda-9.0/gcc-7.3.0
openmpi/3.1.2/cuda-9.0/gcc-7.3.0-pmi2
openmpi/3.1.2/cuda-9.0/intel-2018.3.222
openmpi/3.1.2/cuda-9.0/intel-2018.3.222-pmi2
openmpi/3.1.3/gcc-7.4.0
openmpi/3.1.3/gcc-7.4.0-pmi2
openmpi/3.1.3/intel-2019.1.144
openmpi/3.1.3/intel-2019.1.144-pmi2"

export OMPI_MCA_btl_openib_if_exclude="mlx4_0:1" # --mca btl_openib_if_exclude "mlx4_0:1"

for mod in $mods; do
    module load $mod &> /dev/null
    mpicc hello.c &> /dev/null
    if [ $? -eq 0 ]; then
	echo -e "\n################### $mod ###################\n"
	echo -e "\n  ################### mpirun ###################\n"
	mpirun a.out && echo "SUCCESS" || echo "FAILURE"
	echo -e "\n    ################### mpiexec ###################\n"
	mpiexec a.out && echo "SUCCESS" || echo "FAILURE"
	echo -e "\n      ################### srun ###################\n"
	srun a.out && echo "SUCCESS" || echo "FAILURE"
    fi
    module purge &> /dev/null
done
