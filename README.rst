JEDI Docker image
=================


What is this repository for?
----------------------------

The repository builds the Docker image from two building blocks:

* The jcsda/docker_base image, which contains the compilers and mpi library
* The jedi-stack build scripts

For a list of the software that is installed in the image, see the `jedi-stack <https://github.com/jcsda/jedi-stack.git>`_ repo.  

Our current workflow is to have a different container for each compiler/mpi combination we support.  So, all libraries are installed in /usr/local, as opposed to the module-based setup otherwise produced by the jedi-stack build system.

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

 > docker image build -t jcsda/docker-gnu-openmpi-dev .
 > docker push jcsda/docker-gnu-openmpi-dev


*Please* `contact Mark Miesch`_, *if you need more libraries being included.*

.. _contact Mark Miesch: miesch@ucar.edu
