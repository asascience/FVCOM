#!/bin/sh

HOMEnos=/lfs/h1/nos/nosofs/noscrub/lixia.wang/packages/nosofs.v3.6.0
cd ../..
HOMEnos=`pwd`

BUILD_VERSION_FILE=$HOMEnos/versions/build.ver
if [ -f $BUILD_VERSION_FILE ]; then
 . $BUILD_VERSION_FILE
else
   echo " Build Version File $BUILD_VERSION_FILE does not exist **"
   exit
fi
export HOMEnos=${HOMEnos:-${PACKAGEROOT:?}/nosofs.${nosofs_ver:?}}
export COMP_F=ftn
export COMP_F_MPI90=ftn
export COMP_F_MPI=ftn
export COMP_ICC=cc
export COMP_CC=cc
export COMP_CPP=cpp
export COMP_MPCC=cc

module purge
printenv SHELL
module purge
module load envvar/$envvars_ver
# Loading Intel Compiler Suite
module load PrgEnv-intel/${PrgEnv_intel_ver}
module load craype/${craype_ver}
module load intel/${intel_ver}
module load cray-mpich/${cray_mpich_ver}
module load cray-pals/${cray_pals_ver}

#Set other library variables
module load metis/${metis_ver}
#module load netcdf/${netcdf_ver}
#module load hdf5/${hdf5_ver}
module load bacio/${bacio_ver}
module load w3nco/${w3nco_ver}
module load w3emc/${w3emc_ver}
module load g2/${g2_ver}
module load zlib/${zlib_ver}
module load libpng/${libpng_ver}
module load bufr/${bufr_ver}
module load jasper/${jasper_ver}
module load petsc/${petsc_ver}
#
#Set other library variables
module load netcdf/${netcdf_ver}
module load hdf5/${hdf5_ver}
module load subversion/${subversion_ver}

export SORCnos=$HOMEnos/sorc
export EXECnos=$HOMEnos/exec
export LIBnos=$HOMEnos/lib

if [ ! -s $EXECnos ]
then
  mkdir -p $EXECnos
fi
export LIBnos=$HOMEnos/lib

if [ ! -s $LIBnos ]
then
  mkdir -p $LIBnos
fi

#export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lfs/h1/nos/nosofs/noscrub/lixia.wang/packages/nosofs.v3.6.0/sorc/FVCOM.fd/FVCOM_source447/libs/proj.4-master/lib
export LD_LIBRARY_PATH=$LD_LIBRARY_PATH:/lfs/h1/nos/nosofs/noscrub/lixia.wang/packages/nosofs.v3.6.0/sorc/FVCOM.fd/FVCOMv4.4.7.1/src/libs/proj.4-master/lib64

#export PETSC_DIR=/lfs/h1/nos/nosofs/noscrub/lixia.wang/packages/libs/petsc

export PETSC_DIR=/apps/prod/intel-19.1.3.304/cray-mpich-8.1.9/petsc/3.20.4



cd $SORCnos/FVCOM.fd/FVCOMv4.4.7.1/src

gmake clean
gmake -f makefile_necofs
#if [ -s  fvcom ]; then
#  mv fvcom $EXECnos/.
#else
#  echo 'fvcom executable is not created'
#fi

rm -f *.o *.mod
exit


gmake clean
gmake -f makefile_NGOFS2
#if [ -s  fvcom ]; then
#  mv fvcom $EXECnos/.
#else
#  echo 'fvcom executable is not created'
#fi

rm -f *.o *.mod



exit
