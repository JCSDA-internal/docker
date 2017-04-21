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

### How do I get set up? ###

1. Make sure that your computer has the internet connection

2. clone the codes

   * git clone https://${USERID}@bitbucket.org/jcsda/common\_libs.git your\_desired\_path\_name
  
3. cd your\_desired\_path\_name

4. set your desired compilers in environmental variables, for example:

   * export CC=gcc
   * export CXX=g++
   * export FC=gfortran
  
5. mdkir build; cd build

6. use cmake to configure the system

   * *Build all libs*
   * cmake -DBUILD\_ALL=ON ..
   * *Build NETCDF and its dependees*
   * cmake -DBUILD\_NETCDF=ON ..

7. Use 4 threads to do the parallel build parallell

   * make -j4

8. If built successfully, please add the bin to PATH, addlib to LD\_LIBRARY\_PATH in your environmental setting. For example: in $HOME/.bashrc, add following lines:

   * export PATH=your\_desired\_path\_name/bin:$PATH
   * export LD\_LIBRARY\_PATH=your\_desired\_path\_name/path:$LD\_LIBRARY\_PATH
  
8. If built ESMF successfully, please find the esmf.mk file and add ESMFMKFILE (pointed to the esmf.mk) into environment variable.
 
   * find . -name esmf.mk
   * export ESMFMKFILE=the\_absolute\_path\_of\_esmf.mk
   
### Highly recommend compile all libraries with the same compiler family ###

*Please contact xin.l.zhang@noaa.gov, if you need more libraries being included*
