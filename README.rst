JEDI Docker image
=================


What is this repository for?
----------------------------

The repository builds the Docker image from two building blocks:

* The jcsda/docker_base image, which contains the compilers and mpi library
* The jedi-stack build scripts

For a list of the software that is installed in the image, see the `jedi-stack <https://github.com/jcsda/jedi-stack.git>`_ repo (select the ``develop`` branch for the most up to date information).

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


Container workflow
------------------

To build one of the docker containers, enter, e.g.:

.. code:: bash

  ./build_container.sh gnu-openmpi-dev beta

The first argument (required) is the name of the container, which must match one of the Dockerfiles in the repo.  The second argument (optional) is the tag.  If omitted, it defaults to `beta`

After building the container, the next step is typically to test it by building, e.g. `fv3-bundle`.  After verifying that the container works, then you can push it to Docker Hub with

.. code:: bash

  ./push_beta_to_latest.sh gnu-openmpi-dev beta

The first and second arguments are the name of the container (required) and the tag (optional, defaults to `beta`), as above.

This will save the previous `latest` image on Docker Hub with the `revert` tag, retag the new container as `latest` and push the new, latest container to Docker Hub.

*Please* `contact Mark Miesch`_, *if you need more libraries being included.*

.. _contact Mark Miesch: miesch@ucar.edu
