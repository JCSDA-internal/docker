FROM  jcsda/docker_base:hpccm
LABEL maintainer "Mark Miesch <miesch@ucar.edu>"

# set environment variables manually
ENV NETCDF=/usr/local
ENV PNETCDF=/usr/local
ENV PIO=/usr/local
ENV BOOST_ROOT=/usr/local
ENV EIGEN3_INCLUDE_DIR=/usr/local
ENV LAPACK_PATH=/usr/local
ENV LAPACK_DIR=$LAPACK_PATH
ENV LAPACK_LIBRARIES="$LAPACK_PATH/lib/liblapack.a;$LAPACK_PATH/lib/libblas.a"
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages

# build the jedi stack
RUN git clone https://github.com/jcsda/jedi-stack.git \
    && cd jedi-stack/buildscripts \
    && git checkout feature/container \
    && ./build_stack.sh "container" \
    && rm -rf /var/lib/apt/lists/* \
    && mkdir /worktmp

CMD ["/bin/bash" , "-l"]
