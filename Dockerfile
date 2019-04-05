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
ENV PYTHONPATH=/usr/local/lib/python2.7/site-packages

# build the common libraries for numerical weather prediction models
WORKDIR /usr/local
COPY CMake /usr/local/CMake
COPY CMakeLists.txt /usr/local
COPY nceplibs /usr/local/nceplibs

# update repo key
RUN apt-key adv --keyserver keyserver.ubuntu.com --recv-keys 6B05F25D762E3157
RUN apt-get update \
    && apt-get install -y python-tk \
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
    && rm -fr nceplibs \
    && ln -fs /usr/bin/gcc /usr/bin/x86_64-linux-gnu-gcc \
    && python -m pip install -U pip setuptools \
    && python -m pip install wheel netCDF4 matplotlib \
# Compile ECMWF tools
    && cd /usr/local/src \
    && git clone https://github.com/ecmwf/ecbuild.git \
    && cd ecbuild \
    && git checkout 2.9.0 \
    && mkdir build \
    && cd  build \
    && cmake .. \
    && make install \
    && cd ../../ \
    && git clone https://github.com/ecmwf/eckit.git \
    && cd eckit \
    && git checkout 0.23.0 \
    && sed -i -e 's/project( eckit CXX/project( eckit CXX Fortran/' CMakeLists.txt \
    && mkdir build \
    && cd  build \
    && ecbuild --build=Debug .. \
    && make -j`nproc` \
    && make install \
    && cd ../../ \
    && rm -fr eckit \
    && git clone https://github.com/JCSDA/fckit.git \
    && cd fckit \
    && git checkout develop \
    && mkdir build \
    && cd  build \
    && ecbuild -build=Debug .. \
    && make -j`nproc` \
    && make install \
    && cd ../../ \
    && rm -fr ecbuild \
    && rm -fr fckit \
# Compile odb api
    && cd /usr/local/src \
    && wget https://confluence.ecmwf.int/download/attachments/61117379/odb_api_bundle-0.17.6-Source.tar.gz?api=v2 \
    && tar xvfz odb_api_bundle-0.17.6-Source.tar.gz?api=v2 \
    && cd odb_api_bundle-0.17.6-Source \
    && sed -i -e '/^ecbuild_bundle.* ecbuild /s/^/#/' CMakeLists.txt \
    && sed -i -e '/^ecbuild_bundle.* eckit /s/^/#/' CMakeLists.txt \
    && sed -i -e '/^ecbuild_bundle.* metkit /s/^/#/' CMakeLists.txt \
    && mkdir -p build_metkit build_odb \
    && cd build_metkit \
    && ecbuild --build=Production -DENABLE_GRIB=OFF ../metkit \
    && make -j4 \
    && make install \
    && cd ../build_odb \
    && ecbuild --build=Production -DENABLE_FORTRAN=1 -DENABLE_PYTHON=1 -DHAVE_CXX11=1 .. \
    && make -j4 \
    && make install \
    && cd /usr/local/src \
    && rm -fr * \
# Compiile ncepbufr for python
    && cd /usr/local/src \
    && git clone https://github.com/JCSDA/py-ncepbufr.git \
    && cd py-ncepbufr \
    && CC=gcc python setup.py build \
    && python setup.py install \
    && CC=gcc python3 setup.py build \
    && python3 setup.py install \
    && cp src/libbufr.a /usr/local/lib \
    && cd /usr/local/src \
    && rm -rf * \
# Add mount point for work directory
    && mkdir /worktmp

CMD ["/bin/bash" , "-l"]
