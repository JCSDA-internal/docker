JEDI Dokcer image
=================

What is this repository for?
----------------------------

The repository builds the Docker image with common libraries used by NWP models, such as WRF, GSI, MPAS, FV3 etc.


Download, build, and install the following libraries :
------------------------------------------------------

* open-mpi v2.1.0
* zlib v1.2.11
* szip v2.1.1
* jpeg v9b
* png v1.4.19
* jasper v1.900.2 
* hdf5 v1.8.17
* freetype v2.5.5
* netcdf-c v4.4.11
* netcdf-fortran v4.4.4
* lapack v3.7.0
* parallel-netcdf v1.8.1
* xerces-c v3.1.4
* esmf v7.0.0
* udunites-2 v2.2.24
* nco v4.6.6
* grib_api v1.21.0
* cdo v1.8.2
* pio v1.7.1

-----------------------------------------------

The major NCEP libraries are also installed at :

* /nwprod/lib/bacio/v2.0.1/libbacio_v2.0.1_4.a
* /nwprod/lib/bacio/v2.0.1/libbacio_v2.0.1_8.a
* /nwprod/lib/ip/v2.0.0/libip_v2.0.0_4.a
* /nwprod/lib/ip/v2.0.0/libip_v2.0.0_8.a
* /nwprod/lib/ip/v2.0.0/libip_v2.0.0_d.a
* /nwprod/lib/sigio/v2.0.1/lib/libsigio_v2.0.1_4.a
* /nwprod/lib/sigio/v2.0.1/libsigio_v2.0.1_4.a
* /nwprod/lib/sp/v2.0.2/libsp_v2.0.2_4.a
* /nwprod/lib/sp/v2.0.2/libsp_v2.0.2_8.a
* /nwprod/lib/sp/v2.0.2/libsp_v2.0.2_d.a
* /nwprod/lib/w3emc/v2.2.0/libw3emc_v2.2.0_4.a
* /nwprod/lib/w3emc/v2.2.0/libw3emc_v2.2.0_8.a
* /nwprod/lib/w3emc/v2.2.0/libw3emc_v2.2.0_d.a
* /nwprod/lib/w3nco/v2.0.6/libw3nco_v2.0.6_4.a
* /nwprod/lib/w3nco/v2.0.6/libw3nco_v2.0.6_8.a
* /nwprod/lib/w3nco/v2.0.6/libw3nco_v2.0.6_d.a

   
How to build the image
----------------------

*The id_rsa has to be replaced with your $HOME/.ssh/id_rsa to let you access the private github repositories.*

.. code:: bash

 > docker image build -t jcsda/docker .
 > docker image push jcsda/docker

**Highly recommend compile all libraries with the same compiler family**

*Please* `write to me`_, *if you need more libraries being included.*

.. _write to me: xin.l.zhang@noaa.gov
