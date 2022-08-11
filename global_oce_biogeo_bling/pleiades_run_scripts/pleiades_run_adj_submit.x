#!/bin/bash
#PBS -W group_list=s2317
#PBS -l select=1:ncpus=1:model=bro
###PBS -q 
#PBS -q normal
#PBS -l walltime=00:10:00
#PBS -j oe
#PBS -W umask=33
#PBS -m bea
#PBS -r n
####
#PBS -N gbgc_adj_test 
#PBS -o gbgc_adj_test.out 
#PBS -e gbgc_adj_test.err 
#PBS -V
####

module purge
module load comp-intel/2018.3.222 mpi-hpe/mpt.2.25 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt
####module load comp-intel/2016.2.181 mpi-sgi/mpt.2.14r19 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt
####module load comp-intel/2018.3.222  mpi-hpe/mpt.2.21 hdf4/4.2.12 hdf5/1.8.18_mpt netcdf/4.4.1.1_mpt
module list


ASSIM_RUNDIR=/nobackup/averdy/gbgc/test/
cd $ASSIM_RUNDIR
echo $PWD
echo `ls`

#set up optimization iteration number

mpiexec -np 1 /u/scicon/tools/bin/mbind.x ./mitgcmuv_ad > run_adj.out 

