FROM  jcsda/docker_base:latest
LABEL maintainer "Xin Zhang <xin.l.zhang@noaa.gov>"

# install basic tools and openmpi
ENV NETCDF=/usr/local
ENV PNETCDF=/usr/local
ENV PIO=/usr/local
ENV BOOST_ROOT=/usr/local
ENV EIGEN3_INCLUDE_DIR=/usr/local
ENV LAPACK_PATH=/usr/local
ENV LAPACK_DIR=$LAPACK_PATH
ENV LAPACK_LIBRARIES="$LAPACK_PATH/lib/liblapack.a;$LAPACK_PATH/lib/libblas.a"

# build the common libraries for numerical weather prediction models
WORKDIR /usr/local
COPY CMake /usr/local/CMake
COPY CMakeLists.txt /usr/local
COPY nceplibs /usr/local/nceplibs
RUN mkdir -p build \
    && cd build \
    && rm -fr * \
    && cmake -DBUILD_OMPI=OFF .. \
    && make -j`nproc` \
    && cd /usr/local \
    && rm -fr CMake* build downloads \
    && cd /usr/local/nceplibs \
    && ./nceplibs.bash \
    && cd /usr/local \
    && rm -fr nceplibs

RUN git clone -b pio1_7_1  https://github.com/NCAR/ParallelIO.git \
    && cd ParallelIO \
    && git clone https://github.com/PARALLELIO/genf90 bin \
    && export MPIFC=mpif90 \
    && export PNETCDF_PATH=${PNETCDF} \
    && cd pio \
    && ./configure --prefix=/usr/local --disable-netcdf \
    && make \
    && make install \
    && rm -fr ParallelIO

# Copy over private key, and set permissions
ADD id_rsa /root/.ssh/id_rsa
# Make ssh dir
RUN mkdir -p /root/.ssh/ \
    # Create known_hosts
    && touch /root/.ssh/known_hosts \
    # Add github key
    && ssh-keyscan github.com >> /root/.ssh/known_hosts \
    # enter /usr/local/src
    && cd /usr/local/src \
    && git clone git@github.com:UCAR/ecbuild.git \
    && cd ecbuild \
    && mkdir build \
    && cd  build \
    && cmake .. \
    && make install \
    && cd ../../ \
    && rm -fr ecbuild \
    && git clone git@github.com:UCAR/eckit.git \
    && cd eckit \
    && mkdir build \
    && cd  build \
    && ecbuild .. \
    && make -j`nproc` \
    && make install \
    && cd ../../ \
    && rm -fr eckit \
    && git clone git@github.com:UCAR/fckit.git \
    && cd fckit \
    && mkdir build \
    && cd  build \
    && ecbuild .. \
    && make -j`nproc` \
    && make install \
    && cd ../../ \
    && rm -fr fckit
    
CMD ["/bin/bash" , "-l"]
