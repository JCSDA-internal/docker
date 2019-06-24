FROM  jcsda/docker_base:latest
LABEL maintainer "Mark Miesch <miesch@ucar.edu>"

# set environment variables manually
ENV NETCDF=/usr/local \
   PNETCDF=/usr/local \
   HDF5_ROOT=/usr/local \
   PIO=/usr/local \
   BOOST_ROOT=/usr/local \
   EIGEN3_INCLUDE_DIR=/usr/local \
   LAPACK_PATH=/usr/local \
   LAPACK_DIR=$LAPACK_PATH \
   LAPACK_LIBRARIES="$LAPACK_PATH/lib/liblapack.a;$LAPACK_PATH/lib/libblas.a" \
   PYTHONPATH=/usr/local/lib/python2.7/site-packages \
   SERIAL_CC=gcc \
   SERIAL_CXX=g++ \
   SERIAL_FC=gfortran \
   MPI_CC=mpicc \
   MPI_CXX=mpicxx \
   MPI_FC=mpifort

# build the jedi stack
RUN cd /root \
    && git clone https://github.com/jcsda/jedi-stack.git \
    && cd jedi-stack/buildscripts \
    && git checkout develop \
    && ./build_stack.sh "container" \
    && rm -rf /root/jedi-stack \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /worktmp

ENV FC=mpifort \
   CC=mpicc \
   CXX=mpicxx

CMD ["/bin/bash" , "-l"]
