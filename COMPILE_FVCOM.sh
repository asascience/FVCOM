#!/bin/sh
set -x
#HOMEnos=/lfs/h1/nos/nosofs/noscrub/$LOGNAME/packages/nosofs.v3.6.0
#cd ../..
#HOMEnos=`pwd`

export HOMEnos=$(dirname $(dirname $PWD))
echo $HOMEnos

BUILD_VERSION_FILE=$HOMEnos/versions/build.ver
if [ -f $BUILD_VERSION_FILE ]; then
 . $BUILD_VERSION_FILE
else
   echo " Build Version File $BUILD_VERSION_FILE does not exist **"
   exit
fi
export HOMEnos=${HOMEnos:-${PACKAGEROOT:?}/nosofs.${nosofs_ver:?}}

# TODO: get envvar module from wcoss-2 and/or other systems
# TODO: if envvars isn't working within a module, try loading it as a prerequisite in the platform modulefile
#module load envvar/$envvars_ver

set +x
module use -a $HOMEnos/modulefiles
#module load wcoss2_prod
module load ioos-sb.intel_x86_64
set -x

export SORCnos=$HOMEnos/sorc
export EXECnos=$HOMEnos/exec
export LIBnos=$HOMEnos/lib

FVCOM_source=FVCOM_source.prod

if [ ! -s $EXECnos ]
then
  mkdir -p $EXECnos
fi
export LIBnos=$HOMEnos/lib

if [ ! -s $LIBnos ]
then
  mkdir -p $LIBnos
fi
set -x

cd $SORCnos/FVCOM.fd/$FVCOM_source/libs/julian
gmake clean
gmake -f makefile

if [ -s libjulian.a ]; then
  cp -p libjulian.a $LIBnos
else
  echo "WARNING: libjulian.a was not created"
fi
rm -f *.o

# Proj4 needs to be unzipped before building proj4.zip
#BUILD_PROJ4="YES"

BUILD_PROJ4="NO"

if [[ $BUILD_PROJ4 == "YES" ]]; then
  cd $SORCnos/FVCOM.fd/$FVCOM_source/libs
  unzip -n proj4.zip

  cd  $SORCnos/FVCOM.fd/$FVCOM_source/libs/proj.4-master
  gmake clean
  ./configure CC=$COMP_CC FC=$COMP_F CFLAGS='-DIFORT -g -w -O2'       \
          --prefix=$SORCnos/FVCOM.fd/$FVCOM_source/libs/proj.4-master
  gmake
  gmake install
  if [ -s ./lib64/libproj.a ]; then
    cp -p ./lib64/libproj.* $LIBnos
  else
    echo "WARNING: ./lib64/libproj.a was not created"
  fi

  cd $SORCnos/FVCOM.fd/$FVCOM_source/libs/proj4-fortran-master
  gmake clean
  ./configure CC=$COMP_CC FC=$COMP_F CFLAGS='-DIFORT -g -w -O2'           \
        proj4=$SORCnos/FVCOM.fd/$FVCOM_source/libs/proj.4-master          \
        --prefix=$SORCnos/FVCOM.fd/$FVCOM_source/libs/proj4-fortran-master
  gmake
  gmake install
  if [ -s ./lib64/libfproj4.a ]; then
    cp -p ./lib64/libfproj4.a $LIBnos
  else
    echo "WARNING: ./lib/libfproj4.a was not created"
  fi
fi

cd $SORCnos/FVCOM.fd/$FVCOM_source

models='leofs lmhofs loofs lsofs ngofs2 sfbofs sscofs'
# models='necofs'
models='sfbofs'

for model in $models
do
  gmake clean
  # model^^ is upper-case model
  gmake -f makefile_${model^^}
  if [ -s  fvcom_${model} ]; then
    mv fvcom_${model} $EXECnos/.
  else
    echo 'fvcom executable is not created'
  fi
done

exit

#gmake clean
#gmake -f makefile_necofs
#if [ -s  fvcom_necofs ]; then
#  mv fvcom_necofs $EXECnos/.
#else
#  echo 'necofs fvcom executable is not created'
#fi

#exit

gmake clean
gmake -f makefile_NGOFS2
if [ -s  fvcom_ngofs2 ]; then
  mv fvcom_ngofs2 $EXECnos/.
else
  echo 'fvcom executable is not created'
fi

gmake clean
gmake -f makefile_SFBOFS
if [ -s  fvcom_sfbofs ]; then
  mv fvcom_sfbofs $EXECnos/.
else
  echo 'fvcom executable is not created'
fi

gmake clean
gmake -f makefile_LEOFS
if [ -s  fvcom_leofs ]; then
  mv fvcom_leofs $EXECnos/.
else
  echo 'fvcom executable is not created'
fi

gmake clean
gmake -f makefile_LMHOFS
if [ -s  fvcom_lmhofs ]; then
  mv fvcom_lmhofs $EXECnos/.
else
  echo 'fvcom executable is not created'
fi

gmake clean
gmake -f makefile_LOOFS
if [ -s  fvcom_loofs ]; then
  mv fvcom_loofs $EXECnos/.
else
  echo 'fvcom executable is not created'
fi

gmake clean
gmake -f makefile_LSOFS
if [ -s  fvcom_lsofs ]; then
  mv fvcom_lsofs $EXECnos/.
else
  echo 'fvcom executable is not created'
fi

cd $SORCnos/FVCOM.fd/$FVCOM_source
gmake clean
gmake -f makefile_SSCOFS
if [ -s  fvcom_sscofs ]; then
  mv fvcom_sscofs $EXECnos/.
else
  echo 'fvcom executable is not created'
fi

exit

