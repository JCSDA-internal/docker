# README #

The repository includes the building system for common libraries used by NWP models, such as WRF, GSI etc.

### What is this repository for? ###

Download, build, and install the following libraries :

* open-mpi v2.1.0
* zlib v1.2.11
* szip v2.1.1
* jpeg v9b
* png v1.4.19
* jasper v1.900.2 
* hdf5 v1.8.18
* freetype v2.5.5
* netcdf-c v4.4.11
* netcdf-fortran v4.4.4
* lapack v3.7.0
* parallel-netcdf v1.8.1
* xerces-c v3.1.4
* esmf v7.0.0
* udunites-2 v2.2.24
* nco v4.6.6

### How do I get set up? ###

* Make sure that your computer has the internet connection

* clone the codes

```
#!bash

git clone https://${USERID}@bitbucket.org/jcsda/common_libs.git your_desired_path_name
```
  
* cd into the directory

```
#!bash

cd your_desired_path_name
```

* set your desired compilers in environmental variables, e.g. for GNU compilers:

```
#!bash

export CC=gcc
export CXX=g++
export FC=gfortran
```
  
* Create and cd into a build directory
```
#!bash

mkdir build; cd build
```

* use cmake to configure the system

```
#!bash

# Build all libs
cmake -DBUILD_ALL=ON ..

# Build specific libraries e.g. netCDF and its dependencies
cmake -DBUILD_NETCDF=ON ..
```

* Build in parallel e.g. use 4 threads
```
#!bash

make -j4
```

* If built successfully, add the **bin** to **PATH**, add **lib** to **LD\_LIBRARY\_PATH** to your environment. For example: in $HOME/.bashrc, add following lines:

```
#!bash

export PATH=your_desired_path_name/bin${PATH:+:}${PATH}
export LD_LIBRARY_PATH=your_desired_path_name/lib${LD_LIBRARY_PATH:+:}${LD_LIBRARY_PATH}
```
* On MacOS system you might need to set: 
```
export DYLD_FALLBACK_LIBRARY_PATH=your_desired_path_name/lib${DYLD_FALLBACK_LIBRARY_PATH:+:}${DYLD_FALLBACK_LIBRARY_PATH}
```
  
8. If built ESMF successfully, please find the esmf.mk file and add ESMFMKFILE (pointed to the esmf.mk) into environment variable.
 
```
find . -name esmf.mk
export ESMFMKFILE=the_absolute_path_of_esmf.mk
```
   
### Highly recommend compile all libraries with the same compiler family ###

*Please contact `xin.l.zhang@noaa.gov`, if you need more libraries being included*