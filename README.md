# README #

The repository includes the building system for common libraries, such as NetCDF, HDF5, Z, PNG, JPEG, Jasper etc.

### What is this repository for? ###

* Download, build, and install the common libraries used by NWP models

### How do I get set up? ###

* set your desired compilers in environmental variables, for example:
  * export CC=gcc
  * export CXX=g++
  * export FC=gfortran
* mdkir build
* cd build
* cmake ..
* If build successful, please add the bin, lib to PATH, LD_LIBRARY_PATH