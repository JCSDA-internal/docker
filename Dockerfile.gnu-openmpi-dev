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
    && ./build_stack.sh "container-gnu-openmpi-dev" \
    && mv ../jedi-stack-contents.log /etc \
    && chmod a+r /etc/jedi-stack-contents.log \
    && rm -rf /root/jedi-stack \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /worktmp

#Make a non-root user:jedi / group:jedi for running MPI
RUN useradd -U -k /etc/skel -s /bin/bash -d /home/jedi -m jedi && \
    echo "export FC=mpifort" >> ~jedi/.bashrc && \
    echo "export CC=mpicc" >> ~jedi/.bashrc && \
    echo "export CXX=mpicxx" >> ~jedi/.bashrc && \
    echo "[credential]\n    helper = cache --timeout=7200" >> ~jedi/.gitconfig && \
    mkdir ~jedi/.openmpi && \
    echo "rmaps_base_oversubscribe = 1" >> ~jedi/.openmpi/mca-params.conf && \
    chown -R jedi:jedi ~jedi/.gitconfig ~jedi/.openmpi

#Setup the root users environment
ENV FC=mpifort \
   CC=mpicc \
   CXX=mpicxx

# build lcov for Travis-CI
RUN cd /usr/local/src \
    && curl -L -O http://downloads.sourceforge.net/ltp/lcov-1.14.tar.gz \
    && tar -xvf lcov-1.14.tar.gz \
    && cd lcov-1.14 \
    && make install \
    && rm -rf /usr/local/src/*

CMD ["/bin/bash" , "-l"]
