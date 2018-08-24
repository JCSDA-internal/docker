FROM  jcsda/docker_base_lfric:latest
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
RUN apt-get update \
    && apt-get install -y python-tk \
    && apt-get remove -y libhdf5-dev \
    && git config --global http.postBuffer 1048576000 \
    && mkdir -p build \
    && cd build \
    && rm -fr * \
    && cmake -DCMAKE_BUILD_TYPE=Debug -DBUILD_OMPI=OFF .. \
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
    && rm -fr ParallelIO \
    && ln -fs /usr/bin/gcc /usr/bin/x86_64-linux-gnu-gcc \
    && pip install setuptools \
    && pip install wheel \
    && pip install netCDF4 matplotlib


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
    && git clone https://github.com/ecmwf/ecbuild.git \
    && cd ecbuild \
    && git checkout 2.7.3 \
    && mkdir build \
    && cd  build \
    && cmake .. \
    && make install \
    && cd ../../ \
    && rm -fr ecbuild \
    && git clone https://github.com/ecmwf/eckit.git \
    && cd eckit \
    && git checkout 0.18.5 \
    && mkdir build \
    && cd  build \
    && ecbuild --build=debug .. \
    && make -j`nproc` \
    && make install \
    && cd ../../ \
    && rm -fr eckit \
    && git clone https://github.com/ecmwf/fckit.git \
    && cd fckit \
    && git checkout 0.5.0 \
    && mkdir build \
    && cd  build \
    && ecbuild --build=debug .. \
    && make -j`nproc` \
    && make install \
    && cd ../../ \
    && rm -fr fckit
    
CMD ["/bin/bash" , "-l"]
