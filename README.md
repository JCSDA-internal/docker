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

### How do I get set up? ###

1. Make sure that your computer has the internet connection
1. clone the codes
  * git clone git@bitbucket.org:jcsda/common_libs.git your\_disired\_path\_name
1. cd your\_disired\_path_name
1. set your desired compilers in environmental variables, for example:
  * export CC=gcc
  * export CXX=g++
  * export FC=gfortran
1. mdkir build; cd build
1. 
  * cmake -DBUILD\_ALL ..      *Build all libs*
  * cmake -DBUILD\_NETCDF ..   *Build NETCDF and its dependees*
1. make -j4                     *Use 4 threads to build*
1. If build successful, please add the bin to PATH, addlib to LD\_LIBRARY\_PATH in your environmental setting. For example: in $HOME/.bashrc, add following lines:
  * export PATH=your\_disired\_path_name/bin:$PATH
  * export LD\_LIBRARY\_PATH=your\_disired\_path\_name/bin:$LD\_LIBRARY\_PATH
  
### Highly recommend compile all libraries with the same compiler family ###